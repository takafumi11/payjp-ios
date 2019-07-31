//
//  APIErrorNSErrorTests.swift
//  PAYJPTests
//
//  Created by Li-Hsuan Chen on 2018/05/23.
//  Copyright © 2018年 PAY, Inc. All rights reserved.
//

import XCTest
import PassKit
@testable import PAYJP

class APIErrorNSErrorTests: XCTestCase {
    func testInvalidApplePayTokenConversion() {
        let token = PKPaymentToken()
        let apiError = APIError.invalidApplePayToken(token)
        let nserror =  apiError.nsErrorValue()
        
        let errorToken = nserror?.userInfo[PAYErrorInvalidApplePayTokenObject] as? PKPaymentToken
        
        XCTAssertNotNil(errorToken)
        XCTAssertEqual(errorToken, token)
        
        XCTAssertEqual(nserror?.code, PAYErrorInvalidApplePayToken)
        XCTAssertEqual(nserror?.localizedDescription, "Invalid Apple Pay Token")
    }
    
    func testSystemError() {
        let error = NSError(domain: "mock_domain", code: 0, userInfo: [NSLocalizedDescriptionKey: "mock error"])
        
        let apiError = APIError.systemError(error)
        let nserror =  apiError.nsErrorValue()
        
        let systemError = nserror?.userInfo[PAYErrorSystemErrorObject] as? NSError
        
        XCTAssertNotNil(systemError)
        XCTAssertEqual(systemError, error)
        
        XCTAssertEqual(nserror?.code, PAYErrorSystemError)
        XCTAssertEqual(nserror?.localizedDescription, "mock error")
    }
    
    func testInvalidResponse() {
        let response = HTTPURLResponse()
        
        let apiError = APIError.invalidResponse(response)
        let nserror =  apiError.nsErrorValue()
        
        let errorResponse = nserror?.userInfo[PAYErrorInvalidResponseObject] as? HTTPURLResponse
        
        XCTAssertNotNil(errorResponse)
        XCTAssertEqual(errorResponse, response)
        
        XCTAssertEqual(nserror?.code, PAYErrorInvalidResponse)
        XCTAssertEqual(nserror?.localizedDescription, "The response is not a HTTPURLResponse instance.")
    }
    
    func testServiceError() {
        let json = TestFixture.JSON(by: "error.json")
        let decoder = JSONDecoder.shared
        let payError = try! decoder.decode(PAYErrorResult.self, from: json).error
        
        let apiError = APIError.serviceError(payError)
        let nserror =  apiError.nsErrorValue()
        
        let errorObject = nserror?.userInfo[PAYErrorServiceErrorObject] as? PAYErrorResponse
        
        XCTAssertNotNil(payError)
        XCTAssertEqual(payError, errorObject)
        
        XCTAssertEqual(nserror?.code, PAYErrorServiceError)
        XCTAssertEqual(nserror?.localizedDescription, "Invalid card number")
    }
    
    func testInvalidJSON() {
        let someData = "Not a JSON".data(using: .utf8)!
        let error = NSError(domain: "mock_domain", code: 0, userInfo: [NSLocalizedDescriptionKey: "mock error"])
        
        let apiError = APIError.invalidJSON(someData, error)
        let nserror =  apiError.nsErrorValue()
        
        let errorData = nserror?.userInfo[PAYErrorInvalidJSONObject] as? Data
        let errorObject = nserror?.userInfo[PAYErrorInvalidJSONErrorObject] as? NSError
        
        XCTAssertNotNil(someData)
        XCTAssertEqual(someData, errorData)
        XCTAssertEqual(error, errorObject)
        
        XCTAssertEqual(nserror?.code, PAYErrorInvalidJSON)
        XCTAssertEqual(nserror?.localizedDescription, "Unable parse JSON object into expected classes.")
    }
}
