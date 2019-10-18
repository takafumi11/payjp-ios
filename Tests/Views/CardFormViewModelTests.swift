//
//  CardFormViewModelTests.swift
//  PAYJPTests
//
//  Created by Tadashi Wakayanagi on 2019/08/08.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import XCTest
@testable import PAYJP

// swiftlint:disable type_body_length
class CardFormViewModelTests: XCTestCase {

    let viewModel = CardFormViewViewModel()

    func testUpdateCardNumberEmpty() {
        let result = viewModel.update(cardNumber: "")

        switch result {
        case .failure(let error):
            switch error {
            case .cardNumberEmptyError(value: nil, isInstant: false):
                break
            default:
                XCTFail()
            }
        default:
            XCTFail()
        }
    }

    func testUpdateCardNumberNil() {
        let result = viewModel.update(cardNumber: nil)

        switch result {
        case .failure(let error):
            switch error {
            case .cardNumberEmptyError(value: nil, isInstant: false):
                break
            default:
                XCTFail()
            }
        default:
            XCTFail()
        }
    }

    func testUpdateCardNumberInvalidLength() {
        let result = viewModel.update(cardNumber: "4242424242")
        //        let cardNumber = CardNumber(formatted: "4242 4242 42", brand: .visa)

        switch result {
        case .failure(let error):
            switch error {
            case .cardNumberInvalidError(value: _, isInstant: false):
                break
            default:
                XCTFail()
            }
        default:
            XCTFail()
        }
    }

    func testUpdateCardNumberInvalidLuhn() {
        let result = viewModel.update(cardNumber: "4242424242424241")
        //        let cardNumber = CardNumber(formatted: "4242 4242 4242 4241", brand: .visa)

        switch result {
        case .failure(let error):
            switch error {
            case .cardNumberInvalidError(value: _, isInstant: true):
                break
            default:
                XCTFail()
            }
        default:
            XCTFail()
        }
    }

    func testUpdateCardNumberSuccess() {
        let result = viewModel.update(cardNumber: "4242424242424242")

        switch result {
        case .success(let value):
            XCTAssertEqual(value.formatted, "4242-4242-4242-4242")
            XCTAssertEqual(value.brand, .visa)
        default:
            XCTFail()
        }
    }

    func testUpdateExpirationEmpty() {
        let result = viewModel.update(expiration: "")

        switch result {
        case .failure(let error):
            switch error {
            case .expirationEmptyError(value: nil, isInstant: false):
                break
            default:
                XCTFail()
            }
        default:
            XCTFail()
        }
    }

    func testUpdateExpirationNil() {
        let result = viewModel.update(expiration: nil)

        switch result {
        case .failure(let error):
            switch error {
            case .expirationEmptyError(value: nil, isInstant: false):
                break
            default:
                XCTFail()
            }
        default:
            XCTFail()
        }
    }

    func testUpdateExpirationInvalidMonth() {
        let result = viewModel.update(expiration: "20")

        switch result {
        case .failure(let error):
            switch error {
            case .expirationInvalidError(value: "20", isInstant: true):
                break
            default:
                XCTFail()
            }
        default:
            XCTFail()
        }
    }

    func testUpdateExpirationInvalidYear() {
        let result = viewModel.update(expiration: "08/10")

        switch result {
        case .failure(let error):
            switch error {
            case .expirationInvalidError(value: "08/10", isInstant: true):
                break
            default:
                XCTFail()
            }
        default:
            XCTFail()
        }
    }

    func testUpdateExpirationOneDigitMonth() {
        let result = viewModel.update(expiration: "1")

        switch result {
        case .failure(let error):
            switch error {
            case .expirationInvalidError(value: "1", isInstant: false):
                break
            default:
                XCTFail()
            }
        default:
            XCTFail()
        }
    }

    func testUpdateExpirationSuccess() {
        let result = viewModel.update(expiration: "12/99")

        switch result {
        case .success(let value):
            XCTAssertEqual(value, "12/99")
        default:
            XCTFail()
        }
    }

