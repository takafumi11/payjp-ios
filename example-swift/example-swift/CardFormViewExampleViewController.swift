//
//  CardFormViewExampleViewController.swift
//  example-swift
//
//  Created by Tadashi Wakayanagi on 2019/09/10.
//

import UIKit
import PAYJP

class CardFormVieExampleViewController: UITableViewController, CardFormViewDelegate {

    @IBOutlet weak var formContentView: UIView!
    @IBOutlet weak var createTokenButton: UITableViewCell!

    private var cardFormView: CardFormView!

    override func viewDidLoad() {

        let x: CGFloat = self.formContentView.bounds.origin.x
        let y: CGFloat = self.formContentView.bounds.origin.y

        let width: CGFloat = self.formContentView.bounds.width
        let height: CGFloat = self.formContentView.bounds.height

        let frame: CGRect = CGRect(x: x, y: y, width: width, height: height)
        cardFormView = CardFormView(frame: frame)
        cardFormView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        cardFormView.isHolderRequired = true
        cardFormView.delegate = self

        self.formContentView.addSubview(cardFormView)

        self.createTokenButton.selectionStyle = .none
        self.createTokenButton.isUserInteractionEnabled = false
        self.createTokenButton.contentView.alpha = 0.5
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var sectionName: String? = nil
        switch section {
        case 0:
            sectionName = NSLocalizedString("example_card_information_section", tableName: nil, comment: "")
        case 2:
            sectionName = NSLocalizedString("example_token_id_section", tableName: nil, comment: "")
        default:
            break;
        }
        return sectionName;
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        // Create Token
        if indexPath.section == 1 && indexPath.row == 1 {
            // TODO: call createToken
        }
        // Valdate and Create Token
        if indexPath.section == 1 && indexPath.row == 2 {
            let isValid = self.cardFormView.validateCardForm()
            if isValid {
                // TODO: call createToken
            }
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func isValidChanged(in cardFormView: CardFormView) {
        let isValid = self.cardFormView.isValid;
        if isValid {
            self.createTokenButton.selectionStyle = .default
            self.createTokenButton.isUserInteractionEnabled = true
            self.createTokenButton.contentView.alpha = 1.0
        } else {
            self.createTokenButton.selectionStyle = .none
            self.createTokenButton.isUserInteractionEnabled = false
            self.createTokenButton.contentView.alpha = 0.5
        }
    }

    @IBAction func cardHolderSwitchChanged(_ sender: UISwitch) {
        self.cardFormView.isHolderRequired = sender.isOn
        self.tableView.reloadData()
    }
}
