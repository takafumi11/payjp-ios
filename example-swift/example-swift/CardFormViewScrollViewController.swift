//
//  CardFormViewScrollViewController.swift
//  example-swift
//
//  Created by Tadashi Wakayanagi on 2019/09/12.
//

import PAYJP

class CardFormViewScrollViewController: UIViewController, CardFormViewDelegate,
UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet private weak var formContentView: UIView!
    @IBOutlet private weak var createTokenButton: UIButton!
    @IBOutlet private weak var tokenIdLabel: UILabel!
    @IBOutlet private weak var selectColorField: UITextField!

    private var cardFormView: CardFormLabelStyledView!

    private let list: [ColorTheme] = [.Normal, .Red, .Blue, .Dark]
    private var pickerView: UIPickerView!

    override func viewDidLoad() {
        // Carthageを使用している関係でstoryboardでCardFormViewを指定できないため
        // storyboardに設置しているViewにaddSubviewする形で実装している
        let x: CGFloat = self.formContentView.bounds.origin.x
        let y: CGFloat = self.formContentView.bounds.origin.y

        let width: CGFloat = self.formContentView.bounds.width
        let height: CGFloat = self.formContentView.bounds.height

        let frame: CGRect = CGRect(x: x, y: y, width: width, height: height)
        cardFormView = CardFormLabelStyledView(frame: frame)
        cardFormView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        cardFormView.isHolderRequired = true
        cardFormView.delegate = self

        self.formContentView.addSubview(cardFormView)

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
            let style = FormStyle(
                labelTextColor: red,
                inputTextColor: red,
                tintColor: red)
            self.cardFormView.apply(style: style)
            self.cardFormView.backgroundColor = .clear
        case .Blue:
            let blue = UIColor(0, 103, 187)
            let style = FormStyle(
                labelTextColor: blue,
                inputTextColor: blue,
                tintColor: blue)
            self.cardFormView.apply(style: style)
            self.cardFormView.backgroundColor = .clear
        case .Dark:
            let darkGray = UIColor(61, 61, 61)
            let lightGray = UIColor(80, 80, 80)
            let style = FormStyle(
                labelTextColor: .white,
                inputTextColor: .white,
                tintColor: .white,
                inputFieldBackgroundColor: lightGray)
            self.cardFormView.apply(style: style)
            self.cardFormView.backgroundColor = darkGray
        default:
            let defaultBlue = UIColor(12, 95, 250)
            let style = FormStyle(
                labelTextColor: .black,
                inputTextColor: .black,
                tintColor: defaultBlue)
            self.cardFormView.apply(style: style)
            self.cardFormView.backgroundColor = .clear
        }
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
        self.createTokenButton.isEnabled = isValid
    }

    @IBAction func cardHolderSwitchChanged(_ sender: UISwitch) {
        self.cardFormView.isHolderRequired = sender.isOn
    }

    @IBAction func createToken(_ sender: Any) {
        if !self.cardFormView.isValid {
            return
        }
        createToken()
    }

    @IBAction func validateAndCreateToken(_ sender: Any) {
        let isValid = self.cardFormView.validateCardForm()
        if isValid {
            createToken()
        }
    }

    func createToken() {
        self.cardFormView.createToken(tenantId: "tenant_id") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                DispatchQueue.main.async {
                    self.tokenIdLabel.text = token.identifer
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
