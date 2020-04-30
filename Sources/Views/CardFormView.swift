//
//  CardFormView.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/10/10.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

public protocol CardFormViewProtocol {
    /// Apply card form style.
    ///
    /// - Parameter style: card form style
    func apply(style: FormStyle)

    /// Set whether to enable card holder form.
    ///
    /// - Parameter required: card holder required
    func setCardHolderRequired(required: Bool)
}

protocol CardFormProperties {
    var brandLogoImage: UIImageView! { get }
    var cvcIconImage: UIImageView! { get }
    var ocrButton: UIButton! { get }

    var cardNumberTextField: FormTextField! { get }
    var expirationTextField: FormTextField! { get }
    var cvcTextField: FormTextField! { get }
    var cardHolderTextField: FormTextField! { get }

    var cardNumberErrorLabel: UILabel! { get }
    var expirationErrorLabel: UILabel! { get }
    var cvcErrorLabel: UILabel! { get }
    var cardHolderErrorLabel: UILabel! { get }

    var inputTextColor: UIColor { get }
    var inputTintColor: UIColor { get }
    var inputTextErrorColorEnabled: Bool { get }
    var isHolderRequired: Bool { get }
    var cardNumberSeparator: String { get }
}

protocol CardFormViewTextFieldDelegate: class {
    func didBeginEditing(textField: UITextField)
    func didDeleteBackward(textField: FormTextField)
}

// swiftlint:disable type_body_length file_length
@objcMembers
public class CardFormView: UIView {

    private let expirationFormatter: ExpirationFormatterType = ExpirationFormatter()
    private let nsErrorConverter: NSErrorConverterType = NSErrorConverter()
    private var cardIOProxy: CardIOProxy!

    public weak var delegate: CardFormViewDelegate?
    weak var textFieldDelegate: CardFormViewTextFieldDelegate?
    var viewModel: CardFormViewViewModelType = CardFormViewViewModel()
    var properties: CardFormProperties!

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
    private func updateCardNumberInput(input: String?, forceShowError: Bool = false, separator: String) {
        properties.cardNumberTextField.tintColor = .clear
        let result = viewModel.update(cardNumber: input, separator: separator)
        switch result {
        case let .success(cardNumber):
            properties.cardNumberTextField.text = cardNumber.formatted
            if properties.inputTextErrorColorEnabled {
                properties.cardNumberTextField.textColor = properties.inputTextColor
            }
            inputCardNumberSuccess(value: cardNumber)
            updateBrandLogo(brand: cardNumber.brand)
            updateCvcIcon(brand: cardNumber.brand)
            focusNextInputField(currentField: properties.cardNumberTextField)
        case let .failure(error):
            switch error {
            case let .cardNumberEmptyError(value, instant),
                 let .cardNumberInvalidError(value, instant),
                 let .cardNumberInvalidBrandError(value, instant):
                properties.cardNumberTextField.text = value?.formatted
                if properties.inputTextErrorColorEnabled {
                    properties.cardNumberTextField.textColor = forceShowError ||
                        instant ? Style.Color.red : properties.inputTextColor
                }
                inputCardNumberFailure(value: value, error: error, forceShowError: forceShowError, instant: instant)
                updateBrandLogo(brand: value?.brand)
                updateCvcIcon(brand: value?.brand)
            default:
                break
            }
        }
        properties.cardNumberErrorLabel.isHidden = properties.cardNumberTextField.text == nil

        // ブランドが変わったらcvcのチェックを走らせる
        if viewModel.isCardBrandChanged || input?.isEmpty == true {
            updateCvcInput(input: properties.cvcTextField.text)
        }
    }

