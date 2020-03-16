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

    var errorMessageLabel: UILabel! { get }
    var cardNumberDisplayLabel: UILabel! { get }
    var cvcDisplayLabel: UILabel! { get }
    var cardHolderDisplayLabel: UILabel! { get }
    var expirationDisplayLabel: UILabel! { get }

    var viewModel: CardFormViewViewModelType { get }
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
            if let cardNumberDisplayLabel = cardNumberDisplayLabel {
                cardNumberDisplayLabel.text = cardNumber.formatted
            }
            if inputTextErrorColorEnabled {
                cardNumberTextField.textColor = self.inputTextColor
            }
            if let cardNumberErrorLabel = cardNumberErrorLabel {
                cardNumberErrorLabel.text = nil
            }
            if let errorMessageLabel = errorMessageLabel {
                errorMessageLabel.text = nil
            }
            updateBrandLogo(brand: cardNumber.brand)
            updateCvcIcon(brand: cardNumber.brand)
            focusNextInputField(currentField: cardNumberTextField)
        case let .failure(error):
            switch error {
            case let .cardNumberEmptyError(value, instant),
                 let .cardNumberInvalidError(value, instant),
                 let .cardNumberInvalidBrandError(value, instant):
                cardNumberTextField.text = value?.formatted
                if let cardNumberDisplayLabel = cardNumberDisplayLabel {
                    cardNumberDisplayLabel.text = value?.formatted
                }
                if inputTextErrorColorEnabled {
                    cardNumberTextField.textColor = forceShowError || instant ? Style.Color.red : self.inputTextColor
                }
                if let cardNumberErrorLabel = cardNumberErrorLabel {
                    cardNumberErrorLabel.text = forceShowError || instant ? error.localizedDescription : nil
                }
                if let errorMessageLabel = errorMessageLabel {
                    errorMessageLabel.text = forceShowError || instant ? error.localizedDescription : nil
                }
                updateBrandLogo(brand: value?.brand)
                updateCvcIcon(brand: value?.brand)
            default:
                break
            }
        }
        if let cardNumberErrorLabel = cardNumberErrorLabel {
            cardNumberErrorLabel.isHidden = cardNumberTextField.text == nil
        }
        if let errorMessageLabel = errorMessageLabel {
            errorMessageLabel.isHidden = cardNumberTextField.text == nil
        }

        // ブランドが変わったらcvcのチェックを走らせる
        if viewModel.isBrandChanged || input?.isEmpty == true {
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
        brandLogoImage.image = brand.logoResourceName.image
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
            expirationTextField.text = expiration
            if let expirationDisplayLabel = expirationDisplayLabel {
                expirationDisplayLabel.text = expiration
            }
            if inputTextErrorColorEnabled {
                expirationTextField.textColor = self.inputTextColor
            }
            if let expirationErrorLabel = expirationErrorLabel {
                expirationErrorLabel.text = nil
            }
            if let errorMessageLabel = errorMessageLabel {
                errorMessageLabel.text = nil
            }
            focusNextInputField(currentField: expirationTextField)
        case let .failure(error):
            switch error {
            case let .expirationEmptyError(value, instant),
                 let .expirationInvalidError(value, instant):
                expirationTextField.text = value
                if let expirationDisplayLabel = expirationDisplayLabel {
                    expirationDisplayLabel.text = value
                }
                if inputTextErrorColorEnabled {
                    expirationTextField.textColor = forceShowError || instant ? Style.Color.red : self.inputTextColor
                }
                if let expirationErrorLabel = expirationErrorLabel {
                    expirationErrorLabel.text = forceShowError || instant ? error.localizedDescription : nil
                }
                if let errorMessageLabel = errorMessageLabel {
                    errorMessageLabel.text = forceShowError || instant ? error.localizedDescription : nil
                }
            default:
                break
            }
        }
        if let expirationErrorLabel = expirationErrorLabel {
            expirationErrorLabel.isHidden = expirationErrorLabel.text == nil
        }
        if let errorMessageLabel = errorMessageLabel {
            errorMessageLabel.isHidden = expirationTextField.text == nil
        }
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
            if let cvcDisplayLabel = cvcDisplayLabel {
                cvcDisplayLabel.text = cvc
            }
            if inputTextErrorColorEnabled {
                cvcTextField.textColor = self.inputTextColor
            }
            if let cvcErrorLabel = cvcErrorLabel {
                cvcErrorLabel.text = nil
            }
            if let errorMessageLabel = errorMessageLabel {
                errorMessageLabel.text = nil
            }
            focusNextInputField(currentField: cvcTextField)
        case let .failure(error):
            switch error {
            case let .cvcEmptyError(value, instant),
                 let .cvcInvalidError(value, instant):
                cvcTextField.text = value
                if let cvcDisplayLabel = cvcDisplayLabel {
                    cvcDisplayLabel.text = value
                }
                if inputTextErrorColorEnabled {
                    cvcTextField.textColor = forceShowError || instant ? Style.Color.red : self.inputTextColor
                }
                if let cvcErrorLabel = cvcErrorLabel {
                    cvcErrorLabel.text = forceShowError || instant ? error.localizedDescription : nil
                }
                if let errorMessageLabel = errorMessageLabel {
                    errorMessageLabel.text = forceShowError || instant ? error.localizedDescription : nil
                }
            default:
                break
            }
        }
        if let cvcErrorLabel = cvcErrorLabel {
            cvcErrorLabel.isHidden = cvcErrorLabel.text == nil
        }
        if let errorMessageLabel = errorMessageLabel {
            errorMessageLabel.isHidden = expirationTextField.text == nil
        }
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
        cvcIconImage.image = brand.cvcIconResourceName.image
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
            if let cardHolderDisplayLabel = cardHolderDisplayLabel {
                cardHolderDisplayLabel.text = cardHolder
            }
            if inputTextErrorColorEnabled {
                cardHolderTextField.textColor = self.inputTextColor
            }
            if let cardHolderErrorLabel = cardHolderErrorLabel {
                cardHolderErrorLabel.text = nil
            }
            if let errorMessageLabel = errorMessageLabel {
                errorMessageLabel.text = nil
            }
        case let .failure(error):
            switch error {
            case let .cardHolderEmptyError(_, instant):
                if inputTextErrorColorEnabled {
                    cardHolderTextField.textColor = forceShowError || instant ? Style.Color.red : self.inputTextColor
                }
                if let cardHolderErrorLabel = cardHolderErrorLabel {
                    cardHolderErrorLabel.text = forceShowError || instant ? error.localizedDescription : nil
                }
                if let errorMessageLabel = errorMessageLabel {
                    errorMessageLabel.text = forceShowError || instant ? error.localizedDescription : nil
                }
            default:
                break
            }
        }
        if let cardHolderErrorLabel = cardHolderErrorLabel {
            cardHolderErrorLabel.isHidden = cardHolderErrorLabel.text == nil
        }
        if let errorMessageLabel = errorMessageLabel {
            errorMessageLabel.isHidden = expirationTextField.text == nil
        }
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

        let settingsAction = UIAlertAction(title: "payjp_common_settings".localized,
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
