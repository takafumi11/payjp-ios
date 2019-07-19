//
//  CardNumberValidatorTests.swift
//  PAYJPTests
//
//  Created by Tadashi Wakayanagi on 2019/07/19.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import XCTest
@testable import PAYJP

class CardNumberValidatorTests: XCTestCase {

    let validator = CardNumberValidator()

    private func testIsValid(cases: [(String, Bool)]) {
        for (input, expected) in cases {
            let valid = validator.isValid(cardNumber: input)
            XCTAssertEqual(valid, expected)
        }
    }

    func testCardNumberValidation() {
        let cases = [
            // 13桁
            ("1234567890123", false),
            // luhn NG
            ("12345678901234", false),
            // luhn OK
            ("12345678901237", true),
            ("4242424242424242", true),
            ("12345678901234569", false),
            ("12345678901237ab", false),
            ("ab12345678901237", false),
            // Visa
            ("4200250796648831", true),
            ("4929613427952262", true),
            ("4929610527143692", false),
            // Master
            ("5269278488737492", true),
            ("5106733522040110", true),
            ("5589306849102132", false),
            // JCB
            ("3533401879982122", true),
            ("3535909680226735", true),
            ("3534067821171002", false),
            // Amex
            ("346191816620108", true),
            ("341179142096577", true),
            ("372086951160373", false),
            // Discover
            ("6011341651562441", true),
            ("6011290763638088", true),
            ("6011621030885715", false),
            // Diners
            ("36868003801279", true),
            ("36785415704877", true),
            ("36267608413862", false)
        ]
        testIsValid(cases: cases)
    }
}