    /// ブランドロゴの表示を更新する
    ///
    /// - Parameter brand: カードブランド
    func updateBrandLogo(brand: CardBrand?) {
        guard let brandLogoImage = properties.brandLogoImage else { return }
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
        properties.expirationTextField.tintColor = .clear
        let result = viewModel.update(expiration: input)
        switch result {
        case let .success(expiration):
            properties.expirationTextField.text = expiration.formatted
            if properties.inputTextErrorColorEnabled {
                properties.expirationTextField.textColor = properties.inputTextColor
            }
            inputExpirationSuccess(value: expiration)
            focusNextInputField(currentField: properties.expirationTextField)
        case let .failure(error):
            switch error {
            case let .expirationEmptyError(value, instant),
                 let .expirationInvalidError(value, instant):
                properties.expirationTextField.text = value?.formatted
                if properties.inputTextErrorColorEnabled {
                    properties.expirationTextField.textColor = forceShowError ||
                        instant ? Style.Color.red : properties.inputTextColor
                }
                inputExpirationFailure(value: value, error: error, forceShowError: forceShowError, instant: instant)
            default:
                break
            }
        }
        properties.expirationErrorLabel.isHidden = properties.expirationTextField.text == nil
    }

    /// CVCの入力フィールドを更新する
    ///
    /// - Parameters:
    ///   - input: CVC
    ///   - forceShowError: エラー表示を強制するか
    private func updateCvcInput(input: String?, forceShowError: Bool = false) {
        properties.cvcTextField.tintColor = .clear
        let result = viewModel.update(cvc: input)
        switch result {
        case let .success(cvc):
            properties.cvcTextField.text = cvc
            if properties.inputTextErrorColorEnabled {
                properties.cvcTextField.textColor = properties.inputTextColor
            }
            inputCvcSuccess(value: cvc)
            focusNextInputField(currentField: properties.cvcTextField)
        case let .failure(error):
            switch error {
            case let .cvcEmptyError(value, instant),
                 let .cvcInvalidError(value, instant):
                properties.cvcTextField.text = value
                if properties.inputTextErrorColorEnabled {
                    properties.cvcTextField.textColor = forceShowError ||
                        instant ? Style.Color.red : properties.inputTextColor
                }
                inputCvcFailure(value: value, error: error, forceShowError: forceShowError, instant: instant)
            default:
                break
            }
        }
        properties.cvcErrorLabel.isHidden = properties.cvcTextField.text == nil
    }

