//
//  NSErrorConverter.swift
//  PAYJPTests
//
//  Created by Tadashi Wakayanagi on 2019/10/07.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import XCTest
@testable import PAYJP

class NSErrorConverterTests: XCTestCase {

    let converter = NSErrorConverter()

    func testConvertAPIError() {
        let error = APIError.invalidResponse(nil)
        let nsError = converter.convert(from: error)
        XCTAssertEqual(nsError?.domain, PAYErrorDomain)
        XCTAssertEqual(nsError?.code, PAYErrorInvalidResponse)
        let description = nsError?.userInfo[NSLocalizedDescriptionKey] as? String
        XCTAssertEqual(description, "The response is not a HTTPURLResponse instance.")
    }

    func testConvertOtherError() {
        let error = NSError(domain: "other", code: 100, userInfo: nil)
        let nsError = converter.convert(from: error)
        XCTAssertEqual(nsError?.domain, PAYErrorDomain)
        XCTAssertEqual(nsError?.code, PAYErrorSystemError)
        XCTAssertNotNil(nsError?.userInfo)
    }
}
