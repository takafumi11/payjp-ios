//
//  CardFormViewControllerDelegate.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/11/19.
//

import Foundation

@objc(PAYCardFormViewControllerDelegate)
public protocol CardFormViewControllerDelegate: class {
    func cardFormViewController(_: CardFormViewController, didCompleteWithResult: CardFormResult)
    func cardFormViewController(_: CardFormViewController, didProducedToken: Token, completionHandler: TokenHandler?)
}

@objc public enum CardFormResult: Int {
    case cancel = 0
    case success = 1
}

public typealias TokenHandler = (Error?) -> Void
