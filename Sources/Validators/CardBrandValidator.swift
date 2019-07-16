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

    func validate(number: String!) -> CardBrandType {
        for brandType in CardBrandType.allBrands {
            if(matchesRegex(regex: brandType.regex, text: number)) {
                return brandType
            }
        }
        return .Unknown
    }

    func matchesRegex(regex: String!, text: String!) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let nsString = text as NSString
        return predicate.evaluate(with: nsString)
    }
}

enum CardBrandType: String {
    case Visa, Mastercard, JCB, Amex, Diners, Discover, Unknown

    static let allBrands = [Visa, Mastercard, JCB, Amex, Diners, Discover]

    var regex: String {
        switch self {
        case .Visa:
            return "^4(?:[0-9]{0,15})$"
        case .Mastercard:
            return "^(?:5[1-5][0-9]{0,2}|222[1-9]|22[3-9][0-9]|2[3-6][0-9]{0,2}|27[01][0-9]|2720)[0-9]{0,12}$"
        case .JCB:
            return "^(?:2131|1800|35\\d{0,3})\\d{0,11}$"
        case .Amex:
            return "^3[47][0-9]{0,13}$"
        case .Diners:
            return "^3(?:0[0-5]|[68][0-9]{0,1})[0-9]{0,11}$"
        case .Discover:
            return "^6(?:011|5[0-9]{0,2})[0-9]{0,12}$"
        default:
            return ""
        }
    }
}
