//
//  String+PAYJP.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/07/31.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation
import UIKit

extension String {

    /// 画像を取得
    var image: UIImage? {
        return UIImage(named: self, in: .sdkBundle, compatibleWith: nil)
    }

    /// 多言語対応
    var localized: String {
        return NSLocalizedString(self, bundle: .frameworkBundle, comment: "")
    }

    /// 数字かどうか
    var isDigitsOnly: Bool {
        return self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }

    /// 文字列から数値のみを返す
    ///
    /// - Returns: 数値文字列
    func numberfy() -> String {
        let digitSet = CharacterSet.decimalDigits
        let filtered = String(self.unicodeScalars.filter { digitSet.contains($0) })
        return filtered
    }
}
