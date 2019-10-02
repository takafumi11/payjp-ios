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
    public let labelTextColor: String?
    public let inputTextColor: String
    public let tintColor: String

    public init(labelTextColor: String? = nil, inputTextColor: String, tintColor: String) {
        self.labelTextColor = labelTextColor
        self.inputTextColor = inputTextColor
        self.tintColor = tintColor
    }
}
