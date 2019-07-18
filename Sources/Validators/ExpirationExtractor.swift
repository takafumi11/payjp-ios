//
//  ExpirationExtractor.swift
//  PAYJP
//
//  Created by Li-Hsuan Chen on 2019/07/18.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

protocol ExpirationExtractorType {
    func monthYear(expiration: String?) throws -> (month: String, year: String)?
}

struct ExpirationExtractor: ExpirationExtractorType {
    
    let formatter: ExpirationFormatterType
    
    init(formatter: ExpirationFormatterType = ExpirationFormatter()) {
        self.formatter = formatter
    }
    
    func monthYear(expiration: String?) throws -> (month: String, year: String)? {
        if let expiration = formatter.string(from: expiration) {
            let monthYear = expiration.split(separator: "/").map { String($0) }
            
            if monthYear.count != 2 { return nil }
            
            let month = monthYear[0]
            let year = monthYear[1]
            
            if !(1...12 ~= Int(month) ?? 0) { throw ExpirationError.monthOverflow }
            
            return (month: month, year: year)
        }
        
        return nil
    }
}

enum ExpirationError: Error {
    case monthOverflow
}
