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
    public let labelFontColor: String?
    public let inputFontColor: String
    public let cursorColor: String

    public init(labelFontColor: String? = nil, inputFontColor: String, cursorColor: String) {
        self.labelFontColor = labelFontColor
        self.inputFontColor = inputFontColor
        self.cursorColor = cursorColor
    }
}
