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
    ///
    /// - Parameters:
    ///   - cvc: セキュリティコード
    ///   - brand: カードブランド
    /// - Returns: ブランド別でフォーマットしたcvc
    func string(from cvc: String?, brand: CardBrand) -> String?
}

struct CvcFormatter: CvcFormatterType {

    func string(from cvc: String?, brand: CardBrand) -> String? {
        if let cvc = cvc, !cvc.isEmpty {
            let filtered = cvc.numberfy()

            if filtered.isEmpty { return nil }

            let trimmed = String(filtered.unicodeScalars.prefix(brand.cvcLength))
            return trimmed
        }
        return nil
    }
}
