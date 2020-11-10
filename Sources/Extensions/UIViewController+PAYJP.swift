//
//  UIViewController+PAYJP.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/11/25.
//

import UIKit

extension UIViewController {
    func showError(message: String) {
        let alertController = UIAlertController(title: "エラー", message: message, preferredStyle: .alert)
        let close = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(close)
        self.present(alertController, animated: true, completion: nil)
    }

    var isModal: Bool {
        if self.navigationController?.viewControllers.first != self {
            return false
        }
        if self.presentingViewController != nil {
            return true
        }
        if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController {
            return true
        }
        if self.tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        return false
    }
}
