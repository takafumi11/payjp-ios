//
//  CardFormViewModelTests.swift
//  PAYJPTests
//
//  Created by Tadashi Wakayanagi on 2019/08/08.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import XCTest
@testable import PAYJP

class CardFormViewModelTests: XCTestCase {

    let viewModel = CardFormViewViewModel()

    func testUpdateCardNumberEmpty() {
        let result = viewModel.updateCardNumber(input: "")

        switch result {
        case .failure:
            XCTAssert(true)
        default:
            print(result)
            XCTFail()
        }

        do {
            let _ = try result.get()
        } catch {
            switch error {
            case FormError<CardNumber>.error(value: nil, message: "カード番号を入力してください"):
                XCTAssert(true)
            default:
                print(error)
                XCTFail()
            }
        }
    }

    func testUpdateCardNumberNil() {
        let result = viewModel.updateCardNumber(input: nil)

        switch result {
        case .failure:
            XCTAssert(true)
        default:
            print(result)
            XCTFail()
        }

        do {
            let _ = try result.get()
        } catch {
            switch error {
            case FormError<CardNumber>.error(value: nil, message: "カード番号を入力してください"):
                XCTAssert(true)
            default:
                print(error)
                XCTFail()
            }
        }
    }

    func testUpdateCardNumberInvalidLength() {
        let result = viewModel.updateCardNumber(input: "4242424242")
//        let cardNumber = CardNumber(formatted: "4242 4242 42", brand: .visa)

        switch result {
        case .failure:
            XCTAssert(true)
        default:
            print(result)
            XCTFail()
        }

        do {
            let _ = try result.get()
        } catch {
            switch error {
            case FormError<CardNumber>.error(value: _, message: "正しいカード番号を入力してください"):
                XCTAssert(true)
            default:
                print(error)
                XCTFail()
            }
        }
    }

    func testUpdateCardNumberInvalidLuhn() {
        let result = viewModel.updateCardNumber(input: "4242424242424241")
        //        let cardNumber = CardNumber(formatted: "4242 4242 4242 4241", brand: .visa)

        switch result {
        case .failure:
            XCTAssert(true)
        default:
            print(result)
            XCTFail()
        }

        do {
            let _ = try result.get()
        } catch {
            switch error {
            case FormError<CardNumber>.instantError(value: _, message: "正しいカード番号を入力してください"):
                XCTAssert(true)
            default:
                print(error)
                XCTFail()
            }
        }
    }

    // TODO: ブランド判定を修正してから直す
//    func testUpdateCardNumberUnknownBrand() {
//        let result = viewModel.updateCardNumber(input: "0")
//        //        let cardNumber = CardNumber(formatted: "0", brand: .unknown)
//
//        switch result {
//        case .failure:
//            XCTAssert(true)
//        default:
//            print(result)
//            XCTFail()
//        }
//
//        do {
//            let _ = try result.get()
//        } catch {
//            switch error {
//            case FormError<CardNumber>.error(value: _, message: "カードブランドが有効ではありません"):
//                XCTAssert(true)
//            default:
//                print(error)
//                XCTFail()
//            }
//        }
//    }

    func testUpdateCardNumberSuccess() {
        let result = viewModel.updateCardNumber(input: "4242424242424242")

        switch result {
        case .success:
            XCTAssert(true)
        default:
            print(result)
            XCTFail()
        }

        do {
            let input = try result.get()
            XCTAssertEqual(input.formatted, "4242 4242 4242 4242")
            XCTAssertEqual(input.brand, .visa)
        } catch {
            XCTFail()
        }
    }

    func testUpdateExpirationEmpty() {
        let result = viewModel.updateExpiration(input: "")

        switch result {
        case .failure:
            XCTAssert(true)
        default:
            print(result)
            XCTFail()
        }

        do {
            let _ = try result.get()
        } catch {
            switch error {
            case FormError<String>.error(value: nil, message: "有効期限を入力してください"):
                XCTAssert(true)
            default:
                print(error)
                XCTFail()
            }
        }
    }

    func testUpdateExpirationNil() {
        let result = viewModel.updateExpiration(input: nil)

        switch result {
        case .failure:
            XCTAssert(true)
        default:
            print(result)
            XCTFail()
        }

        do {
            let _ = try result.get()
        } catch {
            switch error {
            case FormError<String>.error(value: nil, message: "有効期限を入力してください"):
                XCTAssert(true)
            default:
                print(error)
                XCTFail()
            }
        }
    }

    func testUpdateExpirationInvalidMonth() {
        let result = viewModel.updateExpiration(input: "20")

        switch result {
        case .failure:
            XCTAssert(true)
        default:
            print(result)
            XCTFail()
        }

        do {
            let _ = try result.get()
        } catch {
            switch error {
            case FormError<String>.instantError(value: "20", message: "正しい有効期限を入力してください"):
                XCTAssert(true)
            default:
                print(error)
                XCTFail()
            }
        }
    }

