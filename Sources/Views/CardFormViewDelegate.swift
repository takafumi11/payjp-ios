//
//  CardFormViewDelegate.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/10/11.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

@objc(PAYCardFormViewDelegate)
public protocol CardFormViewDelegate: class {

    /// callback when form valid is changed
    ///
    /// - Parameters:
    ///   - cardFormView: CardFormView
    ///   - isValid: form is valid
    func isValidChanged(in cardFormView: UIView, isValid: Bool)
}

public protocol CardFormAction {

    /// form is valid
    var isValid: Bool { get }

    /// create token for swift
    ///
    /// - Parameters:
    ///   - tenantId: identifier of tenant
    ///   - completion: completion action
    func createToken(tenantId: String?, completion: @escaping (Result<Token, Error>) -> Void)

    /// create token for objective-c
    ///
    /// - Parameters:
    ///   - tenantId: identifier of tenant
    ///   - completion: completion action
    func createTokenWith(_ tenantId: String?, completion: @escaping (Token?, NSError?) -> Void)

    /// fetch accepted card brands for swift
    ///
    /// - Parameters:
    ///   - tenantId: tenantId identifier of tenant
    ///   - completion: completion action
    func fetchBrands(tenantId: String?, completion: CardBrandsResult?)

    /// fetch accepted card brands for objective-c
    ///
    /// - Parameters:
    ///   - tenantId: tenantId identifier of tenant
    ///   - completion: completion action
    func fetchBrandsWith(_ tenantId: String?, completion: (([NSString]?, NSError?) -> Void)?)

    /// validate card form
    ///
    /// - Returns: is valid form
    func validateCardForm() -> Bool

    /// apply card form style
    ///
    /// - Parameter style: card form style
    func apply(style: FormStyle)
}
