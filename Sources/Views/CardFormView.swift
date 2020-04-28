//
//  CardFormView.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/10/10.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

public protocol CardFormViewProtocol {
    /// Apply card form style
    ///
    /// - Parameter style: card form style
    func apply(style: FormStyle)
}

protocol CardFormViewTextFieldDelegate: class {
    func textFieldDidBeginEditing(_ textField: UITextField)
}

@objcMembers
public class CardFormView: UIView {

    private let expirationFormatter: ExpirationFormatterType = ExpirationFormatter()
    private let nsErrorConverter: NSErrorConverterType = NSErrorConverter()
    private var cardIOProxy: CardIOProxy!

    public weak var delegate: CardFormViewDelegate?
    weak var textDelegate: CardFormViewTextFieldDelegate?
    var viewModel: CardFormViewViewModelType = CardFormViewViewModel()
    var isHolderRequired: Bool = false

    /// view
    weak var brandLogoImage: UIImageView! = nil
    weak var cvcIconImage: UIImageView! = nil
    weak var ocrButton: UIButton! = nil

    weak var cardNumberTextField: UITextField! = nil
    weak var expirationTextField: UITextField! = nil
    weak var cvcTextField: UITextField! = nil
    weak var cardHolderTextField: UITextField! = nil

    weak var cardNumberErrorLabel: UILabel! = nil
    weak var expirationErrorLabel: UILabel! = nil
    weak var cvcErrorLabel: UILabel! = nil
    weak var cardHolderErrorLabel: UILabel! = nil

    var inputTextColor: UIColor = Style.Color.label
    var inputTintColor: UIColor = Style.Color.blue
    var inputTextErrorColorEnabled: Bool = false

