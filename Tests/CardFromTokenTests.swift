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

// swiftlint:disable force_try
class CardFromTokenTests: XCTestCase {
    var card: Card!

    override func setUp() {
        let json = TestFixture.JSON(by: "token.json")
        let decoder = JSONDecoder.shared
        let token = try! Token.decodeJson(with: json, using: decoder)
        card = token.card
    }

    func testCardProperties() {
        XCTAssertEqual(card.brand, "Visa")
    }

    func testNameIsNullable() {
        XCTAssertNil(card.name)
    }

    // swiftlint:disable force_cast
    func testCardMetadata() {
        let rawValue = card.rawValue!
        let metadata = rawValue["metadata"] as! [String: Any]
        XCTAssertEqual(metadata.count, 1)
        XCTAssertEqual(metadata["foo"] as! String, "bar")
    }
    // swiftlint:enable force_cast
}
// swiftlint:enable force_try
