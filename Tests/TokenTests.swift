//
//  TokenTests.swift
//  PAYJP
//
//  Created by k@binc.jp on 10/3/16.
//  Copyright © 2016 BASE, Inc. All rights reserved.
//

import Foundation
import XCTest
import PassKit
@testable import PAYJP

class TokenTests: XCTestCase {
    func jsonInFixture(by name: String) -> Any {
        let bundle = Bundle(for: type(of: self))
        let url = bundle.url(forResource: name, withExtension: nil, subdirectory: "Fixtures", localization: nil)!
        let data = try! Data(contentsOf: url)
        let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments)
        
        return json
    }
    
    func testTokenProperties() {
        let json = jsonInFixture(by: "token.json")
        let token = try! Token.decodeValue(json)
        
        XCTAssertEqual(token.identifer, "tok_bba03649fecef2d367be6fc28367")
        XCTAssertEqual(token.livemode, true)
        XCTAssertEqual(token.used, false)
    }
    
    func testCreatedDate() {
        let json = jsonInFixture(by: "token.json")
        let token = try! Token.decodeValue(json)
        
        XCTAssertEqual(token.createdAt, Date(timeIntervalSince1970: 1475462082))
    }
    
    func testCardProperties() {
        let json = jsonInFixture(by: "token.json")
        let token = try! Token.decodeValue(json)
        let card = token.card
        
        XCTAssertEqual(card.brand, "Visa")
    }
    
    func testRawObject() {
        let json = jsonInFixture(by: "token.json")
        let token = try! Token.decodeValue(json)
        let rawValue = token.rawValue as! [String: Any]
        
        XCTAssertEqual(rawValue.count, 6)
    }
}
