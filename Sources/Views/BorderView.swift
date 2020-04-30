//
//  BorderView.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2020/04/13.
//  Copyright © 2020 PAY, Inc. All rights reserved.
//

import Foundation

@IBDesignable
class BorderView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    @IBInspectable var isHighlighted: Bool = false {
        didSet {
            if oldValue != isHighlighted {
                highlightOn()
            } else {
                highlightOff()
            }
        }
    }
}

extension BorderView {

    func highlightOn() {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = cornerRadius > 0
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor?.cgColor
    }

    func highlightOff() {
        layer.cornerRadius = 0
        layer.masksToBounds = false
        layer.borderWidth = 0
        layer.borderColor = nil
    }
}
