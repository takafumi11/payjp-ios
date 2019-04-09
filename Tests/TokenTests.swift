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
        let decoder = createJSONDecoder()
        token = try! decoder.decode(Token.self, from: json)
    }
        
    func testTokenProperties() {
        XCTAssertEqual(token.identifer, "tok_bba03649fecef2d367be6fc28367")
        XCTAssertEqual(token.livemode, true)
        XCTAssertEqual(token.used, false)
    }
    
    func testCreatedDate() {
        XCTAssertEqual(token.createdAt, Date(timeIntervalSince1970: 1475462082))
    }
    
//    func testRawObject() {
//        let rawValue = token.rawValue as [String: Any]
//        XCTAssertEqual(rawValue.count, 6)
//    }
}
