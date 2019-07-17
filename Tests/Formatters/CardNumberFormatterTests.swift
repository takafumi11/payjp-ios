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

    func testVisaNumberFormat() {
        let cases = [
            ("42", "42"),
            ("4242111", "4242 111"),
            ("424211112222", "4242 1111 2222"),
            ("4242111122223333", "4242 1111 2222 3333"),
        ]
        testCardNumberFormat(cases: cases)
    }
}
