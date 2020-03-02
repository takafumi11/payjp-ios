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

    /// Default style.
    public static let defaultStyle: FormStyle = {
        let style = FormStyle(labelTextColor: Style.Color.label,
                              inputTextColor: Style.Color.label,
                              errorTextColor: Style.Color.red,
                              tintColor: Style.Color.blue,
                              inputFieldBackgroundColor: Style.Color.groupedBackground,
                              submitButtonColor: Style.Color.blue)
        return style
    }()

    /// Text color of UILabel.
    public let labelTextColor: UIColor
    /// Text color of UITextField.
    public let inputTextColor: UIColor
    /// Text color of Error.
    public let errorTextColor: UIColor
    /// Tint color of UITextField.
    public let tintColor: UIColor
    /// Background color of UITextField.
    public let inputFieldBackgroundColor: UIColor
    /// Background color of UIButton.
    public let submitButtonColor: UIColor

    public init(labelTextColor: UIColor? = nil,
                inputTextColor: UIColor? = nil,
                errorTextColor: UIColor? = nil,
                tintColor: UIColor? = nil,
                inputFieldBackgroundColor: UIColor? = nil,
                submitButtonColor: UIColor? = nil) {
        self.labelTextColor = labelTextColor ?? Style.Color.label
        self.inputTextColor = inputTextColor ?? Style.Color.label
        self.errorTextColor = errorTextColor ?? Style.Color.red
        self.tintColor = tintColor ?? Style.Color.blue
        self.inputFieldBackgroundColor = inputFieldBackgroundColor ?? Style.Color.groupedBackground
        self.submitButtonColor = submitButtonColor ?? Style.Color.blue
    }
}
