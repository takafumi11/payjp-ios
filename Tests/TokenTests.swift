//
//  TokenTests.swift
//  PAYJP
//
//  Created by k@binc.jp on 10/3/16.
//  Copyright © 2016 PAY, Inc. All rights reserved.
//

import Foundation
import XCTest
import PassKit
@testable import PAYJP

class TokenTests: XCTestCase {
    var token: Token!
    var json: Data!
    
    override func setUp() {
        json = TestFixture.JSON(by: "token.json")
        token = try! Token.decodeJson(with: decoder, data: json)
        let decoder = JSONDecoder.since1970StrategyDecoder
    }
        
    func testTokenProperties() {
        XCTAssertEqual(token.identifer, "tok_bba03649fecef2d367be6fc28367")
        XCTAssertEqual(token.livemode, true)
        XCTAssertEqual(token.used, false)
    }
    
    func testCreatedDate() {
        XCTAssertEqual(token.createdAt, Date(timeIntervalSince1970: 1475462082))
    }
    
    func testRawObject() {
        let rawValue = token.rawValue
        XCTAssertEqual(rawValue?.count, 6)
    }
}
