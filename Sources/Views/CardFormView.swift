//
//  CardFormView.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/10/10.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

protocol CardFormView {

    /// property
    var inputTextColor: UIColor { get }
    var inputTintColor: UIColor { get }
    var inputTextErrorColorEnabled: Bool { get }
    var isHolderRequired: Bool { get }

    /// view
    var brandLogoImage: UIImageView! { get }
    var cvcIconImage: UIImageView! { get }
    var holderContainer: UIStackView! { get }
    var ocrButton: UIButton! { get }

    var cardNumberTextField: UITextField! { get }
    var expirationTextField: UITextField! { get }
    var cvcTextField: UITextField! { get }
    var cardHolderTextField: UITextField! { get }

    var cardNumberErrorLabel: UILabel! { get }
    var expirationErrorLabel: UILabel! { get }
    var cvcErrorLabel: UILabel! { get }
    var cardHolderErrorLabel: UILabel! { get }

    var viewModel: CardFormViewViewModelType { get }
}

extension CardFormView {

    var inputTextColor: UIColor {
        return Style.Color.black
    }
    var inputTintColor: UIColor {
        return Style.Color.blue
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
        cardNumberTextField.tintColor = .clear
        let result = viewModel.update(cardNumber: input)
        switch result {
        case let .success(cardNumber):
            cardNumberTextField.text = cardNumber.formatted
            if inputTextErrorColorEnabled {
                cardNumberTextField.textColor = self.inputTextColor
            }
            cardNumberErrorLabel.text = nil
            updateBrandLogo(brand: cardNumber.brand)
            updateCvcIcon(brand: cardNumber.brand)
            focusNextInputField(currentField: cardNumberTextField)
        case let .failure(error):
            switch error {
            case let .cardNumberEmptyError(value, instant),
                 let .cardNumberInvalidError(value, instant),
                 let .cardNumberInvalidBrandError(value, instant):
                cardNumberTextField.text = value?.formatted
                if inputTextErrorColorEnabled {
                    cardNumberTextField.textColor = forceShowError || instant ? Style.Color.red : self.inputTextColor
                }
                cardNumberErrorLabel.text = forceShowError || instant ? error.localizedDescription : nil
                updateBrandLogo(brand: value?.brand)
                updateCvcIcon(brand: value?.brand)
            default:
                break
            }
        }
        cardNumberErrorLabel.isHidden = cardNumberTextField.text == nil

        // ブランドが変わったらcvcのチェックを走らせる
        if viewModel.isBrandChanged || input?.isEmpty == true {
            updateCvcInput(input: cvcTextField.text)
        }
    }

    /// ブランドロゴの表示を更新する
    ///
    /// - Parameter brand: カードブランド
    func updateBrandLogo(brand: CardBrand?) {
        guard let brand = brand else {
            brandLogoImage.image = "icon_card".image
            return
        }
        brandLogoImage.image = brand.logoResourceName.image
    }

    /// 有効期限の入力フィールドを更新する
    ///
    /// - Parameters:
    ///   - input: 有効期限
    ///   - forceShowError: エラー表示を強制するか
    public func updateExpirationInput(input: String?, forceShowError: Bool = false) {
        let result = viewModel.update(expiration: input)
        switch result {
        case let .success(expiration):
            expirationTextField.text = expiration
            if inputTextErrorColorEnabled {
                expirationTextField.textColor = self.inputTextColor
            }
            expirationErrorLabel.text = nil
            focusNextInputField(currentField: expirationTextField)
        case let .failure(error):
            switch error {
            case let .expirationEmptyError(value, instant),
                 let .expirationInvalidError(value, instant):
                expirationTextField.text = value
                if inputTextErrorColorEnabled {
                    expirationTextField.textColor = forceShowError || instant ? Style.Color.red : self.inputTextColor
                }
                expirationErrorLabel.text = forceShowError || instant ? error.localizedDescription : nil
            default:
                break
            }
        }
        expirationErrorLabel.isHidden = expirationTextField.text == nil
    }

