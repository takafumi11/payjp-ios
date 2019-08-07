//
//  ExpirationFormatter.swift
//  PAYJP
//
//  Created by Li-Hsuan Chen on 2019/07/16.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

protocol ExpirationFormatterType {
    /// Returns a formatted value from given string.
    /// - parameter expiration: 変換したい文字列。
    /// - returns: MM/yy のフォーマットで返します、例： `01/20` 。変換できない場合は nil で返します。
    func string(from expiration: String?) -> String?
}

struct ExpirationFormatter: ExpirationFormatterType {
    func string(from expiration: String?) -> String? {
        if let expiration = expiration, !expiration.isEmpty {
            var filtered = expiration.numberfy()

            if filtered.isEmpty { return nil }

            filtered = String(filtered.unicodeScalars.prefix(4))

            // 0埋め
            if filtered.count == 1 {
                if let month = Int(filtered) {
                    if month > 1 {
                        filtered = "0" + filtered
                    }
                }
            } else if filtered.count >= 3 {
                filtered.insert("/", at: filtered.index(filtered.startIndex, offsetBy: 2))
            }

            return filtered
        }
        return nil
    }
}
