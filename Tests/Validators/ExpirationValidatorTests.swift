//
//  ExpirationValidatorTests.swift
//  PAYJPTests
//
//  Created by Li-Hsuan Chen on 2019/07/19.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import XCTest
@testable import PAYJP

class ExpirationValidatorTests: XCTestCase {
    func testCurrentDate() {
        let date = Date(timeIntervalSinceNow: 0)
        let (month, year) = extractMonthYear(date: date)
        
        let validator = ExpirationValidator()
        let isValid = validator.isValid(month: month, year: year)
        
        XCTAssertTrue(isValid)
    }
    
    func testPastDate() {
        let date = Date(timeIntervalSinceNow: -60 * 60 * 24 * 30 * 2) // 今から二ヶ月くらい前
        let (month, year) = extractMonthYear(date: date)
        
        let validator = ExpirationValidator()
        let isValid = validator.isValid(month: month, year: year)
        
        XCTAssertFalse(isValid)
    }
    
    func testFutureDate() {
        let date = Date(timeIntervalSinceNow: 60 * 60 * 24 * 30 * 2) // 今から二ヶ月くらい後
        let (month, year) = extractMonthYear(date: date)
        
        let validator = ExpirationValidator()
        let isValid = validator.isValid(month: month, year: year)
        
        XCTAssertTrue(isValid)
    }
    
    private func extractMonthYear(date: Date) -> (month: String, year: String) {
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: date) % 100
        let month = calendar.component(.month, from: date)
        return ("\(month)", "\(year)")
    }
}
