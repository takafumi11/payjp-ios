//
//  GetTokenRequestTests.swift
//  PAYJPTests
//
//  Created by Li-Hsuan Chen on 2019/07/25.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import XCTest
@testable import PAYJP

class GetTokenRequestTests: XCTestCase {
    func testInitialization() {
        let request = GetTokenRequest(tokenId: "mock_id")
        
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.path, "tokens/mock_id")
        
        XCTAssertNil(request.bodyParameters)
        XCTAssertNil(request.queryParameters)
    }
}
