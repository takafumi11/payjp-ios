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
    func string(from expiration: String?) -> Expiration?

    func string(month: Int?, year: Int?) -> String?
}

struct ExpirationFormatter: ExpirationFormatterType {
    func string(from expiration: String?) -> Expiration? {
        if let expiration = expiration, !expiration.isEmpty {
            var filtered = expiration.numberfy()

            if filtered.isEmpty { return nil }

            if let firstNumber = Int(String(filtered.prefix(1))) {
                // 0埋め
                if firstNumber > 1 {
                    filtered = "0" + filtered
                }
            }

            filtered = String(filtered.unicodeScalars.prefix(4))

            var masked = filtered
            while masked.count < 4 {
                if masked.count < 2 {
                    masked.append("M")
                } else {
                    masked.append("Y")
                }
            }
            masked.insert(separator: "/", every: 2)

            if filtered.count >= 3 {
                filtered.insert(separator: "/", every: 2)
            }

            return Expiration(formatted: filtered, display: masked)
        }
        return nil
    }

    func string(month: Int?, year: Int?) -> String? {
        guard let month = month else { return nil }

        let trimmedMonth = month % 100
        if !(1...12 ~= trimmedMonth) { return nil }

        var result = String(format: "%02d", trimmedMonth) + "/"

        if let year = year {
            result += String(format: "%02d", year % 100)
        }

        return result
    }
}
