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
            let trimmed = String(filtered.unicodeScalars.prefix(16))
            switch brand {
            case .americanExpress, .dinersClub:
                let formattedNumber = trimmed
                    .enumerated()
                    .map { offset, element in
                        ((offset == 4 || offset == 10) && offset != trimmed.count) ? [" ", element] : [element]
                    }
                    .joined()
                return CardNumber(formatted: String(formattedNumber), brand: brand)
            default:
                let formattedNumber = trimmed
                    .enumerated()
                    .map { offset, element in
                        (offset != 0 && offset % 4 == 0 && offset != trimmed.count) ? [" ", element] : [element]
                    }
                    .joined()
                return CardNumber(formatted: String(formattedNumber), brand: brand)
            }
        }
        return nil
    }
}