    /// cvcアイコンの表示を更新する
    ///
    /// - Parameter brand: カードブランド
    private func updateCvcIcon(brand: CardBrand?) {
        guard let cvcIconImage = properties.cvcIconImage else { return }
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
            properties.cardHolderTextField.text = cardHolder
            if properties.inputTextErrorColorEnabled {
                properties.cardHolderTextField.textColor = properties.inputTextColor
            }
            inputCardHolderSuccess(value: cardHolder)
        case let .failure(error):
            switch error {
            case let .cardHolderEmptyError(value, instant):
                properties.cardHolderTextField.text = value
                if properties.inputTextErrorColorEnabled {
                    properties.cardHolderTextField.textColor = forceShowError ||
                        instant ? Style.Color.red : properties.inputTextColor
                }
                inputCardHolderFailure(value: value, error: error, forceShowError: forceShowError, instant: instant)
            default:
                break
            }
        }
        properties.cardHolderErrorLabel.isHidden = properties.cardHolderTextField.text == nil
    }

    func inputCardNumberSuccess(value: CardNumber) {
        properties.cardNumberErrorLabel.text = nil
    }

    func inputCardNumberFailure(value: CardNumber?, error: Error, forceShowError: Bool, instant: Bool) {
        properties.cardNumberErrorLabel.text = forceShowError || instant ? error.localizedDescription : nil
    }

    func inputExpirationSuccess(value: Expiration) {
        properties.expirationErrorLabel.text = nil
    }

    func inputExpirationFailure(value: Expiration?, error: Error, forceShowError: Bool, instant: Bool) {
        properties.expirationErrorLabel.text = forceShowError || instant ? error.localizedDescription : nil
    }

    func inputCvcSuccess(value: String) {
        properties.cvcErrorLabel.text = nil
    }

    func inputCvcFailure(value: String?, error: Error, forceShowError: Bool, instant: Bool) {
        properties.cvcErrorLabel.text = forceShowError || instant ? error.localizedDescription : nil
    }

    func inputCardHolderSuccess(value: String) {
        properties.cardHolderErrorLabel.text = nil
    }

    func inputCardHolderFailure(value: String?, error: Error, forceShowError: Bool, instant: Bool) {
        properties.cardHolderErrorLabel.text = forceShowError || instant ? error.localizedDescription : nil
    }

    func inputCardHolderComplete() {
        properties.cardHolderErrorLabel.isHidden = properties.cardHolderTextField.text == nil
    }

    /// バリデーションOKの場合、次のTextFieldへフォーカスを移動する
    ///
    /// - Parameter currentField: 現在のTextField
    func focusNextInputField(currentField: UITextField) {
        switch currentField {
        case properties.cardNumberTextField:
            if properties.cardNumberTextField.isFirstResponder {
                properties.expirationTextField.becomeFirstResponder()
            }
        case properties.expirationTextField:
            if properties.expirationTextField.isFirstResponder {
                properties.cvcTextField.becomeFirstResponder()
            }
        case properties.cvcTextField:
            if properties.cvcTextField.isFirstResponder && properties.isHolderRequired {
                properties.cardHolderTextField.becomeFirstResponder()
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
                        (textBeforeCursor == "0" && textField == properties.expirationTextField) {
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
        properties.cardNumberTextField.tintColor = properties.inputTintColor
        properties.expirationTextField.tintColor = properties.inputTintColor
        properties.cvcTextField.tintColor = properties.inputTintColor
        properties.cardHolderTextField.tintColor = properties.inputTintColor
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
        updateCardNumberInput(input: properties.cardNumberTextField.text,
                              forceShowError: true,
                              separator: properties.cardNumberSeparator)
        updateExpirationInput(input: properties.expirationTextField.text, forceShowError: true)
        updateCvcInput(input: properties.cvcTextField.text, forceShowError: true)
        updateCardHolderInput(input: properties.cardHolderTextField.text, forceShowError: true)
        resetTintColor()
        notifyIsValidChanged()
        return isValid
    }

    public func setupInputAccessoryView(view: UIView) {
        properties.cardNumberTextField.inputAccessoryView = view
        properties.expirationTextField.inputAccessoryView = view
        properties.cvcTextField.inputAccessoryView = view
        properties.cardHolderTextField.inputAccessoryView = view
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
            case properties.cardNumberTextField:
                updateCardNumberInput(input: newText, separator: properties.cardNumberSeparator)
            case properties.expirationTextField:
                updateExpirationInput(input: newText)
            case properties.cvcTextField:
                updateCvcInput(input: newText)
            case properties.cardHolderTextField:
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
        case properties.cardNumberTextField:
            updateCardNumberInput(input: nil, separator: properties.cardNumberSeparator)
            updateCvcInput(input: properties.cvcTextField.text)
        case properties.expirationTextField:
            updateExpirationInput(input: nil)
        case properties.cvcTextField:
            updateCvcInput(input: nil)
        case properties.cardHolderTextField:
            updateCardHolderInput(input: nil)
        default:
            break
        }
        resetTintColor()
        notifyIsValidChanged()

        return true
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        properties.cardHolderTextField.resignFirstResponder()
        if isValid {
            delegate?.formInputDoneTapped(in: self)
        }
        return true
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldDelegate?.didBeginEditing(textField: textField)
    }
}

// MARK: CardIOProxyDelegate
extension CardFormView: CardIOProxyDelegate {
    public func didCancel(in proxy: CardIOProxy) {
        properties.ocrButton.isHidden = !CardIOProxy.isCardIOAvailable()
    }

    public func cardIOProxy(_ proxy: CardIOProxy, didFinishWith cardParams: CardIOCardParams) {
        updateCardNumberInput(input: cardParams.number, separator: properties.cardNumberSeparator)
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

extension CardFormView: FormTextFieldDelegate {

    func didDeleteBackward(_ textField: FormTextField) {
        textFieldDelegate?.didDeleteBackward(textField: textField)
    }
}

// swiftlint:enable type_body_length file_length
