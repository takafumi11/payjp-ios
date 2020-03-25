//
//  CreateTokenForThreeDSecureRequestTests.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2020/03/24.
//  Copyright © 2020 PAY, Inc. All rights reserved.
//

import XCTest
@testable import PAYJP

class CreateTokenForThreeDSecureRequestTests: XCTestCase {
    func testInitialization() {
        let request = CreateTokenForThreeDSecureRequest(tdsId: "tds_test")

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.path, "tokens")
        XCTAssertEqual(request.bodyParameters?["tds_id"], "tds_test")
        XCTAssertNil(request.queryParameters)
    }
}
