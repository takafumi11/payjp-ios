//
//  TokenTests.swift
//  PAYJP
//
//  Created by k@binc.jp on 10/3/16.
//  Copyright © 2016 PAY, Inc. All rights reserved.
//

import Foundation
import XCTest
@testable import PAYJP

class TokenTests: XCTestCase {
    var token: Token!
    var json: Data!

    override func setUp() {
        json = TestFixture.JSON(by: "token.json")
        let decoder = JSONDecoder.shared
        // swiftlint:disable force_try
        token = try! Token.decodeJson(with: json, using: decoder)
        // swiftlint:enable force_try
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
