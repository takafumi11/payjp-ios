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
                XCTAssertEqual(output.hyphenFormatted, expected.hyphenFormatted)
                XCTAssertEqual(output.spaceFormatted, expected.spaceFormatted)
                XCTAssertEqual(output.brand, expected.brand)
                XCTAssertEqual(output.display, expected.display)
            }
        }
    }

    func testVisaNumberFormat() {
        let cases = [
            ("42", CardNumber(hyphenFormatted: "42",
                              spaceFormatted: "42",
                              brand: .visa,
                              display: "42XX XXXX XXXX XXXX")),
            ("4242111", CardNumber(hyphenFormatted: "4242-111",
                                   spaceFormatted: "4242 111",
                                   brand: .visa,
                                   display: "4242 111X XXXX XXXX")),
            ("424211112222", CardNumber(hyphenFormatted: "4242-1111-2222",
                                        spaceFormatted: "4242 1111 2222",
                                        brand: .visa,
                                        display: "4242 1111 2222 XXXX")),
            ("4242111122223333", CardNumber(hyphenFormatted: "4242-1111-2222-3333",
                                            spaceFormatted: "4242 1111 2222 3333",
                                            brand: .visa,
                                            display: "4242 1111 2222 3333")),
            ("42421111222233334444", CardNumber(hyphenFormatted: "4242-1111-2222-3333",
                                                spaceFormatted: "4242 1111 2222 3333",
                                                brand: .visa,
                                                display: "4242 1111 2222 3333"))
        ]
        testCardNumberFormat(cases: cases)
    }

    func testMastercardNumberFormat() {
        let cases = [
            ("51", CardNumber(hyphenFormatted: "51",
                              spaceFormatted: "51",
                              brand: .mastercard,
                              display: "51XX XXXX XXXX XXXX")),
            ("5211222", CardNumber(hyphenFormatted: "5211-222",
                                   spaceFormatted: "5211 222",
                                   brand: .mastercard,
                                   display: "5211 222X XXXX XXXX")),
            ("222122223333", CardNumber(hyphenFormatted: "2221-2222-3333",
                                        spaceFormatted: "2221 2222 3333",
                                        brand: .mastercard,
                                        display: "2221 2222 3333 XXXX")),
            ("2533111122223333", CardNumber(hyphenFormatted: "2533-1111-2222-3333",
                                            spaceFormatted: "2533 1111 2222 3333",
                                            brand: .mastercard,
                                            display: "2533 1111 2222 3333")),
            ("25331111222233334444", CardNumber(hyphenFormatted: "2533-1111-2222-3333",
                                                spaceFormatted: "2533 1111 2222 3333",
                                                brand: .mastercard,
                                                display: "2533 1111 2222 3333"))
        ]
        testCardNumberFormat(cases: cases)
    }

    func testJCBNumberFormat() {
        let cases = [
            ("353", CardNumber(hyphenFormatted: "353",
                               spaceFormatted: "353",
                               brand: .jcb,
                               display: "353X XXXX XXXX XXXX")),
            ("3581222", CardNumber(hyphenFormatted: "3581-222",
                                   spaceFormatted: "3581 222",
                                   brand: .jcb,
                                   display: "3581 222X XXXX XXXX")),
            ("352822223333", CardNumber(hyphenFormatted: "3528-2222-3333",
                                        spaceFormatted: "3528 2222 3333",
                                        brand: .jcb,
                                        display: "3528 2222 3333 XXXX")),
            ("3529222233334444", CardNumber(hyphenFormatted: "3529-2222-3333-4444",
                                            spaceFormatted: "3529 2222 3333 4444",
                                            brand: .jcb,
                                            display: "3529 2222 3333 4444")),
            ("35292222333344445555", CardNumber(hyphenFormatted: "3529-2222-3333-4444",
                                                spaceFormatted: "3529 2222 3333 4444",
                                                brand: .jcb,
                                                display: "3529 2222 3333 4444"))
        ]
        testCardNumberFormat(cases: cases)
    }

    func testAmexNumberFormat() {
        let cases = [
            ("34", CardNumber(hyphenFormatted: "34",
                              spaceFormatted: "34",
                              brand: .americanExpress,
                              display: "34XX XXXXXX XXXXX")),
            ("341122", CardNumber(hyphenFormatted: "3411-22",
                                  spaceFormatted: "3411 22",
                                  brand: .americanExpress,
                                  display: "3411 22XXXX XXXXX")),
            ("371122223333", CardNumber(hyphenFormatted: "3711-222233-33",
                                        spaceFormatted: "3711 222233 33",
                                        brand: .americanExpress,
                                        display: "3711 222233 33XXX")),
            ("371122223333444", CardNumber(hyphenFormatted: "3711-222233-33444",
                                           spaceFormatted: "3711 222233 33444",
                                           brand: .americanExpress,
                                           display: "3711 222233 33444")),
            ("37112222333344445555", CardNumber(hyphenFormatted: "3711-222233-33444",
                                                spaceFormatted: "3711 222233 33444",
                                                brand: .americanExpress,
                                                display: "3711 222233 33444"))
        ]
        testCardNumberFormat(cases: cases)
    }

    func testDinersNumberFormat() {
        let cases = [
            ("300", CardNumber(hyphenFormatted: "300",
                               spaceFormatted: "300",
                               brand: .dinersClub,
                               display: "300X XXXXXX XXXX")),
            ("361122", CardNumber(hyphenFormatted: "3611-22",
                                  spaceFormatted: "3611 22",
                                  brand: .dinersClub,
                                  display: "3611 22XXXX XXXX")),
            ("381122223333", CardNumber(hyphenFormatted: "3811-222233-33",
                                        spaceFormatted: "3811 222233 33",
                                        brand: .dinersClub,
                                        display: "3811 222233 33XX")),
            ("38112222333344", CardNumber(hyphenFormatted: "3811-222233-3344",
                                          spaceFormatted: "3811 222233 3344",
                                          brand: .dinersClub,
                                          display: "3811 222233 3344")),
            ("38112222333344445555", CardNumber(hyphenFormatted: "3811-222233-3344",
                                                spaceFormatted: "3811 222233 3344",
                                                brand: .dinersClub,
                                                display: "3811 222233 3344"))
        ]
        testCardNumberFormat(cases: cases)
    }

    func testUnknownNumberFormat() {
        let cases = [
            ("999", CardNumber(hyphenFormatted: "999",
                               spaceFormatted: "999",
                               brand: .unknown,
                               display: "999X XXXX XXXX XXXX")),
            ("9999999999999999", CardNumber(hyphenFormatted: "9999-9999-9999-9999",
                                            spaceFormatted: "9999 9999 9999 9999",
                                            brand: .unknown,
                                            display: "9999 9999 9999 9999")),
            ("99999999999999999999999999999999", CardNumber(hyphenFormatted: "9999-9999-9999-9999",
                                                            spaceFormatted: "9999 9999 9999 9999",
                                                            brand: .unknown,
                                                            display: "9999 9999 9999 9999"))
        ]
        testCardNumberFormat(cases: cases)
    }
}
