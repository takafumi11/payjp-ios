//
//  CardFormInput.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/12/05.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

class CardFormInput {
    let cardNumber: String
    let expirationMonth: String
    let expirationYear: String
    let cvc: String
    let cardHolder: String?

    init(cardNumber: String, expirationMonth: String, expirationYear: String, cvc: String, cardHolder: String? = nil) {
        self.cardNumber = cardNumber
        self.expirationMonth = expirationMonth
        self.expirationYear = expirationYear
        self.cvc = cvc
        self.cardHolder = cardHolder
    }
}
