//
//  ExpirationExtractorTests.swift
//  PAYJPTests
//
//  Created by Li-Hsuan Chen on 2019/07/18.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import XCTest
@testable import PAYJP

class ExpirationExtractorTests: XCTestCase {
    func testFull() {
        let extractor = ExpirationExtractor()
        
        let source = "01/22"
        var result: (month: String, year: String)?
        var catchedError: Error?
        
        do {
            result = try extractor.extract(expiration: source)
        } catch {
            catchedError = error
        }
        
        XCTAssertNotNil(result)
        XCTAssertNil(catchedError)
        
        XCTAssertEqual(result?.month, "01")
        XCTAssertEqual(result?.year, "22")
    }
    
    func testMonthError() {
        let extractor = ExpirationExtractor()
        
        let source = "33/33"
        var result: (month: String, year: String)?
        var catchedError: Error?
        
        do {
            result = try extractor.extract(expiration: source)
        } catch {
            catchedError = error
        }
        
        XCTAssertNil(result)
        XCTAssertTrue(catchedError is ExpirationError)
        XCTAssertTrue((catchedError as? ExpirationExtractorError) == ExpirationExtractorError.monthOverflow)
        
        XCTAssertNil(result?.month)
        XCTAssertNil(result?.year)
    }
    
    func testNotFull() {
        let extractor = ExpirationExtractor()
        
        let source = "12"
        var result: (month: String, year: String)?
        var catchedError: Error?
        
        do {
            result = try extractor.extract(expiration: source)
        } catch {
            catchedError = error
        }
        
        XCTAssertNil(result)
        XCTAssertNil(catchedError)
        
        XCTAssertNil(result?.month)
        XCTAssertNil(result?.year)
    }
    
    func testNotWellFormatted() {
        let extractor = ExpirationExtractor()
        
        let source = "あら/がき"
        var result: (month: String, year: String)?
        var catchedError: Error?
        
        do {
            result = try extractor.extract(expiration: source)
        } catch {
            catchedError = error
        }
        
        XCTAssertNil(result)
        XCTAssertNil(catchedError)
        
        XCTAssertNil(result)
    }
}
