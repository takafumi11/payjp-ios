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

    private func testIsValid(cases: [(String, CardBrand, Bool)]) {
        for (number, brand, expected) in cases {
            let valid = validator.isValid(cardNumber: number, brand: brand)
            XCTAssertEqual(valid, expected)
        }
    }

    func testCardNumberValidation() {
        let cases: [(String, CardBrand, Bool)] = [
            // 13桁
            ("1234567890123", .unknown, false),
            // luhn NG
            ("12345678901234", .unknown, false),
            // luhn OK
            ("12345678901237", .unknown, false),
            ("4242424242424242", .unknown, true),
            ("12345678901234569", .unknown, false),
            ("12345678901237ab", .unknown, false),
            ("ab12345678901237", .unknown, false),
            // Visa
            ("4200250796648831", .visa, true),
            ("4929613427952262", .visa, true),
            ("4929610527143692", .visa, false),
            // Master
            ("5269278488737492", .mastercard, true),
            ("5106733522040110", .mastercard, true),
            ("5589306849102132", .mastercard, false),
            // JCB
            ("3533401879982122", .jcb, true),
            ("3535909680226735", .jcb, true),
            ("3534067821171002", .jcb, false),
            // Amex
            ("346191816620108", .americanExpress, true),
            ("341179142096577", .americanExpress, true),
            ("372086951160373", .americanExpress, false),
            // Discover
            ("6011341651562441", .discover, true),
            ("6011290763638088", .discover, true),
            ("6011621030885715", .discover, false),
            // Diners
            ("36868003801279", .dinersClub, true),
            ("36785415704877", .dinersClub, true),
            ("36267608413862", .dinersClub, false)
        ]
        testIsValid(cases: cases)
    }
}
