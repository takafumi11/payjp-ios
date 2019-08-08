//
//  CardFormViewViewModel.swift
//  PAYJP
//
//  Created by Li-Hsuan Chen on 2019/07/19.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

protocol CardFormViewViewModelType {
    /// カード番号の入力値を更新する
    ///
    /// - Parameter input: カード番号
    /// - Returns: 入力結果
    func updateCardNumber(input: String?) -> Result<CardNumber, FormError<CardNumber>>
    /// 有効期限の入力値を更新する
    ///
    /// - Parameter input: 有効期限
    /// - Returns: 入力結果
    func updateExpiration(input: String?) -> Result<String, FormError<String>>
    /// CVCの入力値を更新する
    ///
    /// - Parameter input: CVC
    /// - Returns: 入力結果
    func updateCvc(input: String?) -> Result<String, FormError<String>>
    /// カード名義の入力値を更新する
    ///
    /// - Parameter input: カード名義
    /// - Returns: 入力結果
    func updateCardHolder(input: String?) -> Result<String, FormError<String>>
    /// 全フィールドのバリデーションチェック
    ///
    /// - Returns: true バリデーションOK
    func isValid() -> Bool
}

class CardFormViewViewModel: CardFormViewViewModelType {

    let cardNumberFormatter: CardNumberFormatterType
    let cardNumberValidator: CardNumberValidatorType
    let expirationFormatter: ExpirationFormatterType
    let expirationValidator: ExpirationValidatorType
    let expirationExtractor: ExpirationExtractorType
    let cvcFormatter: CvcFormatterType
    let cvcValidator: CvcValidatorType

    private var cardNumber: String? = nil
    private var monthYear: (String, String)? = nil
    private var cvc: String? = nil
    private var cardHolder: String? = nil

    // MARK: - Lifecycle

    init(cardNumberFormatter: CardNumberFormatterType = CardNumberFormatter(),
        cardNumberValidator: CardNumberValidatorType = CardNumberValidator(),
        expirationFormatter: ExpirationFormatterType = ExpirationFormatter(),
        expirationValidator: ExpirationValidatorType = ExpirationValidator(),
        expirationExtractor: ExpirationExtractorType = ExpirationExtractor(),
        cvcFormatter: CvcFormatterType = CvcFormatter(),
        cvcValidator: CvcValidatorType = CvcValidator()) {
        self.cardNumberFormatter = cardNumberFormatter
        self.cardNumberValidator = cardNumberValidator
        self.expirationFormatter = expirationFormatter
        self.expirationValidator = expirationValidator
        self.expirationExtractor = expirationExtractor
        self.cvcFormatter = cvcFormatter
        self.cvcValidator = cvcValidator
    }

    // MARK: - CardFormViewViewModelType

    func updateCardNumber(input: String?) -> Result<CardNumber, FormError<CardNumber>> {
        guard let cardNumberInput = self.cardNumberFormatter.string(from: input), input != nil, !input!.isEmpty else {
            cardNumber = nil
            return .failure(.error(value: nil, message: "カード番号を入力してください"))
        }
        cardNumber = cardNumberInput.formatted.numberfy()

        if let cardNumber = cardNumber {
            if !self.cardNumberValidator.isCardNumberLengthValid(cardNumber: cardNumber) {
                return .failure(.error(value: cardNumberInput, message: "正しいカード番号を入力してください"))
            } else if !self.cardNumberValidator.isLuhnValid(cardNumber: cardNumber) {
                return .failure(.instantError(value: cardNumberInput, message: "正しいカード番号を入力してください"))
            } else if cardNumberInput.brand == CardBrand.unknown {
                return .failure(.error(value: cardNumberInput, message: "カードブランドが有効ではありません"))
            }
            // TODO: 利用可能ブランドかどうかの判定
        }
        return .success(cardNumberInput)
    }

    func updateExpiration(input: String?) -> Result<String, FormError<String>> {
        guard let expirationInput = self.expirationFormatter.string(from: input), input != nil, !input!.isEmpty else {
            monthYear = nil
            return .failure(.error(value: nil, message: "有効期限を入力してください"))
        }

        do {
            monthYear = try self.expirationExtractor.extract(expiration: expirationInput)
        } catch {
            return .failure(.instantError(value: expirationInput, message: "正しい有効期限を入力してください"))
        }

        if let (month, year) = monthYear {
            if !self.expirationValidator.isValid(month: month, year: year) {
                return .failure(.instantError(value: expirationInput, message: "正しい有効期限を入力してください"))
            }
        } else {
            return .failure(.error(value: expirationInput, message: "正しい有効期限を入力してください"))
        }
        return .success(expirationInput)
    }

    func updateCvc(input: String?) -> Result<String, FormError<String>> {
        guard let cvcInput = self.cvcFormatter.string(from: input), input != nil, !input!.isEmpty else {
            cvc = nil
            return .failure(.error(value: nil, message: "CVCを入力してください"))
        }
        cvc = cvcInput

        if let cvc = cvc {
            if !self.cvcValidator.isValid(cvc: cvc) {
                return .failure(.error(value: cvc, message: "正しいCVCを入力してください"))
            }
        }
        return .success(cvcInput)
    }

    func updateCardHolder(input: String?) -> Result<String, FormError<String>> {
        guard let holderInput = input, input != nil, !input!.isEmpty else {
            cardHolder = nil
            return .failure(.error(value: nil, message: "カード名義を入力してください"))
        }
        cardHolder = holderInput

        return .success(holderInput)
    }

    func isValid() -> Bool {
        return checkCardNumberValid() &&
            checkExpirationValid() &&
            checkCvcValid() &&
            checkCardHolderValid()
    }

    // MARK: - Helpers

    private func checkCardNumberValid() -> Bool {
        if let cardNumber = cardNumber {
            return self.cardNumberValidator.isValid(cardNumber: cardNumber)
        }
        return false
    }

    private func checkExpirationValid() -> Bool {
        if let (month, year) = monthYear {
            return self.expirationValidator.isValid(month: month, year: year)
        }
        return false
    }

    private func checkCvcValid() -> Bool {
        if let cvc = cvc {
            return self.cvcValidator.isValid(cvc: cvc)
        }
        return false
    }

    private func checkCardHolderValid() -> Bool {
        if let cardHolder = cardHolder {
            return !cardHolder.isEmpty
        }
        return false
    }
}
