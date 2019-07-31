//
//  CardFormViewViewModel.swift
//  PAYJP
//
//  Created by Li-Hsuan Chen on 2019/07/19.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

protocol CardFormViewViewModelType {
    mutating func updateCardNumber(input: String?) -> Result<CardNumber?, FormError<CardNumber>>
    mutating func updateExpiration(input: String?) -> Result<String?, FormError<String>>

    func isValid() -> Bool
}

struct CardFormViewViewModel: CardFormViewViewModelType {

    let cardNumberFormatter: CardNumberFormatterType
    let cardNumberValidator: CardNumberValidatorType
    let expirationFormatter: ExpirationFormatterType
    let expirationValidator: ExpirationValidatorType
    let expirationExtractor: ExpirationExtractorType

    private var cardNumber: String? = nil
    private var monthYear: (String, String)? = nil

    // MARK: - Lifecycle

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

    // MARK: - CardFormViewViewModelType

    mutating func updateCardNumber(input: String?) -> Result<CardNumber?, FormError<CardNumber>> {
        let cardNumberInfo = self.cardNumberFormatter.string(from: input)
        cardNumber = cardNumberInfo?.formatted.numberfy()

        if input == nil || input!.isEmpty {
            return .failure(.error(value: cardNumberInfo, message: "カード番号を入力してください"))
        } else {
            if let cardNumber = cardNumber {
                if !self.cardNumberValidator.isCardNumberLengthValid(cardNumber: cardNumber) {
                    return .failure(.error(value: cardNumberInfo, message: "正しいカード番号を入力してください"))
                } else if !self.cardNumberValidator.isLuhnValid(cardNumber: cardNumber) {
                    return .failure(.instantError(value: cardNumberInfo, message: "正しいカード番号を入力してください"))
                } else if cardNumberInfo?.brand == CardBrand.unknown {
                    return .failure(.error(value: cardNumberInfo, message: "カードブランドが有効ではありません"))
                }
                // TODO: 利用可能ブランドかどうかの判定
            }
        }
        return .success(cardNumberInfo)
    }

    mutating func updateExpiration(input: String?) -> Result<String?, FormError<String>> {
        let expiration = self.expirationFormatter.string(from: input)

        if input == nil || input!.isEmpty {
            return .failure(.error(value: expiration, message: "有効期限を入力してください"))
        } else {
            do {
                monthYear = try self.expirationExtractor.extract(expiration: input)
            } catch {
                return .failure(.error(value: expiration, message: "正しい有効期限を入力してください"))
            }

            if let (month, year) = monthYear {
                if !self.expirationValidator.isValid(month: month, year: year) {
                    return .failure(.instantError(value: expiration, message: "正しい有効期限を入力してください"))
                }
            } else {
                return .failure(.instantError(value: expiration, message: "正しい有効期限を入力してください"))
            }
        }
        return .success(expiration)
    }

    func isValid() -> Bool {
        return checkCardNumberValid() && checkExpirationValid()
    }

    // MARK: - Helpers

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
