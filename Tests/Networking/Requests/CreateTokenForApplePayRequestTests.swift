//
//  CreateTokenForApplePayRequestTests.swift
//  PAYJPTests
//
//  Created by Li-Hsuan Chen on 2019/07/25.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import XCTest
@testable import PAYJP

class CreateTokenForApplePayRequestTests: XCTestCase {
    func testInitialization() {
        let request = CreateTokenForApplePayRequest(paymentToken: "token")
        
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.path, "tokens")
        XCTAssertEqual(request.bodyParameters?["card"], "token")
        XCTAssertNil(request.queryParameters)
    }
}
