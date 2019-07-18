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

    private func testCardNumberFormat(cases: [(String, String)]) {
        for (input, expected) in cases {
            let output = formatter.string(from: input)
            XCTAssertEqual(output, expected)
        }
    }

    func testDefaultNumberFormat() {
        let cases = [
            ("42", "42"),
            ("4242111", "4242 111"),
            ("424211112222", "4242 1111 2222"),
            ("4242111122223333", "4242 1111 2222 3333"),
            ("51", "51"),
            ("5211222", "5211 222"),
            ("222122223333", "2221 2222 3333"),
            ("2533111122223333", "2533 1111 2222 3333"),
            ("35", "35"),
            ("3511222", "3511 222"),
            ("351122223333", "3511 2222 3333"),
            ("3511222233334444", "3511 2222 3333 4444"),
            ("9999999999999999", "9999 9999 9999 9999")
        ]
        testCardNumberFormat(cases: cases)
    }
    
    func testAmexNumberFormat() {
        let cases = [
            ("34", "34"),
            ("341122", "3411 22"),
            ("371122223333", "3711 222233 33"),
            ("371122223333444", "3711 222233 33444")
        ]
        testCardNumberFormat(cases: cases)
    }
    
    func testDinnersNumberFormat() {
        let cases = [
            ("30", "30"),
            ("361122", "3611 22"),
            ("381122223333", "3811 222233 33"),
            ("39112222333344", "3911 222233 3344")
        ]
        testCardNumberFormat(cases: cases)
    }
}
