//
//  UIView+PAYJP.swift
//  PAYJP
//
//  Created by Li-Hsuan Chen on 2019/08/09.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import UIKit

extension UIView {
    struct RectCorner: OptionSet {
        let rawValue: UInt

        static var minXMinYCorner = RectCorner(rawValue: 1 << 0)
        static var maxXMinYCorner = RectCorner(rawValue: 1 << 1)
        static var minXMaxYCorner = RectCorner(rawValue: 1 << 2)
        static var maxXMaxYCorner = RectCorner(rawValue: 1 << 3)
        static var allCorners: RectCorner = [.minXMinYCorner,
                                             .maxXMinYCorner,
                                             .minXMaxYCorner,
                                             .maxXMaxYCorner]
    }

    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }

    func roundingCorners(corners: RectCorner, radius: CGFloat) {
        if #available(iOS 11.0, *) {
            let corners = CACornerMask(rawValue: corners.rawValue)
            layer.cornerRadius = radius
            layer.maskedCorners = corners
        } else {
            let corners = UIRectCorner(rawValue: corners.rawValue)
            let path = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    }
}
