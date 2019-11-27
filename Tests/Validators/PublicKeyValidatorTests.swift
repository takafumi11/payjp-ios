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

    func testValidate(cases: [(String, String?)]) {
        for (publicKey, message) in cases {
            expectAssertFail(expectedMessage: message) {
                validator.validate(publicKey: publicKey)
            }
        }
    }

    func testPublicKeyValidation() {
        let cases: [(String, String?)] = [
            ("", "❌You need to set publickey for PAY.JP. You can find in https://pay.jp/d/settings ."),
            (" ", "❌You need to set publickey for PAY.JP. You can find in https://pay.jp/d/settings ."),
            ("sk_test_123456789", "❌You are using secretkey (`sk_xxxx`) instead of PAY.JP publickey." +
                "You can find **public** key like `pk_xxxxxx` in https://pay.jp/d/settings ."),
            ("sk_live_123456789", "❌You are using secretkey (`sk_xxxx`) instead of PAY.JP publickey." +
                "You can find **public** key like `pk_xxxxxx` in https://pay.jp/d/settings ."),
            ("pk_test_123456789", nil),
            ("pk_live_123456789", nil)
        ]
        testValidate(cases: cases)
    }
}
