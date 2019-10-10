//
//  CardFormViewScrollViewController.swift
//  example-swift
//
//  Created by Tadashi Wakayanagi on 2019/09/12.
//

import PAYJP

class CardFormViewScrollViewController: UIViewController, CardFormViewDelegate {

    @IBOutlet private weak var formContentView: UIView!
    @IBOutlet private weak var createTokenButton: UIButton!
    @IBOutlet private weak var tokenIdLabel: UILabel!

    private var cardFormView: CardFormLabelStyledView!

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
    }

    func isValidChanged(in cardFormView: UIView) {
        let isValid = self.cardFormView.isValid
        self.createTokenButton.isEnabled = isValid
    }

    @IBAction func cardHolderSwitchChanged(_ sender: UISwitch) {
        self.cardFormView.isHolderRequired = sender.isOn;
    }

    @IBAction func createToken(_ sender: Any) {
        if !self.cardFormView.isValid {
            return
        }
        createToken()
    }

    @IBAction func validateAndCreateToken(_ sender: Any) {
        let isValid = self.cardFormView.validateCardForm()
        if (isValid) {
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
}