    func testUpdateCvcEmpty() {
        let result = viewModel.update(cvc: "")

        switch result {
        case .failure(let error):
            switch error {
            case .cvcEmptyError(value: nil, isInstant: false):
                break
            default:
                XCTFail()
            }
        default:
            XCTFail()
        }
    }

    func testUpdateCvcNil() {
        let result = viewModel.update(cvc: nil)

        switch result {
        case .failure(let error):
            switch error {
            case .cvcEmptyError(value: nil, isInstant: false):
                break
            default:
                XCTFail()
            }
        default:
            XCTFail()
        }
    }

    func testUpdateCvcInvalid() {
        let result = viewModel.update(cvc: "12")

        switch result {
        case .failure(let error):
            switch error {
            case .cvcInvalidError(value: "12", isInstant: false):
                break
            default:
                XCTFail()
            }
        default:
            XCTFail()
        }
    }

    func testUpdateCvcSuccess() {
        _ = viewModel.update(cardNumber: "42")
        let result = viewModel.update(cvc: "123")

        switch result {
        case .success(let value):
            XCTAssertEqual(value, "123")
        default:
            XCTFail()
        }
    }

    func testUpdateCvcWhenBrandChanged() {
        _ = viewModel.update(cardNumber: "4242")
        let result = viewModel.update(cvc: "1234")

        switch result {
        case .failure(let error):
            switch error {
            case .cvcInvalidError(value: "1234", isInstant: true):
                break
            default:
                XCTFail()
            }
        default:
            XCTFail()
        }
    }

    func testUpdateCardHolderEmpty() {
        let result = viewModel.update(cardHolder: "")

        switch result {
        case .failure(let error):
            switch error {
            case .cardHolderEmptyError(value: nil, isInstant: false):
                break
            default:
                XCTFail()
            }
        default:
            XCTFail()
        }
    }

    func testUpdateCardHolderNil() {
        let result = viewModel.update(cardHolder: nil)

        switch result {
        case .failure(let error):
            switch error {
            case .cardHolderEmptyError(value: nil, isInstant: false):
                break
            default:
                XCTFail()
            }
        default:
            XCTFail()
        }
    }

    func testUpdateCardHolderSuccess() {
        let result = viewModel.update(cardHolder: "PAY TARO")

        switch result {
        case .success(let value):
            XCTAssertEqual(value, "PAY TARO")
        default:
            XCTFail()
        }
    }

    func testIsValidAllValid() {
        viewModel.update(isCardHolderEnabled: true)

        _ = viewModel.update(cardNumber: "4242424242424242")
        _ = viewModel.update(expiration: "12/99")
        _ = viewModel.update(cvc: "123")
        _ = viewModel.update(cardHolder: "PAY TARO")

        let result = viewModel.isValid
        XCTAssertTrue(result)
    }

    func testIsValidNotAllValid() {
        viewModel.update(isCardHolderEnabled: true)

        _ = viewModel.update(cardNumber: "4242424242424242")
        _ = viewModel.update(expiration: "12/9")
        _ = viewModel.update(cvc: "123")
        _ = viewModel.update(cardHolder: "PAY TARO")

        let result = viewModel.isValid
        XCTAssertFalse(result)
    }

    func testIsValidAllValidCardHolderDisabled() {
        viewModel.update(isCardHolderEnabled: false)

        _ = viewModel.update(cardNumber: "4242424242424242")
        _ = viewModel.update(expiration: "12/99")
        _ = viewModel.update(cvc: "123")

        let result = viewModel.isValid
        XCTAssertTrue(result)
    }

    func testIsValidNotAllValidCardHolderDisabled() {
        viewModel.update(isCardHolderEnabled: false)

        _ = viewModel.update(cardNumber: "4242424242424242")
        _ = viewModel.update(expiration: "12/99")
        _ = viewModel.update(cvc: "1")

        let result = viewModel.isValid
        XCTAssertFalse(result)
    }
}
// swiftlint:enable type_body_length
