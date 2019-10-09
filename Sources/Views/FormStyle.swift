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
    public let labelTextColor: UIColor?
    public let inputTextColor: UIColor
    public let tintColor: UIColor

    public init(labelTextColor: UIColor? = nil, inputTextColor: UIColor, tintColor: UIColor) {
        self.labelTextColor = labelTextColor
        self.inputTextColor = inputTextColor
        self.tintColor = tintColor
    }
}
