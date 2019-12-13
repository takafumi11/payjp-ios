//
//  CardFormViewExampleViewController.swift
//  example-swift
//
//  Created by Tadashi Wakayanagi on 2019/09/10.
//

import UIKit
import PAYJP

class CardFormVieExampleViewController: UITableViewController, CardFormViewDelegate,
UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet private weak var formContentView: UIView!
    @IBOutlet private weak var createTokenButton: UITableViewCell!
    @IBOutlet private weak var tokenIdLabel: UILabel!
    @IBOutlet private weak var selectColorField: UITextField!

    private var cardFormView: CardFormTableStyledView!

    private let list: [ColorTheme] = [.Normal, .Red, .Blue, .Dark]
    private var pickerView: UIPickerView!

    override func viewDidLoad() {

        let x: CGFloat = self.formContentView.bounds.origin.x
        let y: CGFloat = self.formContentView.bounds.origin.y

        let width: CGFloat = self.formContentView.bounds.width
        let height: CGFloat = self.formContentView.bounds.height

        let frame: CGRect = CGRect(x: x, y: y, width: width, height: height)
        cardFormView = CardFormTableStyledView(frame: frame)
        cardFormView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        cardFormView.isHolderRequired = true
        cardFormView.delegate = self

        self.formContentView.addSubview(cardFormView)

        self.createTokenButton.selectionStyle = .none
        self.createTokenButton.isUserInteractionEnabled = false
        self.createTokenButton.contentView.alpha = 0.5

        self.pickerView = UIPickerView()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.showsSelectionIndicator = true
        self.selectColorField.delegate = self

        let toolbar = UIToolbar()
        let spaceItem = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
            target: nil,
            action: nil)
        let doneItem = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonItem.SystemItem.done,
            target: self,
            action: #selector(colorSelected(_:)))
        toolbar.setItems([spaceItem, doneItem], animated: true)
        toolbar.sizeToFit()

        self.selectColorField.inputView = self.pickerView
        self.selectColorField.inputAccessoryView = toolbar

        self.fetchBrands()
    }

    @objc private func colorSelected(_ sender: UIButton) {
        self.selectColorField.endEditing(true)
        let theme = self.list[self.pickerView.selectedRow(inComponent: 0)]
        self.selectColorField.text = theme.rawValue

        switch theme {
        case .Red:
            let red = UIColor(255, 69, 0)
            let style = FormStyle(inputTextColor: red, tintColor: red)
            self.cardFormView.apply(style: style)
            self.cardFormView.backgroundColor = .clear
        case .Blue:
            let blue = UIColor(0, 103, 187)
            let style = FormStyle(inputTextColor: blue, tintColor: blue)
            self.cardFormView.apply(style: style)
            self.cardFormView.backgroundColor = .clear
        case .Dark:
            let darkGray = UIColor(61, 61, 61)
            let style = FormStyle(inputTextColor: .white, tintColor: .white)
            self.cardFormView.apply(style: style)
            self.cardFormView.backgroundColor = darkGray
        default:
            let defaultBlue = UIColor(0, 122, 255)
            let style = FormStyle(inputTextColor: .black, tintColor: defaultBlue)
            self.cardFormView.apply(style: style)
            self.cardFormView.backgroundColor = .clear
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var sectionName: String?
        switch section {
        case 0:
            sectionName = NSLocalizedString("example_card_information_section", tableName: nil, comment: "")
        case 2:
            sectionName = NSLocalizedString("example_token_id_section", tableName: nil, comment: "")
        default:
            break
        }
        return sectionName
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        // Create Token
        if indexPath.section == 1 && indexPath.row == 1 {
            if !self.cardFormView.isValid {
                return
            }
            createToken()
        }
        // Valdate and Create Token
        if indexPath.section == 1 && indexPath.row == 2 {
            let isValid = self.cardFormView.validateCardForm()
            if isValid {
                createToken()
            }
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.list.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.list[row].rawValue
    }

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
        ) -> Bool {
        return false
    }

    func formInputValidated(in cardFormView: UIView, isValid: Bool) {
        if isValid {
            self.createTokenButton.selectionStyle = .default
            self.createTokenButton.isUserInteractionEnabled = true
            self.createTokenButton.contentView.alpha = 1.0
        } else {
            self.createTokenButton.selectionStyle = .none
            self.createTokenButton.isUserInteractionEnabled = false
            self.createTokenButton.contentView.alpha = 0.5
        }

        UIView.performWithoutAnimation {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
    
    func formInputDoneTapped(in cardFormView: UIView) {
        self.createToken()
    }

    @IBAction func cardHolderSwitchChanged(_ sender: UISwitch) {
        self.cardFormView.isHolderRequired = sender.isOn
        self.tableView.reloadData()
    }

    func createToken() {
        self.cardFormView.createToken(tenantId: "tenant_id") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                DispatchQueue.main.async {
                    self.tokenIdLabel.text = token.identifer
                    self.tableView.reloadData()
                    self.showToken(token: token)
                }
            case .failure(let error):
                if let apiError = error as? APIError, let payError = apiError.payError {
                    print("[errorResponse] \(payError.description)")
                }

                DispatchQueue.main.async {
                    self.tokenIdLabel.text = nil
                    self.showError(error: error)
                }
            }
        }
    }

    func fetchBrands() {
        self.cardFormView.fetchBrands(tenantId: "tenant_id") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let brands):
                print("card brands => \(brands)")
            case .failure(let error):
                if let payError = error.payError {
                    print("[errorResponse] \(payError.description)")
                }

                DispatchQueue.main.async {
                    self.tokenIdLabel.text = nil
                    self.showError(error: error)
                }
            }
        }
    }
}
