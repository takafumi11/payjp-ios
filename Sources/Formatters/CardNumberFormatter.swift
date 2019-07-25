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
    func string(from cardNumber: String?) -> (String, CardBrand)?
}

struct CardNumberFormatter: CardNumberFormatterType {

    let transformer: CardBrandTransformerType

    init(transformer: CardBrandTransformerType = CardBrandTransformer()) {
        self.transformer = transformer
    }

    func string(from cardNumber: String?) -> (String, CardBrand)? {
        if let cardNumber = cardNumber, !cardNumber.isEmpty {
            let digitSet = CharacterSet.decimalDigits
            var filtered = String(cardNumber.unicodeScalars.filter { digitSet.contains($0) })

            if filtered.isEmpty { return nil }

            let brand = transformer.transform(from: filtered)
            let trimmed = String(filtered.unicodeScalars.prefix(brand.maxNumberLength))
            switch brand {
            case .americanExpress, .dinersClub:
                let formattedNumber = trimmed
                    .enumerated()
                    .map { offset, element in
                        ((offset == 4 || offset == 10) && offset != trimmed.count) ? [" ", element] : [element]
                    }
                    .joined()
                return (String(formattedNumber), brand)
            default:
                let formattedNumber = trimmed
                    .enumerated()
                    .map { offset, element in
                        (offset != 0 && offset % 4 == 0 && offset != trimmed.count) ? [" ", element] : [element]
                    }
                    .joined()
                return (String(formattedNumber), brand)
            }
        }
        return nil
    }
}