    func testUpdateExpirationInvalidYear() {
        let result = viewModel.updateExpiration(input: "08/10")

        switch result {
        case .failure:
            XCTAssert(true)
        default:
            print(result)
            XCTFail()
        }

        do {
            let _ = try result.get()
        } catch {
            switch error {
            case FormError<String>.instantError(value: "08/10", message: "正しい有効期限を入力してください"):
                XCTAssert(true)
            default:
                print(error)
                XCTFail()
            }
        }
    }

    func testUpdateExpirationOneDigitMonth() {
        let result = viewModel.updateExpiration(input: "1")

        switch result {
        case .failure:
            XCTAssert(true)
        default:
            print(result)
            XCTFail()
        }

        do {
            let _ = try result.get()
        } catch {
            switch error {
            case FormError<String>.error(value: "1", message: "正しい有効期限を入力してください"):
                XCTAssert(true)
            default:
                print(error)
                XCTFail()
            }
        }
    }

    func testUpdateExpirationSuccess() {
        let result = viewModel.updateExpiration(input: "12/99")

        switch result {
        case .success:
            XCTAssert(true)
        default:
            print(result)
            XCTFail()
        }

        do {
            let input = try result.get()
            XCTAssertEqual(input, "12/99")
        } catch {
            XCTFail()
        }
    }

    func testUpdateCvcEmpty() {
        let result = viewModel.updateCvc(input: "")

        switch result {
        case .failure:
            XCTAssert(true)
        default:
            print(result)
            XCTFail()
        }

        do {
            let _ = try result.get()
        } catch {
            switch error {
            case FormError<String>.error(value: nil, message: "CVCを入力してください"):
                XCTAssert(true)
            default:
                print(error)
                XCTFail()
            }
        }
    }

    func testUpdateCvcNil() {
        let result = viewModel.updateCvc(input: nil)

        switch result {
        case .failure:
            XCTAssert(true)
        default:
            print(result)
            XCTFail()
        }

        do {
            let _ = try result.get()
        } catch {
            switch error {
            case FormError<String>.error(value: nil, message: "CVCを入力してください"):
                XCTAssert(true)
            default:
                print(error)
                XCTFail()
            }
        }
    }

    func testUpdateCvcInvalid() {
        let result = viewModel.updateCvc(input: "12")

        switch result {
        case .failure:
            XCTAssert(true)
        default:
            print(result)
            XCTFail()
        }

        do {
            let _ = try result.get()
        } catch {
            switch error {
            case FormError<String>.error(value: "12", message: "正しいCVCを入力してください"):
                XCTAssert(true)
            default:
                print(error)
                XCTFail()
            }
        }
    }

    func testUpdateCvcSuccess() {
        let result = viewModel.updateCvc(input: "123")

        switch result {
        case .success:
            XCTAssert(true)
        default:
            print(result)
            XCTFail()
        }

        do {
            let input = try result.get()
            XCTAssertEqual(input, "123")
        } catch {
            XCTFail()
        }
    }

    func testUpdateCardHolderEmpty() {
        let result = viewModel.updateCardHolder(input: "")

        switch result {
        case .failure:
            XCTAssert(true)
        default:
            print(result)
            XCTFail()
        }

        do {
            let _ = try result.get()
        } catch {
            switch error {
            case FormError<String>.error(value: nil, message: "カード名義を入力してください"):
                XCTAssert(true)
            default:
                print(error)
                XCTFail()
            }
        }
    }

    func testUpdateCardHolderNil() {
        let result = viewModel.updateCardHolder(input: nil)

        switch result {
        case .failure:
            XCTAssert(true)
        default:
            print(result)
            XCTFail()
        }

        do {
            let _ = try result.get()
        } catch {
            switch error {
            case FormError<String>.error(value: nil, message: "カード名義を入力してください"):
                XCTAssert(true)
            default:
                print(error)
                XCTFail()
            }
        }
    }

    func testUpdateCardHolderSuccess() {
        let result = viewModel.updateCardHolder(input: "PAY TARO")

        switch result {
        case .success:
            XCTAssert(true)
        default:
            print(result)
            XCTFail()
        }

        do {
            let input = try result.get()
            XCTAssertEqual(input, "PAY TARO")
        } catch {
            XCTFail()
        }
    }

    func testIsValidAllValid() {
        let _ = viewModel.updateCardNumber(input: "4242424242424242")
        let _ = viewModel.updateExpiration(input: "12/99")
        let _ = viewModel.updateCvc(input: "123")
        let _ = viewModel.updateCardHolder(input: "PAY TARO")

        let result = viewModel.isValid()
        XCTAssertTrue(result)
    }

    func testIsValidNotAllValid() {
        let _ = viewModel.updateCardNumber(input: "4242424242424242")
        let _ = viewModel.updateExpiration(input: "12/9")
        let _ = viewModel.updateCvc(input: "123")
        let _ = viewModel.updateCardHolder(input: "PAY TARO")

        let result = viewModel.isValid()
        XCTAssertFalse(result)
    }
}
