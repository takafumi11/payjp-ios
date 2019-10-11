//
//  CardFormView.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/10/10.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

@objc(PAYCardFormViewDelegate)
public protocol CardFormViewDelegate: class {
    func isValidChanged(in cardFormView: UIView)
}

protocol CardFormAction {
    var isValid: Bool { get }
    func createToken(tenantId: String?, completion: @escaping (Result<Token, Error>) -> Void)
    func createTokenWith(_ tenantId: String?, completion: @escaping (Token?, NSError?) -> Void)
    func fetchBrands(tenantId: String?)
    func validateCardForm() -> Bool
    func apply(style: FormStyle)
}

protocol CardFormView {
    var baseViewModel: CardFormViewViewModelType { get }
    var baseInputTextColor: UIColor { get }
    var inputTextErrorColorEnabled: Bool { get }
    var isHolderRequired: Bool { get }

    var baseBrandLogoImage: UIImageView { get }
    var baseCvcIconImage: UIImageView { get }
    var baseHolderContainer: UIStackView { get }
    var baseOcrButton: UIButton { get }

    var baseCardNumberTextField: UITextField { get }
    var baseExpirationTextField: UITextField { get }
    var baseCvcTextField: UITextField { get }
    var baseCardHolderTextField: UITextField { get }

    var baseCardNumberErrorLabel: UILabel { get }
    var baseExpirationErrorLabel: UILabel { get }
    var baseCvcErrorLabel: UILabel { get }
    var baseCardHolderErrorLabel: UILabel { get }
}

extension CardFormView {

    var baseInputTextColor: UIColor {
        return Style.Color.black
    }
    var inputTextErrorColorEnabled: Bool {
        return false
    }

    /// カード番号の入力フィールドを更新する
    ///
    /// - Parameters:
    ///   - input: カード番号
    ///   - forceShowError: エラー表示を強制するか
    func updateCardNumberInput(input: String?, forceShowError: Bool = false) {
        let result = baseViewModel.update(cardNumber: input)
        switch result {
        case let .success(cardNumber):
            baseCardNumberTextField.text = cardNumber.formatted
            if inputTextErrorColorEnabled {
                baseCardNumberTextField.textColor = self.baseInputTextColor
            }
            baseCardNumberErrorLabel.text = nil
            updateBrandLogo(brand: cardNumber.brand)
            updateCvcIcon(brand: cardNumber.brand)
            focusNextInputField(currentField: baseCardNumberTextField)
        case let .failure(error):
            switch error {
            case let .cardNumberEmptyError(value, instant),
                 let .cardNumberInvalidError(value, instant),
                 let .cardNumberInvalidBrandError(value, instant):
                baseCardNumberTextField.text = value?.formatted
                if inputTextErrorColorEnabled {
                    baseCardNumberTextField.textColor = forceShowError ||
                        instant ? Style.Color.red : self.baseInputTextColor
                }
                baseCardNumberErrorLabel.text = forceShowError || instant ? error.localizedDescription : nil
                updateBrandLogo(brand: value?.brand)
                updateCvcIcon(brand: value?.brand)
            default:
                break
            }
        }
        baseCardNumberErrorLabel.isHidden = baseCardNumberTextField.text == nil

        // ブランドが変わったらcvcのチェックを走らせる
        if baseViewModel.isBrandChanged || input?.isEmpty == true {
            updateCvcInput(input: baseCvcTextField.text)
        }
    }

    /// ブランドロゴの表示を更新する
    ///
    /// - Parameter brand: カードブランド
    func updateBrandLogo(brand: CardBrand?) {
        guard let brand = brand else {
            baseBrandLogoImage.image = "icon_card".image
            return
        }
        baseBrandLogoImage.image = brand.logoResourceName.image
    }

