//
//  ExpirationValidator.swift
//  PAYJP
//
//  Created by Li-Hsuan Chen on 2019/07/19.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

protocol ExpirationValidatorType {
    /// 月と年は今より未来なのかをチェックする
    /// - parameter month: 月
    /// - parameter year: 年
    /// - returns: true 渡された年月は `>= 今月`、 false 渡された年月は `< 今月`
    func isValid(month: String, year: String) -> Bool
}

struct ExpirationValidator: ExpirationValidatorType {
    
    static let shared = ExpirationValidator()
    
    func isValid(month: String, year: String) -> Bool {
        guard let intMonth = Int(month), let intYear = Int(year) else { return false }
        
        let moddedIntYear = intYear % 100
        
        let currentMonth = self.currentMonth()
        let currentYear = self.currentYear()
        
        if moddedIntYear == currentYear {
            return intMonth >= currentMonth ? true : false
        } else {
            return moddedIntYear > currentYear ? true : false
        }
    }
    
    private func currentYear() -> Int {
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: Date())
        return year % 100
    }
    
    private func currentMonth() -> Int {
        let calendar = Calendar(identifier: .gregorian)
        let month = calendar.component(.month, from: Date())
        return month
    }
}
