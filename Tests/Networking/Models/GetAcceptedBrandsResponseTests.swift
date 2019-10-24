//
//  GetAcceptedBrandsResponseTests.swift
//  PAYJPTests
//
//  Created by Li-Hsuan Chen on 2019/07/31.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import XCTest
@testable import PAYJP

class GetAcceptedBrandsResponseTests: XCTestCase {
    func testDecoding() {
        let jsonData = """
            {"card_types_supported": ["Visa"], "livemode": true}
        """.data(using: .utf8)!

        let response = try? JSONDecoder.shared.decode(GetAcceptedBrandsResponse.self, from: jsonData)

        XCTAssertEqual(response?.acceptedBrands.count, 1)
        XCTAssertEqual(response?.acceptedBrands.first, .visa)
        XCTAssertEqual(response?.liveMode, true)
    }
}
