//
//  CardFormViewController.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/11/15.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

@objc(PAYCardFormViewControllerFactory)
public class CardFormViewControllerFactory: NSObject {
    //    private override init() {}
    public static func create(style: FormStyle) -> CardFormViewController {
        let stotyboard = UIStoryboard(name: "CardForm", bundle: Bundle(for: PAYJPSDK.self))
        guard
            let vc = stotyboard.instantiateViewController(withIdentifier: "CardFormViewController") as? CardFormViewController
            else { fatalError("Couldn't instantiate CardFormViewController") }
        vc.formStyle = style
        return vc
    }
}

@objc(PAYCardFormViewController)
public class CardFormViewController: UIViewController {

    @IBOutlet weak var cardFormView: CardFormLabelStyledView!
    @IBOutlet weak var saveButton: UIButton!

    fileprivate var formStyle: FormStyle!

    public override func viewDidLoad() {
        cardFormView.delegate = self
        cardFormView.apply(style: formStyle)
    }
}

extension CardFormViewController: CardFormViewDelegate {
    public func formInputValidated(in cardFormView: UIView, isValid: Bool) {
        saveButton.isEnabled = isValid
    }
}

//extension CardFormViewController {
//    public static func create(style: FormStyle) -> CardFormViewController {
//        let stotyboard = UIStoryboard(name: "CardForm", bundle: Bundle(for: PAYJPSDK.self))
//        guard
//            let vc = stotyboard.instantiateViewController(withIdentifier: "CardFormViewController") as? CardFormViewController
//            else { fatalError("Couldn't instantiate CardFormViewController") }
//        vc.formStyle = style
//        return vc
//    }
//}
