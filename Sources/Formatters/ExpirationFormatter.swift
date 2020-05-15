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
            if filtered.count >= 3 {
                filtered.insert(separator: "/", every: 2)
            }

            let mmyy = "MM/YY"
            let start = mmyy.startIndex
            let end = mmyy.index(mmyy.startIndex, offsetBy: filtered.count, limitedBy: mmyy.endIndex) ?? mmyy.endIndex
            let masked = mmyy.replacingCharacters(in: start..<end, with: filtered)

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
