//
//  ThreeDSecureTokenTests.swift
//  PAYJPTests
//
//  Created by Tadashi Wakayanagi on 2020/03/26.
//  Copyright © 2020 PAY, Inc. All rights reserved.
//

import XCTest
@testable import PAYJP

class ThreeDSecureTokenTests: XCTestCase {

    func testTdsEntryUrl() {
        PAYJPSDK.publicKey = "test_key"
        PAYJPSDK.threeDSecureURLConfiguration = ThreeDSecureURLConfiguration(redirectURL: URL(string: "test://tds")!,
                                                                             redirectURLKey: "ios_app")
        let tdsId = "tds_1234"
        let token = ThreeDSecureToken(identifier: tdsId)
        XCTAssertEqual(
            token.tdsEntryUrl.absoluteString,
            "\(PAYJPApiEndpoint)tds/\(tdsId)/start?publickey=test_key&back=ios_app"
        )
    }

    func testTdsFinishUrl() {
        let tdsId = "tds_1234"
        let token = ThreeDSecureToken(identifier: tdsId)
        XCTAssertEqual(token.tdsFinishUrl.absoluteString, "\(PAYJPApiEndpoint)tds/\(tdsId)/finish")
    }
}
