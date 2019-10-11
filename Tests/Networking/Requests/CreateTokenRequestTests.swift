//
//  CreateTokenRequestTests.swift
//  PAYJPTests
//
//  Created by Li-Hsuan Chen on 2019/07/25.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import XCTest
@testable import PAYJP

class CreateTokenRequestTests: XCTestCase {
    func testFullFields() {
        let request = CreateTokenRequest(
            cardNumber: "4242424242424242",
            cvc: "8888",
            expirationMonth: "01",
            expirationYear: "2022",
            name: "YUI ARAGAKI",
            tenantId: "mock_tenant_id")

        XCTAssertEqual(request.path, "tokens")
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.bodyParameters?["card[number]"], "4242424242424242")
        XCTAssertEqual(request.bodyParameters?["card[cvc]"], "8888")
        XCTAssertEqual(request.bodyParameters?["card[exp_month]"], "01")
        XCTAssertEqual(request.bodyParameters?["card[exp_year]"], "2022")
        XCTAssertEqual(request.bodyParameters?["card[name]"], "YUI ARAGAKI")
        XCTAssertEqual(request.bodyParameters?["tenant"], "mock_tenant_id")
        XCTAssertNil(request.queryParameters)
    }

    func testFieldsWithoutName() {

        let request = CreateTokenRequest(
            cardNumber: "4242424242424242",
            cvc: "8888",
            expirationMonth: "01",
            expirationYear: "2022",
            name: nil,
            tenantId: nil)

        XCTAssertEqual(request.path, "tokens")
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.bodyParameters?["card[number]"], "4242424242424242")
        XCTAssertEqual(request.bodyParameters?["card[cvc]"], "8888")
        XCTAssertEqual(request.bodyParameters?["card[exp_month]"], "01")
        XCTAssertEqual(request.bodyParameters?["card[exp_year]"], "2022")
        XCTAssertNil(request.bodyParameters?["card[name]"])
        XCTAssertNil(request.bodyParameters?["tenant"])
        XCTAssertNil(request.queryParameters)
    }
}
