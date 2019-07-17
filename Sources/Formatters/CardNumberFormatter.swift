//
//  CardNumberFormatter.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/07/17.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

protocol CardNumberFormatterType {
    func string(from number: String?) -> String?
}

struct CardNumberFormatter: CardNumberFormatterType {
    func string(from number: String?) -> String? {
        if let number = number {
            let digitSet = CharacterSet.decimalDigits
            let filtered = String(number.unicodeScalars.filter { digitSet.contains($0) })

            if filtered.isEmpty { return nil }

            // ブランドのチェック
            let validator = CardBrandValidator.shared
            let brand = validator.validate(number: number)
            // 桁数の決定
            switch brand {
            case .visa,.masterCard,.JCB,.discover:
                let formattedNumber = filtered
                    .enumerated()
                    .map { offset, element in
                        (offset != 0 && offset % 4 == 0 && offset != filtered.count) ? [" ", element] : [element]
                    }
                    .joined()
                return String(formattedNumber)
            case .amex:
                return String("formattedNumber")
            case .dinersClub:
                return String("formattedNumber")
            case .unknown:
                return String("formattedNumber")
            }
        }
        return nil
    }
}
