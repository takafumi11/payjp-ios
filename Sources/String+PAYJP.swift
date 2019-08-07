//
//  String+PAYJP.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/07/31.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

extension String {

    /// 文字列から数値のみを返す
    ///
    /// - Returns: 数値文字列
    func numberfy() -> String {
        let digitSet = CharacterSet.decimalDigits
        let filtered = String(self.unicodeScalars.filter { digitSet.contains($0) })
        return filtered
    }
}
