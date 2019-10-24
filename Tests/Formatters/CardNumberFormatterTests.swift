//
//  CardNumberFormatterTests.swift
//  PAYJPTests
//
//  Created by Tadashi Wakayanagi on 2019/07/17.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import XCTest
@testable import PAYJP

class CardNumberFormatterTests: XCTestCase {

    let formatter = CardNumberFormatter()

    private func testCardNumberFormat(cases: [(String, CardNumber)]) {
        for (input, expected) in cases {
            if let output = formatter.string(from: input) {
                XCTAssertEqual(output.formatted, expected.formatted)
                XCTAssertEqual(output.brand, expected.brand)
            }
        }
    }

    func testVisaNumberFormat() {
        let cases = [
            ("42", CardNumber(formatted: "42", brand: .visa)),
            ("4242111", CardNumber(formatted: "4242-111", brand: .visa)),
            ("424211112222", CardNumber(formatted: "4242-1111-2222", brand: .visa)),
            ("4242111122223333", CardNumber(formatted: "4242-1111-2222-3333", brand: .visa)),
            ("42421111222233334444", CardNumber(formatted: "4242-1111-2222-3333", brand: .visa))
        ]
        testCardNumberFormat(cases: cases)
    }

    func testMastercardNumberFormat() {
        let cases = [
            ("51", CardNumber(formatted: "51", brand: .mastercard)),
            ("5211222", CardNumber(formatted: "5211-222", brand: .mastercard)),
            ("222122223333", CardNumber(formatted: "2221-2222-3333", brand: .mastercard)),
            ("2533111122223333", CardNumber(formatted: "2533-1111-2222-3333", brand: .mastercard)),
            ("25331111222233334444", CardNumber(formatted: "2533-1111-2222-3333", brand: .mastercard))
        ]
        testCardNumberFormat(cases: cases)
    }

    func testJCBNumberFormat() {
        let cases = [
            ("353", CardNumber(formatted: "353", brand: .jcb)),
            ("3581222", CardNumber(formatted: "3581-222", brand: .jcb)),
            ("352822223333", CardNumber(formatted: "3528-2222-3333", brand: .jcb)),
            ("3529222233334444", CardNumber(formatted: "3529-2222-3333-4444", brand: .jcb)),
            ("35292222333344445555", CardNumber(formatted: "3529-2222-3333-4444", brand: .jcb))
        ]
        testCardNumberFormat(cases: cases)
    }

    func testAmexNumberFormat() {
        let cases = [
            ("34", CardNumber(formatted: "34", brand: .americanExpress)),
            ("341122", CardNumber(formatted: "3411-22", brand: .americanExpress)),
            ("371122223333", CardNumber(formatted: "3711-222233-33", brand: .americanExpress)),
            ("371122223333444", CardNumber(formatted: "3711-222233-33444", brand: .americanExpress)),
            ("37112222333344445555", CardNumber(formatted: "3711-222233-33444", brand: .americanExpress))
        ]
        testCardNumberFormat(cases: cases)
    }

    func testDinersNumberFormat() {
        let cases = [
            ("300", CardNumber(formatted: "300", brand: .dinersClub)),
            ("361122", CardNumber(formatted: "3611-22", brand: .dinersClub)),
            ("381122223333", CardNumber(formatted: "3811-222233-33", brand: .dinersClub)),
            ("38112222333344", CardNumber(formatted: "3811-222233-3344", brand: .dinersClub)),
            ("38112222333344445555", CardNumber(formatted: "3811-222233-3344", brand: .dinersClub))
        ]
        testCardNumberFormat(cases: cases)
    }

    func testUnknownNumberFormat() {
        let cases = [
            ("9999999999999999", CardNumber(formatted: "9999-9999-9999-9999", brand: .unknown)),
            ("99999999999999999999999999999999", CardNumber(formatted: "9999-9999-9999-9999", brand: .unknown))
        ]
        testCardNumberFormat(cases: cases)
    }
}
