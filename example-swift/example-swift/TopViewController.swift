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
            self.navigationController?.pushViewController(cardFormVc, animated: true)
        }
    }
}
