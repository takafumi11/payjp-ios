//
//  ErrorTranslatorTests.swift
//  PAYJPTests
//
//  Created by Tadashi Wakayanagi on 2019/11/29.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import XCTest
@testable import PAYJP

// swiftlint:disable force_try
class ErrorTranslatorTests: XCTestCase {

    let translator = ErrorTranslator()

    let nsErrorConverter = NSErrorConverter.shared
    let decoder = JSONDecoder.shared

    func testTranslate_error402() {
        let json = TestFixture.JSON(by: "error_402.json")
        let payError = try! decoder.decode(PAYErrorResult.self, from: json).error
        let apiError = APIError.serviceError(payError)

        let result = translator.translate(error: apiError)
        XCTAssertEqual(result, "402 error")
    }

    func testTranslate_error401() {
        let json = TestFixture.JSON(by: "error_401.json")
        let payError = try! decoder.decode(PAYErrorResult.self, from: json).error
        let apiError = APIError.serviceError(payError)

        let result = translator.translate(error: apiError)
        XCTAssertEqual(result, "payjp_card_form_screen_error_application".localized)
    }

    func testTranslate_error500() {
        let json = TestFixture.JSON(by: "error_500.json")
        let payError = try! decoder.decode(PAYErrorResult.self, from: json).error
        let apiError = APIError.serviceError(payError)

        let result = translator.translate(error: apiError)
        XCTAssertEqual(result, "payjp_card_form_screen_error_server".localized)
    }

    func testTranslate_systemError() {
        let error = NSError(domain: "domain", code: -1, userInfo: nil)
        let apiError = APIError.systemError(error)

        let result = translator.translate(error: apiError)
        XCTAssertEqual(result, "payjp_card_form_screen_error_network".localized)
    }

    func testTranslate_unknownError() {
        let apiError = APIError.invalidResponse(nil)

        let result = translator.translate(error: apiError)
        XCTAssertEqual(result, "payjp_card_form_screen_error_unknown".localized)
    }

    func testTranslate_notApiError() {
        let error = LocalError.invalidFormInput

        let result = translator.translate(error: error)
        XCTAssertEqual(result, "Form input data is invalid.")
    }
}
// swiftlint:enable force_try
