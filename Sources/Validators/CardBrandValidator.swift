//
//  CardBrandValidator.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/07/16.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

struct CardBrandValidator {
    static let shared = CardBrandValidator()

    func validate(number: String) -> CardBrand {
        for brandType in CardBrand.allBrands {
            if matchesRegex(regex: brandType.regex, text: number) {
                return brandType
            }
        }
        return .unknown
    }

    func matchesRegex(regex: String, text: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let nsString = text as NSString
        return predicate.evaluate(with: nsString)
    }
}
