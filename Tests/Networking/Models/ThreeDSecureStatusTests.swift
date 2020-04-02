//
//  ThreeDSecureStatusTests.swift
//  PAYJPTests
//
//  Created by Tadashi Wakayanagi on 2020/04/02.
//  Copyright © 2020 PAY, Inc. All rights reserved.
//

import XCTest
@testable import PAYJP

class ThreeDSecureStatusTests: XCTestCase {

    func testFind_verified() {
        let rawValue = PAYThreeDSecureStatus.verified.rawValue
        let status = ThreeDSecureStatus.find(rawValue: rawValue)
        XCTAssertEqual(status, PAYThreeDSecureStatus.verified)
    }

    func testFind_attempted() {
        let rawValue = PAYThreeDSecureStatus.attempted.rawValue
        let status = ThreeDSecureStatus.find(rawValue: rawValue)
        XCTAssertEqual(status, PAYThreeDSecureStatus.attempted)
    }

    func testFind_unverified() {
        let rawValue = PAYThreeDSecureStatus.unverified.rawValue
        let status = ThreeDSecureStatus.find(rawValue: rawValue)
        XCTAssertEqual(status, PAYThreeDSecureStatus.unverified)
    }

    func testFind_unknown() {
        let rawValue = "unknown"
        let status = ThreeDSecureStatus.find(rawValue: rawValue)
        XCTAssertNil(status)
    }
}
