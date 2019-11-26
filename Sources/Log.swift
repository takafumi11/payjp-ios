//
//  Log.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/11/26.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

/// Debugビルド時のみログ出力する
/// - Parameters:
///   - debug: debug message
///   - function: function name
///   - file: file name
///   - line: line number
func print(debug: Any = "", function: String = #function, file: String = #file, line: Int = #line) {
    #if DEBUG
        var filename: NSString = file as NSString
        filename = filename.lastPathComponent as NSString
        Swift.print("File: \(filename), Line: \(line), Func: \(function) \n\(debug)")
    #endif
}
