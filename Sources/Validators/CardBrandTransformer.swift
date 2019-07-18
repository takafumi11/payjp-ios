//
//  CardBrandTransformer.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/07/16.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

struct CardBrandTransformer {
    static let shared = CardBrandTransformer()

    func transform(cardNumber: String) -> CardBrand {
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
