//
//  FormStyle.swift
//  PAYJP
//
//  Created by TADASHI on 2019/09/20.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

/// CardForm style settings.
/// It's possible to change the color of each UIComponent.
@objcMembers @objc(PAYCardFormStyle)
public class FormStyle: NSObject {
    /// Text color of UILabel.
    public let labelTextColor: UIColor?
    /// Text color of UITextField.
    public let inputTextColor: UIColor
    /// Tint color of UITextField.
    public let tintColor: UIColor
    /// Background color of UITextField.
    public let inputFieldBackgroundColor: UIColor?
    /// Background color of UIButton.
    public let submitButtonColor: UIColor?

    public init(labelTextColor: UIColor? = nil,
                inputTextColor: UIColor,
                tintColor: UIColor,
                inputFieldBackgroundColor: UIColor? = nil,
                submitButtonColor: UIColor? = nil) {
        self.labelTextColor = labelTextColor
        self.inputTextColor = inputTextColor
        self.tintColor = tintColor
        self.inputFieldBackgroundColor = inputFieldBackgroundColor
        self.submitButtonColor = submitButtonColor
    }
}
