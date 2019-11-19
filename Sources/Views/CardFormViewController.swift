//
//  CardFormViewController.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/11/15.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

@objc(PAYCardFormViewController)
public class CardFormViewController: UIViewController {

    @IBOutlet weak var cardFormView: CardFormLabelStyledView!
    @IBOutlet weak var saveButton: UIButton!

    private var formStyle: FormStyle?
    private var tenantId: String?

    @objc(createCardFormViewControllerWithStyle:tenantId:)
    public static func createCardFormViewController(style: FormStyle? = nil, tenantId: String? = nil) -> CardFormViewController {
        let stotyboard = UIStoryboard(name: "CardForm", bundle: Bundle(for: PAYJPSDK.self))
        guard
            let cardFormVc = stotyboard.instantiateInitialViewController() as? CardFormViewController
            else { fatalError("Couldn't instantiate CardFormViewController") }
        cardFormVc.formStyle = style
        cardFormVc.tenantId = tenantId
        return cardFormVc
    }

    public override func viewDidLoad() {
        cardFormView.delegate = self
        if let formStyle = formStyle {
            cardFormView.apply(style: formStyle)
        }
    }
}

extension CardFormViewController: CardFormViewDelegate {
    public func formInputValidated(in cardFormView: UIView, isValid: Bool) {
        saveButton.isEnabled = isValid
    }
}
