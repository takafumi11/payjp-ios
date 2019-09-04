//
//  StringProtocol+PAYJP.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/08/30.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

extension StringProtocol where Self: RangeReplaceableCollection {

    /// 区切り文字をカウント毎に挿入する
    ///
    /// - Parameters:
    ///   - separator: 区切り文字
    ///   - count: カウント
    mutating func insert(separator: Self, every count: Int) {
        for index in indices.reversed() where index != startIndex &&
            distance(from: startIndex, to: index) % count == 0 {
                insert(contentsOf: separator, at: index)
        }
    }

    /// 区切り文字を指定したポジションに挿入する
    ///
    /// - Parameters:
    ///   - separator: 区切り文字
    ///   - positions: 挿入位置
    mutating func insert(separator: Self, positions: [Int]) {
        for index in indices.reversed() where index != startIndex &&
            positions.contains(distance(from: startIndex, to: index)) {
                insert(contentsOf: separator, at: index)
        }
    }
}
