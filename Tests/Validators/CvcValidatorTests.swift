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

    func testIsValid(cases: [(String, CardBrand, (Bool, Bool))]) {
        for (cvc, brand, expected) in cases {
            let result = validator.isValid(cvc: cvc, brand: brand)
            XCTAssertEqual(result.validated, expected.0)
            XCTAssertEqual(result.isInstant, expected.1)
        }
    }

    func testCvcValidation() {
        let cases: [(String, CardBrand, (Bool, Bool))] = [
            ("", .unknown, (false, false)),
            ("", .visa, (false, false)),
            ("", .americanExpress, (false, false)),
            ("1", .unknown, (false, false)),
            ("1", .mastercard, (false, false)),
            ("1", .americanExpress, (false, false)),
            ("12", .unknown, (false, false)),
            ("12", .jcb, (false, false)),
            ("12", .americanExpress, (false, false)),
            ("123", .unknown, (false, false)),
            ("123", .dinersClub, (true, false)),
            ("123", .americanExpress, (false, false)),
            ("1234", .unknown, (true, false)),
            ("1234", .discover, (false, true)),
            ("1234", .americanExpress, (true, false)),
            ("12345", .unknown, (false, true)),
            ("12345", .visa, (false, true)),
            ("12345", .americanExpress, (false, true)),
            ("a123", .unknown, (false, false)),
            ("a123", .mastercard, (false, false)),
            ("a123", .americanExpress, (false, false)),
            ("123a", .unknown, (false, false)),
            ("123a", .jcb, (false, false)),
            ("123a", .americanExpress, (false, false))
        ]
        testIsValid(cases: cases)
    }
}
