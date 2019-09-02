//
//  StringProtocol+PAYJPTests.swift
//  PAYJPTests
//
//  Created by Tadashi Wakayanagi on 2019/09/02.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import XCTest
@testable import PAYJP

class StringProtocol_PAYJPTests: XCTestCase {

    func testInsertSpaceWithCount() {
        var target = "1234567812345678"
        target.insert(separator: " ", every: 4)
        XCTAssertEqual(target, "1234 5678 1234 5678")
    }

    func testInsertSpaceWithPositions() {
        var target = "1234567812345678"
        target.insert(separator: " ", positions: [2, 4, 8, 14])
        XCTAssertEqual(target, "12 34 5678 123456 78")
    }
    
    func testInsertSlashWithCount() {
        var target = "1234"
        target.insert(separator: "/", every: 2)
        XCTAssertEqual(target, "12/34")
    }
}
