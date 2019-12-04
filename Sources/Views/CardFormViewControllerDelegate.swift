//
//  CardFormViewControllerDelegate.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/11/19.
//

import Foundation

/// CardFormViewController delegate.
@objc(PAYCardFormViewControllerDelegate)
public protocol CardFormViewControllerDelegate: class {

    /// Callback when token operation is completed.
    ///
    /// - Parameter result: CardFormResult
    func cardFormViewController(_: CardFormViewController, didCompleteWith result: CardFormResult)

    /// Callback when token creating is completed.
    ///
    /// - Parameters:
    ///   - token: token created by card form
    ///   - completionHandler: completion action
    func cardFormViewController(_: CardFormViewController,
                                didProduced token: Token,
                                completionHandler: @escaping (Error?) -> Void)
}

/// Result of token operation.
@objc public enum CardFormResult: Int {
    case success = 0
    case cancel = 1
}
