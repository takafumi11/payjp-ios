//
//  CvcFormatter.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/07/19.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

protocol CvcFormatterType {
    /// セキュリティコードをフォーマットする
    /// - Parameter cvc: セキュリティコード
    /// - Returns: 最大4文字でフォーマットしたcvc
    func string(from cvc: String?) -> String?
}

struct CvcFormatter: CvcFormatterType {

    func string(from cvc: String?) -> String? {
        if let cvc = cvc, !cvc.isEmpty {
            let digitSet = CharacterSet.decimalDigits
            var filtered = String(cvc.unicodeScalars.filter { digitSet.contains($0) })

            if filtered.isEmpty { return nil }

            let trimmed = String(filtered.unicodeScalars.prefix(4))
            return trimmed
        }
        return nil
    }
}
