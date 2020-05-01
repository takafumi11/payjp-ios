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

    private func testCardNumberFormat(cases: [(String, String, CardNumber)]) {
        for (input, separator, expected) in cases {
            if let output = formatter.string(from: input, separator: separator) {
                XCTAssertEqual(output.formatted, expected.formatted)
                XCTAssertEqual(output.brand, expected.brand)
                XCTAssertEqual(output.display, expected.display)
            }
        }
    }

    func testVisaNumberFormat() {
        let cases = [
            ("42", "-", CardNumber(value: "42",
                                   formatted: "42",
                                   brand: .visa,
                                   display: "42XX-XXXX-XXXX-XXXX",
                                   mask: "")),
            ("4242111", "-", CardNumber(value: "4242111",
                                        formatted: "4242-111",
                                        brand: .visa,
                                        display: "4242-111X-XXXX-XXXX",
                                        mask: "")),
            ("424211112222", "-", CardNumber(value: "424211112222",
                                             formatted: "4242-1111-2222",
                                             brand: .visa,
                                             display: "4242-1111-2222-XXXX",
                                             mask: "")),
            ("4242111122223333", " ", CardNumber(value: "4242111122223333",
                                                 formatted: "4242 1111 2222 3333",
                                                 brand: .visa,
                                                 display: "4242 1111 2222 3333",
                                                 mask: "•••• •••• •••• 3333")),
            ("42421111222233334444", " ", CardNumber(value: "4242111122223333",
                                                     formatted: "4242 1111 2222 3333",
                                                     brand: .visa,
                                                     display: "4242 1111 2222 3333",
                                                     mask: "•••• •••• •••• 3333"))
        ]
        testCardNumberFormat(cases: cases)
    }

    func testMastercardNumberFormat() {
        let cases = [
            ("51", "-", CardNumber(value: "51",
                                   formatted: "51",
                                   brand: .mastercard,
                                   display: "51XX-XXXX-XXXX-XXXX",
                                   mask: "")),
            ("5211222", "-", CardNumber(value: "5211222",
                                        formatted: "5211-222",
                                        brand: .mastercard,
                                        display: "5211-222X-XXXX-XXXX",
                                        mask: "")),
            ("222122223333", "-", CardNumber(value: "222122223333",
                                             formatted: "2221-2222-3333",
                                             brand: .mastercard,
                                             display: "2221-2222-3333-XXXX",
                                             mask: "")),
            ("2533111122223333", " ", CardNumber(value: "2533111122223333",
                                                 formatted: "2533 1111 2222 3333",
                                                 brand: .mastercard,
                                                 display: "2533 1111 2222 3333",
                                                 mask: "•••• •••• •••• 3333")),
            ("25331111222233334444", " ", CardNumber(value: "2533111122223333",
                                                     formatted: "2533 1111 2222 3333",
                                                     brand: .mastercard,
                                                     display: "2533 1111 2222 3333",
                                                     mask: "•••• •••• •••• 3333"))
        ]
        testCardNumberFormat(cases: cases)
    }

    func testJCBNumberFormat() {
        let cases = [
            ("353", "-", CardNumber(value: "353",
                                    formatted: "353",
                                    brand: .jcb,
                                    display: "353X-XXXX-XXXX-XXXX",
                                    mask: "")),
            ("3581222", "-", CardNumber(value: "3581222",
                                        formatted: "3581-222",
                                        brand: .jcb,
                                        display: "3581-222X-XXXX-XXXX",
                                        mask: "")),
            ("352822223333", "-", CardNumber(value: "352822223333",
                                             formatted: "3528-2222-3333",
                                             brand: .jcb,
                                             display: "3528-2222-3333-XXXX",
                                             mask: "")),
            ("3529222233334444", " ", CardNumber(value: "3529222233334444",
                                                 formatted: "3529 2222 3333 4444",
                                                 brand: .jcb,
                                                 display: "3529 2222 3333 4444",
                                                 mask: "•••• •••• •••• 4444")),
            ("35292222333344445555", " ", CardNumber(value: "3529222233334444",
                                                     formatted: "3529 2222 3333 4444",
                                                     brand: .jcb,
                                                     display: "3529 2222 3333 4444",
                                                     mask: "•••• •••• •••• 4444"))
        ]
        testCardNumberFormat(cases: cases)
    }

    func testAmexNumberFormat() {
        let cases = [
            ("34", "-", CardNumber(value: "34",
                                   formatted: "34",
                                   brand: .americanExpress,
                                   display: "34XX-XXXXXX-XXXXX",
                                   mask: "")),
            ("341122", "-", CardNumber(value: "341122",
                                       formatted: "3411-22",
                                       brand: .americanExpress,
                                       display: "3411-22XXXX-XXXXX",
                                       mask: "")),
            ("371122223333", "-", CardNumber(value: "371122223333",
                                             formatted: "3711-222233-33",
                                             brand: .americanExpress,
                                             display: "3711-222233-33XXX",
                                             mask: "")),
            ("371122223333444", " ", CardNumber(value: "371122223333444",
                                                formatted: "3711 222233 33444",
                                                brand: .americanExpress,
                                                display: "3711 222233 33444",
                                                mask: "•••• •••••• •3444")),
            ("37112222333344445555", " ", CardNumber(value: "371122223333444",
                                                     formatted: "3711 222233 33444",
                                                     brand: .americanExpress,
                                                     display: "3711 222233 33444",
                                                     mask: "•••• •••••• •3444"))
        ]
        testCardNumberFormat(cases: cases)
    }

    func testDinersNumberFormat() {
        let cases = [
            ("300", "-", CardNumber(value: "300",
                                    formatted: "300",
                                    brand: .dinersClub,
                                    display: "300X-XXXXXX-XXXX",
                                    mask: "")),
            ("361122", "-", CardNumber(value: "361122",
                                       formatted: "3611-22",
                                       brand: .dinersClub,
                                       display: "3611-22XXXX-XXXX",
                                       mask: "")),
            ("381122223333", "-", CardNumber(value: "381122223333",
                                             formatted: "3811-222233-33",
                                             brand: .dinersClub,
                                             display: "3811-222233-33XX",
                                             mask: "")),
            ("38112222333344", " ", CardNumber(value: "38112222333344",
                                               formatted: "3811 222233 3344",
                                               brand: .dinersClub,
                                               display: "3811 222233 3344",
                                               mask: "•••• •••••• 3344")),
            ("38112222333344445555", " ", CardNumber(value: "38112222333344",
                                                     formatted: "3811 222233 3344",
                                                     brand: .dinersClub,
                                                     display: "3811 222233 3344",
                                                     mask: "•••• •••••• 3344"))
        ]
        testCardNumberFormat(cases: cases)
    }

    func testUnknownNumberFormat() {
        let cases = [
            ("999", "-", CardNumber(value: "999",
                                    formatted: "999",
                                    brand: .unknown,
                                    display: "999X-XXXX-XXXX-XXXX",
                                    mask: "")),
            ("9999999999999999", "-", CardNumber(value: "9999999999999999",
                                                 formatted: "9999-9999-9999-9999",
                                                 brand: .unknown,
                                                 display: "9999-9999-9999-9999",
                                                 mask: "••••-••••-••••-9999")),
            ("99999999999999999999999999999999", " ", CardNumber(value: "9999999999999999",
                                                                 formatted: "9999 9999 9999 9999",
                                                                 brand: .unknown,
                                                                 display: "9999 9999 9999 9999",
                                                                 mask: "•••• •••• •••• 9999"))
        ]
        testCardNumberFormat(cases: cases)
    }
}
