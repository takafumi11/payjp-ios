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
    /// - Parameter cvc: セキュリティコード
    /// - Returns: true 文字数が3〜4文字である
    func isValid(cvc: String) -> Bool
}

struct CvcValidator: CvcValidatorType {

    func isValid(cvc: String) -> Bool {
        let digitSet = CharacterSet.decimalDigits
        let filtered = String(cvc.unicodeScalars.filter { digitSet.contains($0) })
        
        if cvc.count != filtered.count {
            return false
        }

        if case 3...4 = filtered.count {
            return true
        } else {
            return false
        }
    }
}