    /// CVCの入力フィールドを更新する
    ///
    /// - Parameters:
    ///   - input: CVC
    ///   - forceShowError: エラー表示を強制するか
    public func updateCvcInput(input: String?, forceShowError: Bool = false) {
        let result = viewModel.update(cvc: input)
        switch result {
        case let .success(cvc):
            cvcTextField.text = cvc
            if inputTextErrorColorEnabled {
                cvcTextField.textColor = self.inputTextColor
            }
            cvcErrorLabel.text = nil
            focusNextInputField(currentField: cvcTextField)
        case let .failure(error):
            switch error {
            case let .cvcEmptyError(value, instant),
                 let .cvcInvalidError(value, instant):
                cvcTextField.text = value
                if inputTextErrorColorEnabled {
                    cvcTextField.textColor = forceShowError || instant ? Style.Color.red : self.inputTextColor
                }
                cvcErrorLabel.text = forceShowError || instant ? error.localizedDescription : nil
            default:
                break
            }
        }
        cvcErrorLabel.isHidden = cvcTextField.text == nil
    }

    /// cvcアイコンの表示を更新する
    ///
    /// - Parameter brand: カードブランド
    public func updateCvcIcon(brand: CardBrand?) {
        guard let brand = brand else {
            cvcIconImage.image = "icon_card_cvc_3".image
            return
        }
        cvcIconImage.image = brand.cvcIconResourceName.image
    }

    /// カード名義の入力フィールドを更新する
    ///
    /// - Parameters:
    ///   - input: カード名義
    ///   - forceShowError: エラー表示を強制するか
    public func updateCardHolderInput(input: String?, forceShowError: Bool = false) {
        let result = viewModel.update(cardHolder: input)
        switch result {
        case let .success(holderName):
            cardHolderTextField.text = holderName
            if inputTextErrorColorEnabled {
                cardHolderTextField.textColor = self.inputTextColor
            }
            cardHolderErrorLabel.text = nil
        case let .failure(error):
            switch error {
            case let .cardHolderEmptyError(value, instant):
                cardHolderTextField.text = value
                if inputTextErrorColorEnabled {
                    cardHolderTextField.textColor = forceShowError || instant ? Style.Color.red : self.inputTextColor
                }
                cardHolderErrorLabel.text = forceShowError || instant ? error.localizedDescription : nil
            default:
                break
            }
        }
        cardHolderErrorLabel.isHidden = cardHolderTextField.text == nil
    }

    /// バリデーションOKの場合、次のTextFieldへフォーカスを移動する
    ///
    /// - Parameter currentField: 現在のTextField
    public func focusNextInputField(currentField: UITextField) {

        switch currentField {
        case cardNumberTextField:
            if cardNumberTextField.isFirstResponder {
                expirationTextField.becomeFirstResponder()
            }
        case expirationTextField:
            if expirationTextField.isFirstResponder {
                cvcTextField.becomeFirstResponder()
            }
        case cvcTextField:
            if cvcTextField.isFirstResponder && isHolderRequired {
                cardHolderTextField.becomeFirstResponder()
            }
        default:
            break
        }
    }

    /// 入力フィールドのカーソル位置を調整する
    ///
    /// - Parameters:
    ///   - textField: テキストフィールド
    ///   - range: 置換される文字列範囲
    ///   - replacement: 置換文字列
    /// - Returns: 古いテキストを保持する場合はfalse
    public func adjustInputFieldCursor(
        textField: UITextField,
        range: NSRange,
        replacement: String) -> Bool {
        // 文字挿入時にカーソルの位置を調整する
        let beginning = textField.beginningOfDocument
        let start = textField.position(from: beginning, offset: range.location)

        if let start = start {
            let cursorOffset = textField.offset(from: beginning, to: start) + replacement.count
            let newCursorPosition = textField.position(from: textField.beginningOfDocument, offset: cursorOffset)

            if let newCursorPosition = newCursorPosition,
                let newSelectedRange = textField.textRange(from: newCursorPosition, to: newCursorPosition) {
                // カーソル直前の文字列が数字以外（-, /）の場合 あるいは 0（有効期限の0埋め）の場合
                // カーソルを 1文字 後ろに移動させる
                if let newPosition = textField.position(from: newSelectedRange.start, offset: -1),
                    let range = textField.textRange(from: newPosition, to: newSelectedRange.start),
                    let textBeforeCursor = textField.text(in: range) {
                    if replacement != "" &&
                        !textBeforeCursor.isDigitsOnly ||
                        (textBeforeCursor == "0" && textField == expirationTextField) {
                        if let adjustPosition = textField.position(from: newSelectedRange.start, offset: 1),
                            let adjustSelectedRange = textField.textRange(from: adjustPosition, to: adjustPosition) {
                            textField.selectedTextRange = adjustSelectedRange
                            cardNumberTextField.tintColor = self.inputTintColor
                            return false
                        }
                    }
                }
                textField.selectedTextRange = newSelectedRange
            }
        }
        cardNumberTextField.tintColor = self.inputTintColor
        return false
    }
}
