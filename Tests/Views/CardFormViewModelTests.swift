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
        case .failure(let error):
            switch error {
            case .cardNumberEmptyError(value: nil, instant: false):
                break
            default:
                XCTFail()
            }
        default:
            XCTFail()
        }
    }

    func testUpdateCardNumberNil() {
        let result = viewModel.updateCardNumber(input: nil)

        switch result {
        case .failure(let error):
            switch error {
            case .cardNumberEmptyError(value: nil, instant: false):
                break
            default:
                XCTFail()
            }
        default:
            XCTFail()
        }
    }

    func testUpdateCardNumberInvalidLength() {
        let result = viewModel.updateCardNumber(input: "4242424242")
//        let cardNumber = CardNumber(formatted: "4242 4242 42", brand: .visa)

        switch result {
        case .failure(let error):
            switch error {
            case .cardNumberInvalidError(value: _, instant: false):
                break
            default:
                XCTFail()
            }
        default:
            XCTFail()
        }
    }

    func testUpdateCardNumberInvalidLuhn() {
        let result = viewModel.updateCardNumber(input: "4242424242424241")
        //        let cardNumber = CardNumber(formatted: "4242 4242 4242 4241", brand: .visa)

        switch result {
        case .failure(let error):
            switch error {
            case .cardNumberInvalidError(value: _, instant: true):
                break
            default:
                XCTFail()
            }
        default:
            XCTFail()
        }
    }

    // TODO: ブランド判定を修正してから直す
//    func testUpdateCardNumberUnknownBrand() {
//        let result = viewModel.updateCardNumber(input: "0")
//        //        let cardNumber = CardNumber(formatted: "0", brand: .unknown)
//
//        switch result {
//        case .failure(let error):
//            switch error {
//            case .cardNumberInvalidBrandError(value: _, instant: true):
//                break
//            default:
//                XCTFail()
//            }
//        default:
//            XCTFail()
//        }
//    }

    func testUpdateCardNumberSuccess() {
        let result = viewModel.updateCardNumber(input: "4242424242424242")

        switch result {
        case .success(let value):
            XCTAssertEqual(value.formatted, "4242 4242 4242 4242")
            XCTAssertEqual(value.brand, .visa)
            break
        default:
            XCTFail()
        }
    }

    func testUpdateExpirationEmpty() {
        let result = viewModel.updateExpiration(input: "")

        switch result {
        case .failure(let error):
            switch error {
            case .expirationEmptyError(value: nil, instant: false):
                break
            default:
                XCTFail()
            }
        default:
            XCTFail()
        }
    }

    func testUpdateExpirationNil() {
        let result = viewModel.updateExpiration(input: nil)

        switch result {
        case .failure(let error):
            switch error {
            case .expirationEmptyError(value: nil, instant: false):
                break
            default:
                XCTFail()
            }
        default:
            XCTFail()
        }
    }

    func testUpdateExpirationInvalidMonth() {
        let result = viewModel.updateExpiration(input: "20")

        switch result {
        case .failure(let error):
            switch error {
            case .expirationInvalidError(value: "20", instant: true):
                break
            default:
                XCTFail()
            }
        default:
            XCTFail()
        }
    }

    func testUpdateExpirationInvalidYear() {
        let result = viewModel.updateExpiration(input: "08/10")

        switch result {
        case .failure(let error):
            switch error {
            case .expirationInvalidError(value: "08/10", instant: true):
                break
            default:
                XCTFail()
            }
        default:
            XCTFail()
        }
    }

    func testUpdateExpirationOneDigitMonth() {
        let result = viewModel.updateExpiration(input: "1")

        switch result {
        case .failure(let error):
            switch error {
            case .expirationInvalidError(value: "1", instant: false):
                break
            default:
                XCTFail()
            }
        default:
            XCTFail()
        }
    }

    func testUpdateExpirationSuccess() {
        let result = viewModel.updateExpiration(input: "12/99")

        switch result {
        case .success(let value):
            XCTAssertEqual(value, "12/99")
            break
        default:
            XCTFail()
        }
    }

    func testUpdateCvcEmpty() {
        let result = viewModel.updateCvc(input: "")

        switch result {
        case .failure(let error):
            switch error {
            case .cvcEmptyError(value: nil, instant: false):
                break
            default:
                XCTFail()
            }
        default:
            XCTFail()
        }
    }

    func testUpdateCvcNil() {
        let result = viewModel.updateCvc(input: nil)

        switch result {
        case .failure(let error):
            switch error {
            case .cvcEmptyError(value: nil, instant: false):
                break
            default:
                XCTFail()
            }
        default:
            XCTFail()
        }
    }

    func testUpdateCvcInvalid() {
        let result = viewModel.updateCvc(input: "12")

        switch result {
        case .failure(let error):
            switch error {
            case .cvcInvalidError(value: "12", instant: false):
                break
            default:
                XCTFail()
            }
        default:
            XCTFail()
        }
    }

    func testUpdateCvcSuccess() {
        let result = viewModel.updateCvc(input: "123")

        switch result {
        case .success(let value):
            XCTAssertEqual(value, "123")
            break
        default:
            XCTFail()
        }
    }

    func testUpdateCardHolderEmpty() {
        let result = viewModel.updateCardHolder(input: "")

        switch result {
        case .failure(let error):
            switch error {
            case .cardHolderEmptyError(value: nil, instant: false):
                break
            default:
                XCTFail()
            }
        default:
            XCTFail()
        }
    }

    func testUpdateCardHolderNil() {
        let result = viewModel.updateCardHolder(input: nil)

        switch result {
        case .failure(let error):
            switch error {
            case .cardHolderEmptyError(value: nil, instant: false):
                break
            default:
                XCTFail()
            }
        default:
            XCTFail()
        }
    }

    func testUpdateCardHolderSuccess() {
        let result = viewModel.updateCardHolder(input: "PAY TARO")

        switch result {
        case .success(let value):
            XCTAssertEqual(value, "PAY TARO")
            break
        default:
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
