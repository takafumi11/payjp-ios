//
//  UIView+PAYJP.swift
//  PAYJP
//
//  Created by Li-Hsuan Chen on 2019/08/09.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

extension UIView {
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
}
