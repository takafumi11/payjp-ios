//
//  ExpirationFormatter.swift
//  PAYJP
//
//  Created by Li-Hsuan Chen on 2019/07/16.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

protocol ExpirationFormatterType {
    func string(from expiration: String?) -> String?
}

struct ExpirationFormatter: ExpirationFormatterType {
    func string(from expiration: String?) -> String? {
        if let expiration = expiration {
            let digitSet = CharacterSet.decimalDigits
            var filtered = String(expiration.unicodeScalars.filter { digitSet.contains($0) })
            
            if filtered.isEmpty { return nil }
            
            filtered = String(filtered.unicodeScalars.prefix(4))
            
            if filtered.count >= 3 {
                filtered.insert("/", at: filtered.index(filtered.startIndex, offsetBy: 2))
            }
            
            return filtered
        }
        return nil
    }
}
