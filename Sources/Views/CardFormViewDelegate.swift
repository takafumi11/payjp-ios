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
    /// - Parameter cardFormView: CardFormView
    func isValidChanged(in cardFormView: UIView)
}

protocol CardFormAction {
    
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
    
    /// fetch accepted card brands
    ///
    /// - Parameter tenantId: identifier of tenant
    func fetchBrands(tenantId: String?)
    
    /// validate card form
    ///
    /// - Returns: is valid form
    func validateCardForm() -> Bool
    
    /// apply card form style
    ///
    /// - Parameter style: card form style
    func apply(style: FormStyle)
}