    /// 有効期限の入力フィールドを更新する
    ///
    /// - Parameters:
    ///   - input: 有効期限
    ///   - forceShowError: エラー表示を強制するか
    public func updateExpirationInput(input: String?, forceShowError: Bool = false) {
        let result = baseViewModel.update(expiration: input)
        switch result {
        case let .success(expiration):
            baseExpirationTextField.text = expiration
            if inputTextErrorColorEnabled {
                baseExpirationTextField.textColor = self.baseInputTextColor
            }
            baseExpirationErrorLabel.text = nil
            focusNextInputField(currentField: baseExpirationTextField)
        case let .failure(error):
            switch error {
            case let .expirationEmptyError(value, instant),
                 let .expirationInvalidError(value, instant):
                baseExpirationTextField.text = value
                if inputTextErrorColorEnabled {
                    baseExpirationTextField.textColor = forceShowError ||
                        instant ? Style.Color.red : self.baseInputTextColor
                }
                baseExpirationErrorLabel.text = forceShowError || instant ? error.localizedDescription : nil
            default:
                break
            }
        }
        baseExpirationErrorLabel.isHidden = baseExpirationTextField.text == nil
    }

    /// CVCの入力フィールドを更新する
    ///
    /// - Parameters:
    ///   - input: CVC
    ///   - forceShowError: エラー表示を強制するか
    public func updateCvcInput(input: String?, forceShowError: Bool = false) {
        let result = baseViewModel.update(cvc: input)
        switch result {
        case let .success(cvc):
            baseCvcTextField.text = cvc
            if inputTextErrorColorEnabled {
                baseCvcTextField.textColor = self.baseInputTextColor
            }
            baseCvcErrorLabel.text = nil
            focusNextInputField(currentField: baseCvcTextField)
        case let .failure(error):
            switch error {
            case let .cvcEmptyError(value, instant),
                 let .cvcInvalidError(value, instant):
                baseCvcTextField.text = value
                if inputTextErrorColorEnabled {
                    baseCvcTextField.textColor = forceShowError || instant ? Style.Color.red : self.baseInputTextColor
                }
                baseCvcErrorLabel.text = forceShowError || instant ? error.localizedDescription : nil
            default:
                break
            }
        }
        baseCvcErrorLabel.isHidden = baseCvcTextField.text == nil
    }

    /// cvcアイコンの表示を更新する
    ///
    /// - Parameter brand: カードブランド
    public func updateCvcIcon(brand: CardBrand?) {
        guard let brand = brand else {
            baseCvcIconImage.image = "icon_card_cvc_3".image
            return
        }
        baseCvcIconImage.image = brand.cvcIconResourceName.image
    }

    /// カード名義の入力フィールドを更新する
    ///
    /// - Parameters:
    ///   - input: カード名義
    ///   - forceShowError: エラー表示を強制するか
    public func updateCardHolderInput(input: String?, forceShowError: Bool = false) {
        let result = baseViewModel.update(cardHolder: input)
        switch result {
        case let .success(holderName):
            baseCardHolderTextField.text = holderName
            if inputTextErrorColorEnabled {
                baseCardHolderTextField.textColor = self.baseInputTextColor
            }
            baseCardHolderErrorLabel.text = nil
        case let .failure(error):
            switch error {
            case let .cardHolderEmptyError(value, instant):
                baseCardHolderTextField.text = value
                if inputTextErrorColorEnabled {
                    baseCardHolderTextField.textColor = forceShowError ||
                        instant ? Style.Color.red : self.baseInputTextColor
                }
                baseCardHolderErrorLabel.text = forceShowError || instant ? error.localizedDescription : nil
            default:
                break
            }
        }
        baseCardHolderErrorLabel.isHidden = baseCardHolderTextField.text == nil
    }

    /// バリデーションOKの場合、次のTextFieldへフォーカスを移動する
    ///
    /// - Parameter currentField: 現在のTextField
    public func focusNextInputField(currentField: UITextField) {

        switch currentField {
        case baseCardNumberTextField:
            if baseCardNumberTextField.isFirstResponder {
                baseExpirationTextField.becomeFirstResponder()
            }
        case baseExpirationTextField:
            if baseExpirationTextField.isFirstResponder {
                baseCvcTextField.becomeFirstResponder()
            }
        case baseCvcTextField:
            if baseCvcTextField.isFirstResponder && isHolderRequired {
                baseCardHolderTextField.becomeFirstResponder()
            }
        default:
            break
        }
    }
}
