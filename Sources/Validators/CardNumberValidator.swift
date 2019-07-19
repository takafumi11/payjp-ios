//
//  CardNumberValidator.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/07/19.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

protocol CardNumberValidatorType {
    /// カード番号のバリデーションチェックを行います
    /// - parameter cardNumber: カード番号
    /// - returns: バリデーションOKであればtrue
    func isValid(cardNumber: String) -> Bool
}

class CardNumberValidator: CardNumberValidatorType {

    func isValid(cardNumber: String) -> Bool {
        let digitSet = CharacterSet.decimalDigits
        let filtered = String(cardNumber.unicodeScalars.filter { digitSet.contains($0) })
        if cardNumber.count != filtered.count {
            return false
        }
        return isCardNumberLengthValid(cardNumber: filtered) && isLuhnValid(cardNumber: filtered)
    }

    private func isCardNumberLengthValid(cardNumber: String) -> Bool {
        if case 14...16 = cardNumber.count {
            return true
        } else {
            return false
        }
    }

    private func isLuhnValid(cardNumber: String) -> Bool {
        var sum = 0
        let digitStrings = cardNumber.reversed().map { String($0) }

        for (offset, element) in digitStrings.enumerated() {
            if var digit = Int(element) {
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
