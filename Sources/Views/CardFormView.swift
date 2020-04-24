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
    var currentCardBrand: CardBrand {get}

    /// view
    var brandLogoImage: UIImageView! { get }
    var cvcIconImage: UIImageView! { get }
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

    func inputCardNumberSuccess(value: CardNumber)
    func inputCardNumberFailure(value: CardNumber?, error: Error, forceShowError: Bool, instant: Bool)
    func inputExpirationSuccess(value: Expiration)
    func inputExpirationFailure(value: Expiration?, error: Error, forceShowError: Bool, instant: Bool)
    func inputCvcSuccess(value: String)
    func inputCvcFailure(value: String?, error: Error, forceShowError: Bool, instant: Bool)
    func inputCardHolderSuccess(value: String)
    func inputCardHolderFailure(value: String?, error: Error, forceShowError: Bool, instant: Bool)

    func updateCardNumber(value: CardNumber?)
    func updateBrandLogo(brand: CardBrand?)
    func focusNextInputField(currentField: UITextField)
}

extension CardFormView {

    var inputTextColor: UIColor {
        return Style.Color.label
    }
    var inputTintColor: UIColor {
        return Style.Color.blue
    }
    var inputTextErrorColorEnabled: Bool {
        return false
    }
    var currentCardBrand: CardBrand {
        return viewModel.cardBrand
    }

    /// カード番号の入力フィールドを更新する
    ///
    /// - Parameters:
    ///   - input: カード番号
    ///   - forceShowError: エラー表示を強制するか
    func updateCardNumberInput(input: String?, forceShowError: Bool = false, separator: String = "-") {
        cardNumberTextField.tintColor = .clear
        let result = viewModel.update(cardNumber: input, separator: separator)
        switch result {
        case let .success(cardNumber):
            if inputTextErrorColorEnabled {
                cardNumberTextField.textColor = self.inputTextColor
            }
            inputCardNumberSuccess(value: cardNumber)
            updateCardNumber(value: cardNumber)
            updateBrandLogo(brand: cardNumber.brand)
            updateCvcIcon(brand: cardNumber.brand)
            focusNextInputField(currentField: cardNumberTextField)
        case let .failure(error):
            switch error {
            case let .cardNumberEmptyError(value, instant),
                 let .cardNumberInvalidError(value, instant),
                 let .cardNumberInvalidBrandError(value, instant):
                if inputTextErrorColorEnabled {
                    cardNumberTextField.textColor = forceShowError || instant ? Style.Color.red : self.inputTextColor
                }
                inputCardNumberFailure(value: value, error: error, forceShowError: forceShowError, instant: instant)
                updateCardNumber(value: value)
                updateBrandLogo(brand: value?.brand)
                updateCvcIcon(brand: value?.brand)
            default:
                break
            }
        }
        cardNumberErrorLabel.isHidden = cardNumberTextField.text == nil

        // ブランドが変わったらcvcのチェックを走らせる
        if viewModel.isCardBrandChanged || input?.isEmpty == true {
            updateCvcInput(input: cvcTextField.text)
        }
    }

    /// ブランドロゴの表示を更新する
    ///
    /// - Parameter brand: カードブランド
    func updateBrandLogo(brand: CardBrand?) {
        guard let brandLogoImage = brandLogoImage else { return }
        guard let brand = brand else {
            brandLogoImage.image = "icon_card".image
            return
        }
        brandLogoImage.image = brand.logoImage
    }

