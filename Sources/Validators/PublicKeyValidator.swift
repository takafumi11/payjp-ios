//
//  PublicKeyValidator.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/11/27.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

protocol PublicKeyValidatorType {
    func validate(publicKey key: String)
}

struct PublicKeyValidator: PublicKeyValidatorType {

    static let shared = PublicKeyValidator()

    private let localAssert: (Bool, String, StaticString, UInt) -> Void

    /// テストのためにassert関数を置き換えられるようにしている
    /// デフォルトで Swift.assert を使用
    /// see PublicKeyValidatorTests
    init(assert: @escaping (Bool, String, StaticString, UInt) -> Void = {Swift.assert($0, $1, file: $2, line: $3)}) {
        localAssert = assert
    }

    func validate(publicKey key: String) {
        let trimmed = key.trimmingCharacters(in: .whitespaces)
        localAssert(!trimmed.isEmpty,
                    "❌You need to set publickey for PAY.JP. You can find in https://pay.jp/d/settings .", #file, #line)
        localAssert(!key.hasPrefix("sk_"), "❌You are using secretkey (`sk_xxxx`) instead of PAY.JP publickey." +
                        "You can find **public** key like `pk_xxxxxx` in https://pay.jp/d/settings .", #file, #line)

        if key.hasPrefix("pk_test") {
            print(debug: "⚠️PAY.JP now use **TEST** mode key." +
                    "In production, you should use livemode key like `pk_live_xxxx`.")
        }
    }
}
