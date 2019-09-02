//
//  CardFormViewViewModel.swift
//  PAYJP
//
//  Created by Li-Hsuan Chen on 2019/07/19.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

protocol CardFormViewViewModelType {
    var isBrandChanged: Bool { get }
    /// カード番号の入力値を更新する
    ///
    /// - Parameter input: カード番号
    /// - Returns: 入力結果
    func updateCardNumber(input: String?) -> Result<CardNumber, FormError>
    /// 有効期限の入力値を更新する
    ///
    /// - Parameter input: 有効期限
    /// - Returns: 入力結果
    func updateExpiration(input: String?) -> Result<String, FormError>
    /// CVCの入力値を更新する
    ///
    /// - Parameter input: CVC
    /// - Returns: 入力結果
    func updateCvc(input: String?) -> Result<String, FormError>
    /// カード名義の入力値を更新する
    ///
    /// - Parameter input: カード名義
    /// - Returns: 入力結果
    func updateCardHolder(input: String?) -> Result<String, FormError>
    /// 全フィールドのバリデーションチェック
    ///
    /// - Returns: true バリデーションOK
    func isValid() -> Bool
    /// 利用可能ブランドを取得する
    ///
    /// - Parameters:
    ///   - tenantId: テナントID
    ///   - completion: 取得結果
    func getAcceptedBrands(with tenantId: String?, completion: CardBrandsResult?)
    

    func presentCardIOIfAvailable(from presentingViewController: UIViewController)
    
    func isCardIOAvailable() -> Bool
}

class CardFormViewViewModel: CardFormViewViewModelType, CardIOProxyDelegate {

    private let cardNumberFormatter: CardNumberFormatterType
    private let cardNumberValidator: CardNumberValidatorType
    private let expirationFormatter: ExpirationFormatterType
    private let expirationValidator: ExpirationValidatorType
    private let expirationExtractor: ExpirationExtractorType
    private let cvcFormatter: CvcFormatterType
    private let cvcValidator: CvcValidatorType
    private let accountsService: AccountsServiceType

    private var cardNumber: String? = nil
    private var cardBrand: CardBrand = .unknown
    private var acceptedCardBrands: [CardBrand]? = nil
    private var monthYear: (month: String, year: String)? = nil
    private var cvc: String? = nil
    private var cardHolder: String? = nil
    
    private var cardIoProxy: CardIOProxy!
    
    func isCardIOAvailable() -> Bool {
        return CardIOProxy.isCardIOAvailable()
    }

    var isBrandChanged = false

    // MARK: - Lifecycle

    init(cardNumberFormatter: CardNumberFormatterType = CardNumberFormatter(),
        cardNumberValidator: CardNumberValidatorType = CardNumberValidator(),
        expirationFormatter: ExpirationFormatterType = ExpirationFormatter(),
        expirationValidator: ExpirationValidatorType = ExpirationValidator(),
        expirationExtractor: ExpirationExtractorType = ExpirationExtractor(),
        cvcFormatter: CvcFormatterType = CvcFormatter(),
        cvcValidator: CvcValidatorType = CvcValidator(),
        accountsService: AccountsServiceType = AccountsService.shared) {
        self.cardNumberFormatter = cardNumberFormatter
        self.cardNumberValidator = cardNumberValidator
        self.expirationFormatter = expirationFormatter
        self.expirationValidator = expirationValidator
        self.expirationExtractor = expirationExtractor
        self.cvcFormatter = cvcFormatter
        self.cvcValidator = cvcValidator
        self.accountsService = accountsService

        self.cardIoProxy = CardIOProxy(delegate: self)
    }

    // MARK: - CardFormViewViewModelType

