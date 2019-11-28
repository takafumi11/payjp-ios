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

    func testPublicKeyValidationSuccess() {
        let assert: (Bool, String, StaticString, UInt) -> Void = { condition, message, _, _ in
            XCTAssertTrue(condition)
        }

        let validator = PublicKeyValidator(assert: assert)
        let cases: [String] = [
            ("pk_test_123456789"),
            ("pk_live_123456789")
        ]
        for (publicKey) in cases {
            validator.validate(publicKey: publicKey)
        }
    }

    func testPublicKeyValidationFailed() {
        let cases: [(String, String)] = [
            ("", "❌You need to set publickey for PAY.JP. You can find in https://pay.jp/d/settings ."),
            (" ", "❌You need to set publickey for PAY.JP. You can find in https://pay.jp/d/settings ."),
            ("sk_test_123456789", "❌You are using secretkey (`sk_xxxx`) instead of PAY.JP publickey." +
                "You can find **public** key like `pk_xxxxxx` in https://pay.jp/d/settings ."),
            ("sk_live_123456789", "❌You are using secretkey (`sk_xxxx`) instead of PAY.JP publickey." +
                "You can find **public** key like `pk_xxxxxx` in https://pay.jp/d/settings .")
        ]

        for (publicKey, expectedMessage) in cases {
            let assert: (Bool, String, StaticString, UInt) -> Void = { condition, message, _, _ in
                if !condition {
                    XCTAssertEqual(message, expectedMessage)
                }
            }
            let validator = PublicKeyValidator(assert: assert)
            validator.validate(publicKey: publicKey)
        }
    }
}
