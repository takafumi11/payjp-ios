//
//  GetAcceptedBrandsTests.swift
//  PAYJPTests
//
//  Created by Li-Hsuan Chen on 2019/07/25.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import XCTest
@testable import PAYJP

class GetAcceptedBrandsTests: XCTestCase {
    func testInitializationWithTenantId() {
        let request = GetAcceptedBrands(tenantId: "mock_id")
        
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.path, "accounts/brands")
        XCTAssertEqual(request.queryParameters?["tenant"] as? String, "mock_id")
    }
    
    func testInitializationWithoutTenantId() {
        let request = GetAcceptedBrands(tenantId: nil)
        
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.path, "accounts/brands")
        XCTAssertNil(request.queryParameters?["tenant"])
    }
}
