//
//  PAYJPSDKTests.swift
//  PAYJPTests
//
//  Created by Li-Hsuan Chen on 2019/07/24.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import XCTest
@testable import PAYJP

class PAYJPSDKTests: XCTestCase {
    override func setUp() {
        super.setUp()
        
        PAYJPSDK.publicKey = nil
        PAYJPSDK.locale = nil
    }
    
    func testValueSet() {
        let mockPublicKey = "publicKey"
        let mockLocale = Locale(identifier: "ja")
        
        PAYJPSDK.publicKey = mockPublicKey
        PAYJPSDK.locale = mockLocale
        
        XCTAssertEqual(PAYJPSDK.publicKey, mockPublicKey)
        XCTAssertEqual(PAYJPSDK.locale, mockLocale)
    }
}
