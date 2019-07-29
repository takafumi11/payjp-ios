//
//  CardFormViewViewModel.swift
//  PAYJP
//
//  Created by Li-Hsuan Chen on 2019/07/19.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

protocol CardFormViewViewModelType {
    mutating func updateCardNumber(input: String?) -> ((formatted: String, brand: CardBrand)?, errorMessage: String?)?
    mutating func updateExpiration(input: String?) -> (String?, errorMessage: String?)?

    func checkInputValid() -> Bool
}

struct CardFormViewViewModel: CardFormViewViewModelType {

    let cardNumberFormatter: CardNumberFormatterType
    let cardNumberValidator: CardNumberValidatorType
    let expirationFormatter: ExpirationFormatterType
    let expirationValidator: ExpirationValidatorType
    let expirationExtractor: ExpirationExtractorType

    private var cardNumber: String? = nil
    private var monthYear: (String, String)? = nil

    init(cardNumberFormatter: CardNumberFormatterType = CardNumberFormatter(),
        cardNumberValidator: CardNumberValidatorType = CardNumberValidator(),
        expirationFormatter: ExpirationFormatterType = ExpirationFormatter(),
        expirationValidator: ExpirationValidatorType = ExpirationValidator(),
        expirationExtractor: ExpirationExtractorType = ExpirationExtractor()) {
        self.cardNumberFormatter = cardNumberFormatter
        self.cardNumberValidator = cardNumberValidator
        self.expirationFormatter = expirationFormatter
        self.expirationValidator = expirationValidator
        self.expirationExtractor = expirationExtractor
    }

    mutating func updateCardNumber(input: String?) -> ((formatted: String, brand: CardBrand)?, errorMessage: String?)? {
        let tuple = self.cardNumberFormatter.string(from: input)
        cardNumber = self.cardNumberFormatter.filter(from: tuple?.formatted)

        var isValid = true
        var errorMessage: String? = nil
        if let cardNumber = cardNumber {
            // リアルタイムチェックは14桁以上の時だけ行う
            if cardNumber.count >= 14 {
                isValid = self.cardNumberValidator.isValid(cardNumber: cardNumber)
            }
        }
        if !isValid {
            errorMessage = "正しいカード番号を入力してください"
        }
        return (tuple, errorMessage)
    }

    mutating func updateExpiration(input: String?) -> (String?, errorMessage: String?)? {
        var isValid = true
        var errorMessage: String? = nil

        do {
            monthYear = try self.expirationExtractor.extract(expiration: input)
        } catch (let error) {
            // TODO: error handling
            print(error)
            errorMessage = "正しい有効期限を入力してください"
        }

        if let (month, year) = monthYear {
            isValid = self.expirationValidator.isValid(month: month, year: year)
        }
        if !isValid {
            errorMessage = "正しい有効期限を入力してください"
        }
        return (self.expirationFormatter.string(from: input), errorMessage)
    }

    func checkInputValid() -> Bool {
        return checkCardNumberValid() && checkExpirationValid()
    }

    func checkCardNumberValid() -> Bool {
        if let cardNumber = cardNumber {
            return self.cardNumberValidator.isValid(cardNumber: cardNumber)
        }
        return false
    }

    func checkExpirationValid() -> Bool {
        if let (month, year) = monthYear {
            return self.expirationValidator.isValid(month: month, year: year)
        }
        return false
    }
}
