//
//  FormStyle.swift
//  PAYJP
//
//  Created by TADASHI on 2019/09/20.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

@objcMembers @objc(PAYCardFormStyle)
public class FormStyle: NSObject {
    public let fontColor: String
    public let cursorColor: String

    public init(fontColor: String, cursorColor: String) {
        self.fontColor = fontColor
        self.cursorColor = cursorColor
    }
}
