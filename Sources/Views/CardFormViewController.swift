//
//  CardFormViewController.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/11/15.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

@objcMembers @objc(PAYCardFormViewController)
public class CardFormViewController: UIViewController {

    @IBOutlet weak var cardFormView: CardFormLabelStyledView!
    @IBOutlet weak var saveButton: UIButton!

    private var formStyle: FormStyle?
    private var tenantId: String?

    public weak var delegate: CardFormViewControllerDelegate?

    @objc(createCardFormViewControllerWithStyle:tenantId:)
    public static func createCardFormViewController(style: FormStyle? = nil,
                                                    tenantId: String? = nil) -> CardFormViewController {
        let stotyboard = UIStoryboard(name: "CardForm", bundle: Bundle(for: PAYJPSDK.self))
        guard
            let cardFormVc = stotyboard.instantiateInitialViewController() as? CardFormViewController
            else { fatalError("Couldn't instantiate CardFormViewController") }
        cardFormVc.formStyle = style
        cardFormVc.tenantId = tenantId
        return cardFormVc
    }

    @IBAction func registerCardTapped(_ sender: Any) {
        createToken()
    }

    public override func viewDidLoad() {
        cardFormView.delegate = self
        if let formStyle = formStyle {
            cardFormView.apply(style: formStyle)
        }
    }

    private func createToken() {
        cardFormView.createToken(tenantId: "tenant_id") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.delegate?.cardFormViewController(self, didProducedToken: token) { error in
                    if let error = error {
                        print("[errorResponse] \(error.localizedDescription)")
                        // TODO: エラー
                    } else {
                        self.delegate?.cardFormViewController(self, didCompleteWithResult: .success)
                    }
                }
            case .failure(let error):
                if let apiError = error as? APIError, let payError = apiError.payError {
                    print("[errorResponse] \(payError.description)")
                }
                // TODO: エラー
            }
        }
    }
}

extension CardFormViewController: CardFormViewDelegate {
    public func formInputValidated(in cardFormView: UIView, isValid: Bool) {
        saveButton.isEnabled = isValid
    }
}
