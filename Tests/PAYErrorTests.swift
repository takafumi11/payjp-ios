//
//  PAYErrorTests.swift
//  PAYJP
//
//  Created by Li-Hsuan Chen on 2018/05/21.
//  Copyright © 2018年 BASE, Inc. All rights reserved.
//

import Foundation

import Foundation
import XCTest
@testable import PAYJP

class PAYErrorTests: XCTestCase {
    var payError: PAYError!
    
    override func setUp() {
        let json = TestFixture.JSON(by: "error.json")
        payError = try! PAYError.decodeValue(json, rootKeyPath: "error")
    }
    
    func testErrorProperties() {
        XCTAssertEqual(payError.status, 402)
        XCTAssertEqual(payError.message, "Invalid card number")
        XCTAssertEqual(payError.param, "card[number]")
        XCTAssertEqual(payError.code, "invalid_number")
        XCTAssertEqual(payError.type, "card_error")
    }
}
