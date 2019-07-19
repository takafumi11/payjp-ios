//
//  ExpirationExtractor.swift
//  PAYJP
//
//  Created by Li-Hsuan Chen on 2019/07/18.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

protocol ExpirationExtractorType {
    /// フォーマットされた文字列を月と年に分離する
    /// - parameter expiration: MM/yy にフォーマットされた文字列。
    /// - throws: 月は 1~12 の間の数字ではなかったら、エラー `monthOverflow` を投げ出します
    /// - returns: (month: String, year: String)? の tuple 、年は yyyy で返します。インプットは想定中なフォーマットではなかったら nil で返します。
    func extract(expiration: String?) throws -> (month: String, year: String)?
}

struct ExpirationExtractor: ExpirationExtractorType {
    
    static let shared = ExpirationExtractor()
    
    func extract(expiration: String?) throws -> (month: String, year: String)? {
        if let expiration = expiration, !expiration.isEmpty {
            let monthYear = expiration.split(separator: "/").map(String.init)
            
            if monthYear.count < 2 { return nil }
            
            let month = monthYear[0]
            let year = monthYear[1]
            
            let intMonth = Int(month)
            let intYear = Int(year)
            
            if intMonth == nil || intYear == nil { return nil }
            
            if !(1...12 ~= intMonth ?? 0) { throw ExpirationExtractorError.monthOverflow }
            
            return (month, "20" + year)
        }
        
        return nil
    }
}

enum ExpirationExtractorError: Error {
    case monthOverflow
}
