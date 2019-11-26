//
//  UIViewController+PAYJP.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/11/25.
//

import Foundation

extension UIViewController {
    func showError(message: String) {
        let alertController = UIAlertController(title: "エラー", message: message, preferredStyle: .alert)
        let close = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(close)
        self.present(alertController, animated: true, completion: nil)
    }
}
