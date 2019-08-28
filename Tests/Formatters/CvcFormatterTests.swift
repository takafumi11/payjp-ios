//
//  CvcFormatterTests.swift
//  PAYJPTests
//
//  Created by Tadashi Wakayanagi on 2019/07/19.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import XCTest
@testable import PAYJP

class CvcFormatterTests: XCTestCase {

    let formatter = CvcFormatter()

    private func testFortmat(cases: [(String?, CardBrand, String?)]) {
        for (cvc, brand, formatted) in cases {
            let output = formatter.string(from: cvc, brand: brand)
            XCTAssertEqual(output, formatted)
        }
    }

    func testCvcFormat() {
        let cases: [(String?, CardBrand, String?)] = [
            (nil, .unknown, nil),
            (nil, .visa, nil),
            (nil, .americanExpress, nil),
            ("", .unknown, nil),
            ("", .mastercard, nil),
            ("", .americanExpress, nil),
            ("1", .unknown, "1"),
            ("1", .jcb, "1"),
            ("1", .americanExpress, "1"),
            ("12", .unknown, "12"),
            ("12", .dinersClub, "12"),
            ("12", .americanExpress, "12"),
            ("123", .unknown, "123"),
            ("123", .discover, "123"),
            ("123", .americanExpress, "123"),
            ("1234", .unknown, "1234"),
            ("1234", .visa, "123"),
            ("1234", .americanExpress, "1234"),
            ("12345", .unknown, "1234"),
            ("12345", .mastercard, "123"),
            ("12345", .americanExpress, "1234"),
            ("aaa", .unknown, nil),
            ("aaa", .jcb, nil),
            ("aaa", .americanExpress, nil)
        ]
        testFortmat(cases: cases)
    }
}
