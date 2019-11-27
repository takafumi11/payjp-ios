//
//  PublicKeyValidator.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/11/27.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

protocol PublicKeyValidatorType {
    func validate(publicKey key: String) -> Bool
}

struct PublicKeyValidator: PublicKeyValidatorType {

    static let shared = PublicKeyValidator()

    func validate(publicKey key: String) -> Bool {
        assert(!key.isEmpty, "❌You need to set publickey for PAY.JP. You can find in https://pay.jp/d/settings .")
        assert(!key.hasPrefix("sk_"), "❌You are using secretkey (`sk_xxxx`) instead of PAY.JP publickey." +
            "You can find **public** key like `pk_xxxxxx` in https://pay.jp/d/settings .")

        if key.hasPrefix("pk_test") {
            print(debug: "⚠️PAY.JP now use **TEST** mode key." +
                "In production, you should use livemode key like `pk_live_xxxx`.")
        }
        return true
    }
}
