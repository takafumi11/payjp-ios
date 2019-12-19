//
//  ExampleHostViewController.swift
//  example-swift
//
//  Created by Tadashi Wakayanagi on 2019/11/19.
//

import UIKit
import PAYJP

class ExampleHostViewController: UITableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.row == 3 {
            // customize card form
//            let color = UIColor(0, 122, 255)
//            let style = FormStyle(
//                labelTextColor: color,
//                inputTextColor: color,
//                tintColor: color)
            
            let cardFormVc = CardFormViewController.createCardFormViewController()
            cardFormVc.delegate = self
            // push
            self.navigationController?.pushViewController(cardFormVc, animated: true)

            // modal
//            let naviVc = UINavigationController(rootViewController: cardFormVc)
//            naviVc.presentationController?.delegate = cardFormVc
//            self.present(naviVc, animated: true, completion: nil)
        }
    }
}

extension ExampleHostViewController: CardFormViewControllerDelegate {

    func cardFormViewController(_: CardFormViewController, didCompleteWith result: CardFormResult) {
        switch result {
        case .cancel:
            print("CardFormResult.cancel")
        case .success:
            print("CardFormResult.success")
            DispatchQueue.main.async { [weak self] in
                // pop
                self?.navigationController?.popViewController(animated: true)

                // dismiss
//                                self?.dismiss(animated: true, completion: nil)
            }
        }
    }

    func cardFormViewController(_: CardFormViewController,
                                didProduced token: Token,
                                completionHandler: @escaping (Error?) -> Void) {
        print("token = \(token.display)")

        // サーバにトークンを送信
        SampleService.shared.saveCard(withToken: token.identifer) { (error) in
            if let error = error {
                print("Failed save card. error = \(error)")
                completionHandler(error)
            } else {
                print("Success save card. token = \(token.display)")
                completionHandler(nil)
            }
        }
    }
}
