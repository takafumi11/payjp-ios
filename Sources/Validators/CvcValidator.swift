//
//  CvcValidator.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/07/19.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

protocol CvcValidatorType {
    /// セキュリティコードのバリデーションチェックを行います
    ///
    /// - Parameters:
    ///   - cvc: セキュリティコード
    ///   - brand: カードブランド
    /// - Returns: バリデーションOKか、エラー即時反映か
    func isValid(cvc: String, brand: CardBrand) -> (validated: Bool, isInstant: Bool)
}

struct CvcValidator: CvcValidatorType {

    func isValid(cvc: String, brand: CardBrand) -> (validated: Bool, isInstant: Bool) {
        let filtered = cvc.numberfy()

        if cvc.count != filtered.count {
            return (false, false)
        }

        return (filtered.count == brand.cvcLength, filtered.count > brand.cvcLength)
    }
}
