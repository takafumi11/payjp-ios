//
//  ThreeDSecureTokenTests.swift
//  PAYJPTests
//
//  Created by Tadashi Wakayanagi on 2020/03/26.
//  Copyright © 2020 PAY, Inc. All rights reserved.
//

import XCTest
@testable import PAYJP

class ThreeDSecureTests: XCTestCase {

    func testTdsEntryUrl() {
        let tdsId = "tds_1234"
        let token = ThreeDSecureToken(identifier: tdsId)
        XCTAssertEqual(token.tdsEntryUrl.absoluteString, "\(PAYJPApiEndpoint)tds/\(tdsId)/start")
    }

    func testTdsFinishUrl() {
        let tdsId = "tds_1234"
        let token = ThreeDSecureToken(identifier: tdsId)
        XCTAssertEqual(token.tdsFinishUrl.absoluteString, "\(PAYJPApiEndpoint)tds/\(tdsId)/finish")
    }
}
