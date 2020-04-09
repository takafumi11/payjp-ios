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
    /// - parameter cardNumber: カード番号
    /// - returns: フォーマットしたカード番号、カード種類
    func string(from cardNumber: String?) -> CardNumber?
}

struct CardNumberFormatter: CardNumberFormatterType {

    let transformer: CardBrandTransformerType

    init(transformer: CardBrandTransformerType = CardBrandTransformer()) {
        self.transformer = transformer
    }

    func string(from cardNumber: String?) -> CardNumber? {
        if let cardNumber = cardNumber, !cardNumber.isEmpty {
            let filtered = cardNumber.numberfy()

            if filtered.isEmpty { return nil }

            let brand = transformer.transform(from: filtered)
            var trimmed = String(filtered.unicodeScalars.prefix(brand.numberLength))
            
            var formatted = trimmed
            while formatted.count < brand.numberLength {
                formatted.append("X")
            }
            
            switch brand {
            case .americanExpress, .dinersClub:
                trimmed.insert(separator: "-", positions: [4, 10])
                formatted.insert(separator: "-", positions: [4, 10])
                return CardNumber(formatted: trimmed, brand: brand, display: formatted)
            default:
                trimmed.insert(separator: "-", every: 4)
                formatted.insert(separator: "-", every: 4)
                return CardNumber(formatted: trimmed, brand: brand, display: formatted)
            }
        }
        return nil
    }
}
