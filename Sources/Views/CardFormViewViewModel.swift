//
//  CardFormViewViewModel.swift
//  PAYJP
//
//  Created by Li-Hsuan Chen on 2019/07/19.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

protocol CardFormViewViewModelType {
    func formatCardNumber(input: String?) -> (String, CardBrand)?
    func checkCardNumberValid(input: String) -> Bool
}

struct CardFormViewViewModel: CardFormViewViewModelType {

    let cardNumberFormatter: CardNumberFormatterType
    let cardNumberValidator: CardNumberValidatorType
    
    private var cardNumber: String? = nil

    init(cardNumberFormatter: CardNumberFormatterType = CardNumberFormatter(),
        cardNumberValidator: CardNumberValidatorType = CardNumberValidator()) {
        self.cardNumberFormatter = cardNumberFormatter
        self.cardNumberValidator = cardNumberValidator
    }

    func formatCardNumber(input: String?) -> (String, CardBrand)? {
        return cardNumberFormatter.string(from: input)
    }

    func checkCardNumberValid(input: String) -> Bool {
        return cardNumberValidator.isValid(cardNumber: input)
    }
}
