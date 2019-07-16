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
        XCTAssertEqual(output, "11")
    }
    
    func test3Digits() {
        let input: String? = "112"
        let output = formatter.string(from: input)
        XCTAssertEqual(output, "11/2")
    }
    
    func test4Digits() {
        let input: String? = "1122"
        let output = formatter.string(from: input)
        XCTAssertEqual(output, "11/22")
    }
    
    func test5Digits() {
        let input: String? = "11223"
        let output = formatter.string(from: input)
        XCTAssertEqual(output, "11/22")
    }
    
    func testmixWithNotNumberDigits() {
        let input: String? = "1a"
        let output = formatter.string(from: input)
        XCTAssertEqual(output, "1")
    }
}
