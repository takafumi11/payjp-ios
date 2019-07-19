//
//  CvcValidator.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/07/19.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

protocol CvcValidatorType {
    func isValid(cvc: String)->Bool
}

class CvcValidator: CvcValidatorType {
    
    func isValid(cvc: String) -> Bool {
        return false
    }
}