    func updateCardNumber(input: String?) -> Result<CardNumber, FormError> {
        guard let cardNumberInput = self.cardNumberFormatter.string(from: input), let input = input, !input.isEmpty else {
            cardNumber = nil
            cardBrand = .unknown
            isBrandChanged = true
            return .failure(.cardNumberEmptyError(value: nil, isInstant: false))
        }
        isBrandChanged = cardBrand != cardNumberInput.brand
        cardNumber = cardNumberInput.formatted.numberfy()
        cardBrand = cardNumberInput.brand

        if let cardNumber = cardNumber {
            // 利用可能ブランドのチェック
            if let acceptedCardBrands = acceptedCardBrands {
                if cardNumberInput.brand != .unknown && !acceptedCardBrands.contains(cardNumberInput.brand) {
                    return .failure(.cardNumberInvalidError(value: cardNumberInput, isInstant: false))
                }
            }
            // 桁数チェック
            if cardNumber.count == cardNumberInput.brand.numberLength {
                if !self.cardNumberValidator.isLuhnValid(cardNumber: cardNumber) {
                    return .failure(.cardNumberInvalidError(value: cardNumberInput, isInstant: true))
                }
            } else if cardNumber.count > cardNumberInput.brand.numberLength {
                return .failure(.cardNumberInvalidError(value: cardNumberInput, isInstant: true))
            } else {
                return .failure(.cardNumberInvalidError(value: cardNumberInput, isInstant: false))
            }

            if cardNumberInput.brand == .unknown {
                return .failure(.cardNumberInvalidBrandError(value: cardNumberInput, isInstant: false))
            }
        }
        return .success(cardNumberInput)
    }

    func updateExpiration(input: String?) -> Result<String, FormError> {
        guard let expirationInput = self.expirationFormatter.string(from: input), let input = input, !input.isEmpty else {
            monthYear = nil
            return .failure(.expirationEmptyError(value: nil, isInstant: false))
        }

        do {
            monthYear = try self.expirationExtractor.extract(expiration: expirationInput)
        } catch {
            return .failure(.expirationInvalidError(value: expirationInput, isInstant: true))
        }

        if let (month, year) = monthYear {
            if !self.expirationValidator.isValid(month: month, year: year) {
                return .failure(.expirationInvalidError(value: expirationInput, isInstant: true))
            }
        } else {
            return .failure(.expirationInvalidError(value: expirationInput, isInstant: false))
        }
        return .success(expirationInput)
    }

    func updateCvc(input: String?) -> Result<String, FormError> {
        guard var cvcInput = self.cvcFormatter.string(from: input, brand: cardBrand), let input = input, !input.isEmpty else {
            cvc = nil
            return .failure(.cvcEmptyError(value: nil, isInstant: false))
        }
        if isBrandChanged {
            cvcInput = input
        }
        cvc = cvcInput

        if let cvc = cvc {
            let result = self.cvcValidator.isValid(cvc: cvc, brand: cardBrand)
            if !result.validated {
                return .failure(.cvcInvalidError(value: cvc, isInstant: result.isInstant))
            }
        }
        return .success(cvcInput)
    }

    func updateCardHolder(input: String?) -> Result<String, FormError> {
        guard let holderInput = input, let input = input, !input.isEmpty else {
            cardHolder = nil
            return .failure(.cardHolderEmptyError(value: nil, isInstant: false))
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

    func getAcceptedBrands(with tenantId: String?, completion: CardBrandsResult?) {
        accountsService.getAcceptedBrands(tenantId: tenantId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let brands):
                self.acceptedCardBrands = brands
                completion?(.success(brands))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }

    func presentCardIOIfAvailable(from presentingViewController: UIViewController) {
        if CardIOProxy.isCardIOAvailable() {
            self.cardIoProxy?.presentCardIO(from: presentingViewController)
        }
    }
    
    // MARK: - Helpers

    private func checkCardNumberValid() -> Bool {
        if let cardNumber = cardNumber {
            return self.cardNumberValidator.isValid(cardNumber: cardNumber, brand: cardBrand)
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
            let result = self.cvcValidator.isValid(cvc: cvc, brand: cardBrand)
            return result.validated
        }
        return false
    }

    private func checkCardHolderValid() -> Bool {
        if let cardHolder = cardHolder {
            return !cardHolder.isEmpty
        }
        return false
    }
    
    // MARK: - CardIOProxyDelegate
    
    func cardIOProxy(_ proxy: CardIOProxy, didFinishWithCardParams cardParams: [AnyHashable : Any]) {
        // TODO: Implementation
    }
}
