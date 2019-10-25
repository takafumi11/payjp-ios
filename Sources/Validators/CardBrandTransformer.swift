//
//  CardBrandTransformer.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/07/16.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

protocol CardBrandTransformerType {
    /// カード番号をチェックしてカード種類に変換します
    /// - parameter cardNumber: カード番号
    /// - returns: カード種類
    func transform(from cardNumber: String) -> CardBrand
}

struct CardBrandTransformer: CardBrandTransformerType {

    func transform(from cardNumber: String) -> CardBrand {
        for brand in CardBrand.allBrands {
            if isMatched(source: cardNumber, regex: brand.regex) {
                return brand
            }
        }
        return .unknown
    }

    private func isMatched(source: String, regex: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let nsString = source as NSString
        return predicate.evaluate(with: nsString)
    }
}
