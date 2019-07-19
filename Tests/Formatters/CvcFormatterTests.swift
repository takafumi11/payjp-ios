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

    private func testFortmat(cases: [(String?, String?)]) {
        for (input, formatted) in cases {
            let output = formatter.string(from: input)
            XCTAssertEqual(output, formatted)
        }
    }

    func testCvcFormat() {
        let cases = [
            (nil, nil),
            ("", nil),
            ("1", "1"),
            ("12", "12"),
            ("123", "123"),
            ("1234", "1234"),
            ("12345", "1234"),
            ("aaa", nil)
        ]
        testFortmat(cases: cases)
    }
}
