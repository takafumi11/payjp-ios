//
//  CardNumberFormatter.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/07/17.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

protocol CardNumberFormatterType {
    /// カード番号をカード種類別でフォーマットします
    /// - Parameters:
    ///   - cardNumber: cardNumber: カード番号
    ///   - separator: separator: 区切り文字
    /// - Returns: フォーマットしたカード番号、カード種類
    func string(from cardNumber: String?, separator: String) -> CardNumber?
}

struct CardNumberFormatter: CardNumberFormatterType {

    let transformer: CardBrandTransformerType

    init(transformer: CardBrandTransformerType = CardBrandTransformer()) {
        self.transformer = transformer
    }

    func string(from cardNumber: String?, separator: String) -> CardNumber? {
        if let cardNumber = cardNumber, !cardNumber.isEmpty {
            let filtered = cardNumber.numberfy()

            if filtered.isEmpty { return nil }

            let brand = transformer.transform(from: filtered)
            let trimmed = String(filtered.unicodeScalars.prefix(brand.numberLength))

            var formatted = trimmed
            var masked = trimmed
            while masked.count < brand.numberLength {
                masked.append("X")
            }

            switch brand {
            case .americanExpress, .dinersClub:
                formatted.insert(separator: separator, positions: [4, 10])
                masked.insert(separator: separator, positions: [4, 10])
                return CardNumber(formatted: formatted,
                                  brand: brand,
                                  display: masked)
            default:
                formatted.insert(separator: separator, every: 4)
                masked.insert(separator: separator, every: 4)
                return CardNumber(formatted: formatted,
                                  brand: brand,
                                  display: masked)
            }
        }
        return nil
    }
}
