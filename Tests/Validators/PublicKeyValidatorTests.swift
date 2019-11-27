//
//  PublicKeyValidatorTests.swift
//  PAYJPTests
//
//  Created by Tadashi Wakayanagi on 2019/11/27.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import XCTest
@testable import PAYJP

class PublicKeyValidatorTests: XCTestCase {

    let validator = PublicKeyValidator()
    
    // TODO
    func testValidate(cases: [(String, Bool)]) {
        for (publicKey, expected) in cases {
            do {
                let result = try validator.validate(publicKey: publicKey)
                XCTAssertEqual(result, expected)
            } catch {
                print("failed \(error)")
            }
        }
    }

    func testPublicKeyValidation() {
        let cases: [(String, Bool)] = [
        ("", false),
        (" ", false),
        ("sk_test_123456789", false),
        ("sk_live_123456789", false),
        ("pk_test_123456789", true),
        ("pk_live_123456789", true)
        ]
        testValidate(cases: cases)
    }
}