    var currentCardBrand: CardBrand {
        return viewModel.cardBrand
    }
    var currentCardNumber: CardNumber? {
        return viewModel.cardNumber
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() {
        cardIOProxy = CardIOProxy(delegate: self)
    }

    /// カード番号の入力フィールドを更新する
    ///
    /// - Parameters:
    ///   - input: カード番号
    ///   - forceShowError: エラー表示を強制するか
    private func updateCardNumberInput(input: String?, forceShowError: Bool = false, separator: String = "-") {
        cardNumberTextField.tintColor = .clear
        let result = viewModel.update(cardNumber: input, separator: separator)
        switch result {
        case let .success(cardNumber):
            cardNumberTextField.text = cardNumber.formatted
            if inputTextErrorColorEnabled {
                cardNumberTextField.textColor = self.inputTextColor
            }
            inputCardNumberSuccess(value: cardNumber)
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
                inputCardNumberFailure(value: value, error: error, forceShowError: forceShowError, instant: instant)
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
    private func updateExpirationInput(input: String?, forceShowError: Bool = false) {
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
    private func updateCvcInput(input: String?, forceShowError: Bool = false) {
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
    private func updateCvcIcon(brand: CardBrand?) {
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
    private func updateCardHolderInput(input: String?, forceShowError: Bool = false) {
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

    /// 入力フィールドのカーソル位置を調整する
    ///
    /// - Parameters:
    ///   - textField: テキストフィールド
    ///   - range: 置換される文字列範囲
    ///   - replacement: 置換文字列
    /// - Returns: 古いテキストを保持する場合はfalse
    private func adjustInputFieldCursor(
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
    private func resetTintColor() {
        cardNumberTextField.tintColor = self.inputTintColor
        expirationTextField.tintColor = self.inputTintColor
        cvcTextField.tintColor = self.inputTintColor
    }

    /// textField入力値を取得する
    func cardFormInput(completion: (Result<CardFormInput, Error>) -> Void) {
        viewModel.cardFormInput(completion: completion)
    }

    /// カメラ使用を許可していない場合にアラートを表示する
    private func showCameraPermissionAlert() {
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

// MARK: CardFormAction
extension CardFormView: CardFormAction {

    public var isValid: Bool {
        return viewModel.isValid
    }

    @nonobjc public func createToken(tenantId: String? = nil, completion: @escaping (Result<Token, Error>) -> Void) {
        viewModel.createToken(with: tenantId, completion: completion)
    }

    public func createTokenWith(_ tenantId: String?, completion: @escaping (Token?, NSError?) -> Void) {
        viewModel.createToken(with: tenantId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                completion(result, nil)
            case .failure(let error):
                completion(nil, self.nsErrorConverter.convert(from: error))
            }
        }
    }

    @nonobjc public func fetchBrands(tenantId: String?, completion: CardBrandsResult?) {
        viewModel.fetchAcceptedBrands(with: tenantId, completion: completion)
    }

    public func fetchBrandsWith(_ tenantId: String?, completion: (([NSString]?, NSError?) -> Void)?) {
        viewModel.fetchAcceptedBrands(with: tenantId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                let converted = result.map { (brand: CardBrand) -> NSString in return brand.rawValue as NSString }
                completion?(converted, nil)
            case .failure(let error):
                completion?(nil, self.nsErrorConverter.convert(from: error))
            }
        }
    }

    public func validateCardForm() -> Bool {
        updateCardNumberInput(input: cardNumberTextField.text, forceShowError: true)
        updateExpirationInput(input: expirationTextField.text, forceShowError: true)
        updateCvcInput(input: cvcTextField.text, forceShowError: true)
        updateCardHolderInput(input: cardHolderTextField.text, forceShowError: true)
        resetTintColor()
        notifyIsValidChanged()
        return isValid
    }

    public func setupInputAccessoryView(view: UIView) {
        cardNumberTextField.inputAccessoryView = view
        expirationTextField.inputAccessoryView = view
        cvcTextField.inputAccessoryView = view
        cardHolderTextField.inputAccessoryView = view
    }

    func notifyIsValidChanged() {
        self.delegate?.formInputValidated(in: self, isValid: isValid)
    }
}

// MARK: UITextFieldDelegate
extension CardFormView: UITextFieldDelegate {

    public func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {

        if let currentText = textField.text {
            let range = Range(range, in: currentText)!
            let newText = currentText.replacingCharacters(in: range, with: string)

            switch textField {
            case cardNumberTextField:
                updateCardNumberInput(input: newText, separator: " ")
            case expirationTextField:
                updateExpirationInput(input: newText)
            case cvcTextField:
                updateCvcInput(input: newText)
            case cardHolderTextField:
                updateCardHolderInput(input: newText)
            default:
                break
            }
        }
        notifyIsValidChanged()

        return adjustInputFieldCursor(textField: textField, range: range, replacement: string)
    }

    public func textFieldShouldClear(_ textField: UITextField) -> Bool {

        switch textField {
        case cardNumberTextField:
            updateCardNumberInput(input: nil)
            updateCvcInput(input: cvcTextField.text)
        case expirationTextField:
            updateExpirationInput(input: nil)
        case cvcTextField:
            updateCvcInput(input: nil)
        case cardHolderTextField:
            updateCardHolderInput(input: nil)
        default:
            break
        }
        resetTintColor()
        notifyIsValidChanged()

        return true
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        cardHolderTextField.resignFirstResponder()
        if isValid {
            delegate?.formInputDoneTapped(in: self)
        }
        return true
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        textDelegate?.textFieldDidBeginEditing(textField)
    }
}

// MARK: CardIOProxyDelegate
extension CardFormView: CardIOProxyDelegate {
    public func didCancel(in proxy: CardIOProxy) {
        ocrButton.isHidden = !CardIOProxy.isCardIOAvailable()
    }

    public func cardIOProxy(_ proxy: CardIOProxy, didFinishWith cardParams: CardIOCardParams) {
        updateCardNumberInput(input: cardParams.number)
        updateExpirationInput(input: expirationFormatter.string(month: cardParams.expiryMonth?.intValue,
                                                                year: cardParams.expiryYear?.intValue))
        updateCvcInput(input: cardParams.cvc)

        notifyIsValidChanged()
    }
}

extension CardFormView: CardFormViewModelDelegate {

    func startScanner() {
        if let viewController = parentViewController, CardIOProxy.canReadCardWithCamera() {
            cardIOProxy.presentCardIO(from: viewController)
        }
    }

    func showPermissionAlert() {
        showCameraPermissionAlert()
    }
}
