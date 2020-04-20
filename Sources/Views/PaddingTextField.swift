//
//  PaddingTextField.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2020/04/20.
//  Copyright © 2020 PAY, Inc. All rights reserved.
//

import UIKit

@IBDesignable class PaddingTextField: UITextField {
    // MARK: Properties

    /// テキストの内側の余白
    @IBInspectable var padding: CGPoint = CGPoint(x: 16.0, y: 0.0)

    // MARK: Internal Methods

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: self.padding.x, dy: self.padding.y)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: self.padding.x, dy: self.padding.y)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: self.padding.x, dy: self.padding.y)
    }
}
