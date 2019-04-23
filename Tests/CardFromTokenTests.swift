//
//  CardFromTokenTests.swift
//  PAYJP
//
//  Created by k@binc.jp on 2017/01/05.
//  Copyright © 2017 PAY, Inc. All rights reserved.
//

import Foundation
import XCTest
@testable import PAYJP

class CardFromTokenTests: XCTestCase {
    var card: Card!
    
    override func setUp() {
        let json = TestFixture.JSON(by: "token.json")
        let decoder = createJSONDecoder()
        let token = try! Token.decodeJson(with: decoder, data: json)
        card = token.card
    }
    
    func testCardProperties() {
        XCTAssertEqual(card.brand, "Visa")
    }
    
    func testNameIsNullable() {
        XCTAssertNil(card.name)
    }
    
    func testCardMetadata() {
        let rawValue = card.rawValue!
        let metadata = rawValue["metadata"] as! [String: Any]
        XCTAssertEqual(metadata.count, 1)
        XCTAssertEqual(metadata["foo"] as! String, "bar")
    }
}
