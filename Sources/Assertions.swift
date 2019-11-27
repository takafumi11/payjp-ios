//
//  Assertions.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/11/27.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

public func assert(_ condition: @autoclosure () -> Bool,
                   _ message: @autoclosure () -> String = String(),
                   file: StaticString = #file,
                   line: UInt = #line) {
    assertClosure(condition(), message(), file, line)
}

var assertClosure: (Bool, String, StaticString, UInt) -> Void = defaultAssertClosure
let defaultAssertClosure = {Swift.assert($0, $1, file: $2, line: $3)}
