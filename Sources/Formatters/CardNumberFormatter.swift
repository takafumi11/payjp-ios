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
            var display = trimmed
            while display.count < brand.numberLength {
                display.append("X")
            }

            var mask = String()
            if trimmed.count == brand.numberLength {
                let last4 = String(trimmed.suffix(4))
                while mask.count < brand.numberLength - 4 {
                    mask.append("•")
                }
                mask.append(last4)
            }

            switch brand {
            case .americanExpress, .dinersClub:
                formatted.insert(separator: separator, positions: [4, 10])
                display.insert(separator: separator, positions: [4, 10])
                mask.insert(separator: separator, positions: [4, 10])
                return CardNumber(value: trimmed,
                                  formatted: formatted,
                                  brand: brand,
                                  display: display,
                                  mask: mask)
            default:
                formatted.insert(separator: separator, every: 4)
                display.insert(separator: separator, every: 4)
                mask.insert(separator: separator, every: 4)
                return CardNumber(value: trimmed,
                                  formatted: formatted,
                                  brand: brand,
                                  display: display,
                                  mask: mask)
            }
        }
        return nil
    }
}
