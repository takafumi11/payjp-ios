//
//  TopViewController.swift
//  example-swift
//
//  Created by Tadashi Wakayanagi on 2019/11/19.
//

import UIKit
import PAYJP

class TopViewController: UITableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            let color = UIColor(0, 122, 255)
            let style = FormStyle(
                labelTextColor: color,
                inputTextColor: color,
                tintColor: color)
            let cardFormVc = CardFormViewController.createCardFormViewController(style: style)
            cardFormVc.delegate = self
            self.navigationController?.pushViewController(cardFormVc, animated: true)
        }
    }
}

extension TopViewController: CardFormViewControllerDelegate {

    func cardFormViewController(_: CardFormViewController, didCompleteWithResult: CardFormResult) {

        switch didCompleteWithResult {
        case .cancel:
            print("CardFormResult.cancel")
        case .success:
            print("CardFormResult.success")
            DispatchQueue.main.async { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }

    func cardFormViewController(_: CardFormViewController,
                                didProducedToken: Token,
                                completionHandler: @escaping (Error?) -> Void) {
        print("token = \(didProducedToken.display)")

        // TODO: サーバにトークンを送信
        completionHandler(nil)
    }
}
