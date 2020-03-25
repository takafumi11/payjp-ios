//
//  String+PAYJPTests.swift
//  PAYJPTests
//
//  Created by Tadashi Wakayanagi on 2019/07/31.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import XCTest
@testable import PAYJP

// swiftlint:disable type_name
class String_PAYJPTests: XCTestCase {

    private func testNumberfy(cases: [(String, String)]) {
        for (input, expected) in cases {
            let filtered = input.numberfy()
            XCTAssertEqual(filtered, expected)
        }
    }

    func testStringToDigitString() {
        let cases = [
            ("", ""),
            ("12", "12"),
            ("1234 567", "1234567"),
            ("1234 5678 90", "1234567890"),
            ("1 @ 234 # 5", "12345")
        ]
        testNumberfy(cases: cases)
    }

    func testLocalizeString() {
        XCTAssertEqual("Please enter a card number.", "payjp_card_form_error_no_number".localized)
    }

    func testIsDigistOnly() {
        XCTAssertTrue("1".isDigitsOnly)
        XCTAssertTrue("1234".isDigitsOnly)
        XCTAssertFalse("a1".isDigitsOnly)
        XCTAssertFalse("abc".isDigitsOnly)
    }

    func testCapture() {
        let pattern = "^(https?)://([^/]+)/?"
        let target = "https://pay.jp/"

        let result = target.capture(pattern: pattern, group: 2)
        XCTAssertEqual(result, "pay.jp")
    }

    func testCapture_nil() {
        let pattern = "^(https?)://([^/]+)/?"
        let target = "pay.jp"

        let result = target.capture(pattern: pattern, group: 1)
        XCTAssertNil(result)
    }

    func testCaptureMulti() {
        let pattern = "^(https?)://([^/]+)/?"
        let target = "https://pay.jp/"

        let result = target.capture(pattern: pattern, group: [1, 2])
        XCTAssertEqual(result[0], "https")
        XCTAssertEqual(result[1], "pay.jp")
    }

    func testCaptureMulti_empty() {
        let pattern = "^(https?)://([^/]+)/?"
        let target = "pay.jp"

        let result = target.capture(pattern: pattern, group: [1, 2])
        XCTAssertTrue(result.isEmpty)
    }
}
// swiftlint:enable type_name
