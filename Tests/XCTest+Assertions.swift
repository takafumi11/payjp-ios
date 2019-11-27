//
//  XCTest+Assertions.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/11/27.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import XCTest
@testable import PAYJP

extension XCTestCase {

    func expectAssertFail(expectedMessage: String?, testcase: () -> Void) {
        assertClosure = { condition, message, _, _ in
            if !condition {
                XCTAssertEqual(message, expectedMessage)
                assertClosure = defaultAssertClosure
            }
        }
        testcase()
        assertClosure = defaultAssertClosure
    }
}