    /// 有効期限の入力フィールドを更新する
    ///
    /// - Parameters:
    ///   - input: 有効期限
    ///   - forceShowError: エラー表示を強制するか
    func updateExpirationInput(input: String?, forceShowError: Bool = false) {
        expirationTextField.tintColor = .clear
        let result = viewModel.update(expiration: input)
        switch result {
        case let .success(expiration):
            expirationTextField.text = expiration.formatted
            if inputTextErrorColorEnabled {
                expirationTextField.textColor = self.inputTextColor
            }
            inputExpirationSuccess(value: expiration)
            focusNextInputField(currentField: expirationTextField)
        case let .failure(error):
            switch error {
            case let .expirationEmptyError(value, instant),
                 let .expirationInvalidError(value, instant):
                expirationTextField.text = value?.formatted
                if inputTextErrorColorEnabled {
                    expirationTextField.textColor = forceShowError || instant ? Style.Color.red : self.inputTextColor
                }
                inputExpirationFailure(value: value, error: error, forceShowError: forceShowError, instant: instant)
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
    func updateCvcInput(input: String?, forceShowError: Bool = false) {
        cvcTextField.tintColor = .clear
        let result = viewModel.update(cvc: input)
        switch result {
        case let .success(cvc):
            cvcTextField.text = cvc
            if inputTextErrorColorEnabled {
                cvcTextField.textColor = self.inputTextColor
            }
            inputCvcSuccess(value: cvc)
            focusNextInputField(currentField: cvcTextField)
        case let .failure(error):
            switch error {
            case let .cvcEmptyError(value, instant),
                 let .cvcInvalidError(value, instant):
                cvcTextField.text = value
                if inputTextErrorColorEnabled {
                    cvcTextField.textColor = forceShowError || instant ? Style.Color.red : self.inputTextColor
                }
                inputCvcFailure(value: value, error: error, forceShowError: forceShowError, instant: instant)
            default:
                break
            }
        }
        cvcErrorLabel.isHidden = cvcTextField.text == nil
    }

    /// cvcアイコンの表示を更新する
    ///
    /// - Parameter brand: カードブランド
    func updateCvcIcon(brand: CardBrand?) {
        guard let cvcIconImage = cvcIconImage else { return }
        guard let brand = brand else {
            cvcIconImage.image = "icon_card_cvc_3".image
            return
        }
        cvcIconImage.image = brand.cvcIconImage
    }

    /// カード名義の入力フィールドを更新する
    ///
    /// - Parameters:
    ///   - input: カード名義
    ///   - forceShowError: エラー表示を強制するか
    func updateCardHolderInput(input: String?, forceShowError: Bool = false) {
        let result = viewModel.update(cardHolder: input)
        switch result {
        case let .success(cardHolder):
            if inputTextErrorColorEnabled {
                cardHolderTextField.textColor = self.inputTextColor
            }
            inputCardHolderSuccess(value: cardHolder)
        case let .failure(error):
            switch error {
            case let .cardHolderEmptyError(value, instant):
                if inputTextErrorColorEnabled {
                    cardHolderTextField.textColor = forceShowError || instant ? Style.Color.red : self.inputTextColor
                }
                inputCardHolderFailure(value: value, error: error, forceShowError: forceShowError, instant: instant)
            default:
                break
            }
        }
        cardHolderErrorLabel.isHidden = cardHolderTextField.text == nil
    }

    func inputCardNumberSuccess(value: CardNumber) {
        cardNumberErrorLabel.text = nil
    }

    func inputCardNumberFailure(value: CardNumber?, error: Error, forceShowError: Bool, instant: Bool) {
        cardNumberErrorLabel.text = forceShowError || instant ? error.localizedDescription : nil
    }

    func inputExpirationSuccess(value: Expiration) {
        expirationErrorLabel.text = nil
    }

    func inputExpirationFailure(value: Expiration?, error: Error, forceShowError: Bool, instant: Bool) {
        expirationErrorLabel.text = forceShowError || instant ? error.localizedDescription : nil
    }

    func inputCvcSuccess(value: String) {
        cvcErrorLabel.text = nil
    }

    func inputCvcFailure(value: String?, error: Error, forceShowError: Bool, instant: Bool) {
        cvcErrorLabel.text = forceShowError || instant ? error.localizedDescription : nil
    }

    func inputCardHolderSuccess(value: String) {
        cardHolderErrorLabel.text = nil
    }

    func inputCardHolderFailure(value: String?, error: Error, forceShowError: Bool, instant: Bool) {
        cardHolderErrorLabel.text = forceShowError || instant ? error.localizedDescription : nil
    }

    func inputCardHolderComplete() {
        cardHolderErrorLabel.isHidden = cardHolderTextField.text == nil
    }

    /// バリデーションOKの場合、次のTextFieldへフォーカスを移動する
    ///
    /// - Parameter currentField: 現在のTextField
    func focusNextInputField(currentField: UITextField) {
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

    func updateCardNumber(value: CardNumber?) {
        cardNumberTextField.text = value?.formatted
    }

    /// 入力フィールドのカーソル位置を調整する
    ///
    /// - Parameters:
    ///   - textField: テキストフィールド
    ///   - range: 置換される文字列範囲
    ///   - replacement: 置換文字列
    /// - Returns: 古いテキストを保持する場合はfalse
    func adjustInputFieldCursor(
        textField: UITextField,
        range: NSRange,
        replacement: String) -> Bool {

        // カード名義の場合は入力値をそのまま使用
        if textField == cardHolderTextField {
            return true
        }

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
                            resetTintColor()
                            return false
                        }
                    }
                }
                textField.selectedTextRange = newSelectedRange
            }
        }
        resetTintColor()
        return false
    }

    /// textFieldのtintColorをリセットする
    func resetTintColor() {
        cardNumberTextField.tintColor = self.inputTintColor
        expirationTextField.tintColor = self.inputTintColor
        cvcTextField.tintColor = self.inputTintColor
    }

    /// textField入力値を取得する
    func cardFormInput(completion: (Result<CardFormInput, Error>) -> Void) {
        viewModel.cardFormInput(completion: completion)
    }

    /// カメラ使用を許可していない場合にアラートを表示する
    func showCameraPermissionAlert() {
        let alertController = UIAlertController(title: "payjp_scanner_camera_permission_denied_title".localized,
                                                message: "payjp_scanner_camera_permission_denied_message".localized,
                                                preferredStyle: .alert)

        let settingsAction = UIAlertAction(
            title: "payjp_common_settings".localized,
            style: .default,
            handler: { (_) -> Void in
                guard let settingsURL = URL(string: UIApplication.openSettingsURLString ) else {
                    return
                }
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(settingsURL)
                }
        })
        let closeAction = UIAlertAction(title: "payjp_common_ok".localized,
                                        style: .default,
                                        handler: nil)
        alertController.addAction(closeAction)
        alertController.addAction(settingsAction)
        alertController.preferredAction = settingsAction

        guard let viewController = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        viewController.present(alertController, animated: true, completion: nil)
    }
}
