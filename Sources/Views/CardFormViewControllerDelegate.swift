//
//  CardFormViewControllerDelegate.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/11/19.
//

import Foundation

@objc(PAYCardFormViewControllerDelegate)
public protocol CardFormViewControllerDelegate: class {
    func cardFormViewController(_: CardFormViewController, didCompleteWith result: CardFormResult)
    func cardFormViewController(_: CardFormViewController,
                                didProduced token: Token,
                                completionHandler: @escaping (Error?) -> Void)
}

@objc public enum CardFormResult: Int {
    case success = 0
    case cancel = 1
}
