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
        let token = try! decoder.decode(Token.self, from: json)
        card = token.card
    }
    
    func testCardProperties() {
        XCTAssertEqual(card.brand, "Visa")
    }
    
    func testNameIsNullable() {
        XCTAssertNil(card.name)
    }
    
    // TODO
//    func testCardMetadata() {
//        let rawValue = card.rawValue as! [String: Any]
//        let metadata = rawValue["metadata"] as! [String: Any]
//        XCTAssertEqual(metadata.count, 1)
//        XCTAssertEqual(metadata["foo"] as! String, "bar")
//    }
}
