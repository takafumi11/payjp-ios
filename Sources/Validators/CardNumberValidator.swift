//
//  CardNumberValidator.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/07/19.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

protocol CardNumberValidatorType {
    /// カード番号のバリデーションチェックを行う
    ///
    /// - Parameters:
    ///   - cardNumber: cardNumber カード番号
    ///   - brand: brand カードブランド
    /// - Returns: true バリデーションOK
    func isValid(cardNumber: String, brand: CardBrand) -> Bool
    /// カード番号の長さをチェックする
    ///
    /// - Parameters:
    ///   - cardNumber: cardNumber カード番号
    ///   - brand: brand カードブランド
    /// - Returns: true 長さが正しい
    func isCardNumberLengthValid(cardNumber: String, brand: CardBrand) -> Bool
    /// カード番号のチェックディジットを行う
    ///
    /// - Parameter cardNumber: カード番号
    /// - Returns: true チェックディジットOK
    func isLuhnValid(cardNumber: String) -> Bool
}

struct CardNumberValidator: CardNumberValidatorType {

    func isValid(cardNumber: String, brand: CardBrand) -> Bool {
        let filtered = cardNumber.numberfy()
        if cardNumber.count != filtered.count {
            return false
        }
        return isCardNumberLengthValid(cardNumber: filtered, brand: brand) && isLuhnValid(cardNumber: filtered)
    }

    func isCardNumberLengthValid(cardNumber: String, brand: CardBrand) -> Bool {
        return cardNumber.count == brand.numberLength
    }

    func isLuhnValid(cardNumber: String) -> Bool {
        var sum = 0
        let digitStrings = cardNumber.reversed().map(String.init).map(Int.init)

        for (offset, element) in digitStrings.enumerated() {
            if var digit = element {
                let odd = offset % 2 == 1
                if (odd) {
                    digit *= 2
                }
                if (digit > 9) {
                    digit -= 9
                }
                sum += digit
            }
        }
        return sum % 10 == 0
    }
}
