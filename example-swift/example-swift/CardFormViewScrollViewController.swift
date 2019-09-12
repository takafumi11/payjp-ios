//
//  CardFormViewScrollViewController.swift
//  example-swift
//
//  Created by Tadashi Wakayanagi on 2019/09/12.
//

import PAYJP

class CardFormViewScrollViewController: UIViewController, CardFormViewDelegate {

    @IBOutlet weak var formContentView: UIView!
    @IBOutlet weak var createTokenButton: UIButton!

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
    }

    func isValidChanged(in cardFormView: CardFormView) {
        let isValid = self.cardFormView.isValid
        self.createTokenButton.isEnabled = isValid
    }

    @IBAction func cardHolderSwitchChanged(_ sender: UISwitch) {
        self.cardFormView.isHolderRequired = sender.isOn;
    }

    @IBAction func createToken(_ sender: Any) {
        // TODO: call createToken
    }

    @IBAction func validateAndCreateToken(_ sender: Any) {
        let isValid = self.cardFormView.validateCardForm()
        if (isValid) {
            // TODO: call createToken
        }
    }
}
