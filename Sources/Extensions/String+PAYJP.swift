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
        return UIImage(named: self, in: .payjpBundle, compatibleWith: nil)
    }

    /// 多言語対応
    var localized: String {
        return NSLocalizedString(self, bundle: .resourceBundle, comment: "")
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

    /// 正規表現でキャプチャした文字列を抽出する
    ///
    /// - Parameters:
    ///   - pattern: 正規表現
    ///   - group: 抽出するグループ番号(>=1)
    /// - Returns: 抽出した文字列
    func capture(pattern: String, group: Int) -> String? {
        let result = capture(pattern: pattern, group: [group])
        return result.isEmpty ? nil : result[0]
    }

    /// 正規表現でキャプチャした文字列を抽出する
    ///
    /// - Parameters:
    ///   - pattern: 正規表現
    ///   - group: 抽出するグループ番号(>=1)の配列
    /// - Returns: 抽出した文字列の配列
    func capture(pattern: String, group: [Int]) -> [String] {
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return []
        }

        guard let matched = regex.firstMatch(in: self, range: NSRange(location: 0, length: self.count)) else {
            return []
        }

        return group.map { group -> String in
            return (self as NSString).substring(with: matched.range(at: group))
        }
    }
}
