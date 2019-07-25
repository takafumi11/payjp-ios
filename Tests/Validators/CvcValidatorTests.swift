//
//  CvcValidatorTests.swift
//  PAYJPTests
//
//  Created by Tadashi Wakayanagi on 2019/07/19.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import XCTest
@testable import PAYJP

class CvcValidatorTests: XCTestCase {

    let validator = CvcValidator()

    func testIsValid(cases: [(String, Bool)]) {
        for (input, expected) in cases {
            let valid = validator.isValid(cvc: input)
            XCTAssertEqual(valid, expected)
        }
    }

    func testCvcValidation() {
        let cases = [
            ("", false),
            ("1", false),
            ("12", false),
            ("123", true),
            ("1234", true),
            ("12345", false),
            ("a123", false),
            ("123a", false),
        ]
        testIsValid(cases: cases)
    }
}
