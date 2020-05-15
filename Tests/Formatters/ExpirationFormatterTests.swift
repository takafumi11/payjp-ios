//
//  ExpirationFormatterTests.swift
//  PAYJPTests
//
//  Created by Li-Hsuan Chen on 2019/07/16.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import XCTest
@testable import PAYJP

class ExpirationFormatterTests: XCTestCase {

    let formatter = ExpirationFormatter()

    func testNilInput() {
        let input: String? = nil

        let ouput = formatter.string(from: input)
        XCTAssertNil(ouput)
    }

    func test2Digits() {
        let input: String? = "11"
        let output = formatter.string(from: input)
        XCTAssertEqual(output?.formatted, "11")
        XCTAssertEqual(output?.display, "11/YY")
    }

    func test3Digits() {
        let input: String? = "112"
        let output = formatter.string(from: input)
        XCTAssertEqual(output?.formatted, "11/2")
        XCTAssertEqual(output?.display, "11/2Y")
    }

    func test4Digits() {
        let input: String? = "1122"
        let output = formatter.string(from: input)
        XCTAssertEqual(output?.formatted, "11/22")
        XCTAssertEqual(output?.display, "11/22")
    }

    func test5Digits() {
        let input: String? = "11223"
        let output = formatter.string(from: input)
        XCTAssertEqual(output?.formatted, "11/22")
        XCTAssertEqual(output?.display, "11/22")
    }

    func test5DigitsWithSlash() {
        let input: String? = "112/23"
        let output = formatter.string(from: input)
        XCTAssertEqual(output?.formatted, "11/22")
        XCTAssertEqual(output?.display, "11/22")
    }

    func testmixWithNotNumberDigits() {
        let input: String? = "1a"
        let output = formatter.string(from: input)
        XCTAssertEqual(output?.formatted, "1")
        XCTAssertEqual(output?.display, "1M/YY")
    }

    func testAllBan() {
        let input: String? = "aaa"
        let output = formatter.string(from: input)
        XCTAssertNil(output)
    }

    func testZeroFill1Digit() {
        let input: String? = "2"
        let output = formatter.string(from: input)
        XCTAssertEqual(output?.formatted, "02")
        XCTAssertEqual(output?.display, "02/YY")
    }

    func testZeroFill2Digits() {
        let input: String? = "20"
        let output = formatter.string(from: input)
        XCTAssertEqual(output?.formatted, "02/0")
        XCTAssertEqual(output?.display, "02/0Y")
    }

    func testZeroFill5Digits() {
        let input: String? = "50123"
        let output = formatter.string(from: input)
        XCTAssertEqual(output?.formatted, "05/01")
        XCTAssertEqual(output?.display, "05/01")
    }

    func testZeroFill5DigitsWithSlash() {
        let input: String? = "501/23"
        let output = formatter.string(from: input)
        XCTAssertEqual(output?.formatted, "05/01")
        XCTAssertEqual(output?.display, "05/01")
    }

    func testOnlyMonth() {
        let month = 1
        let output = formatter.string(month: month, year: nil)
        XCTAssertEqual(output, "01/")
    }

    func testMonthWithYear() {
        let month = 1
        let year = 2022
        let output = formatter.string(month: month, year: year)
        XCTAssertEqual(output, "01/22")
    }

    func testMonthOverflowWithZero() {
        let month = 0
        let year = 2022
        let output = formatter.string(month: month, year: year)
        XCTAssertNil(output)
    }

    func testMonthOverflowWithThirteen() {
        let month = 13
        let year = 2022
        let output = formatter.string(month: month, year: year)
        XCTAssertNil(output)
    }

    func testEmptyMonth() {
        let year = 2022
        let output = formatter.string(month: nil, year: year)
        XCTAssertNil(output)
    }
}
