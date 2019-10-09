//
//  CardFormStyledView.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/09/19.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import UIKit

@objc(PAYCardFormLabelStyledViewDelegate)
public protocol CardFormLabelStyledViewDelegate: class {
    func isValidChanged(in cardFormView: CardFormLabelStyledView)
}

@IBDesignable @objcMembers @objc(PAYCardFormLabelStyledView)
public class CardFormLabelStyledView: UIView {

    @IBInspectable public var isHolderRequired: Bool = true {
        didSet {
            holderContainer.isHidden = !isHolderRequired
            viewModel.update(isCardHolderEnabled: isHolderRequired)
            self.delegate?.isValidChanged(in: self)
        }
    }

    @IBOutlet private weak var brandLogoImage: UIImageView!
    @IBOutlet private weak var cvcIconImage: UIImageView!

    @IBOutlet private weak var cardNumberLabel: UILabel!
    @IBOutlet private weak var expirationLabel: UILabel!
    @IBOutlet private weak var cvcLabel: UILabel!
    @IBOutlet private weak var cardHolderLabel: UILabel!
    @IBOutlet private weak var cardNumberFieldBackground: UIView!
    @IBOutlet private weak var expirationFieldBackground: UIView!
    @IBOutlet private weak var cvcFieldBackground: UIView!
    @IBOutlet private weak var cardHolderFieldBackground: UIView!

    @IBOutlet private weak var cardNumberTextField: UITextField!
    @IBOutlet private weak var expirationTextField: UITextField!
    @IBOutlet private weak var cvcTextField: UITextField!
    @IBOutlet private weak var cardHolderTextField: UITextField!

    @IBOutlet private weak var cardNumberErrorLabel: UILabel!
    @IBOutlet private weak var expirationErrorLabel: UILabel!
    @IBOutlet private weak var cvcErrorLabel: UILabel!
    @IBOutlet private weak var cardHolderErrorLabel: UILabel!

    @IBOutlet weak var holderContainer: UIStackView!

    @IBOutlet weak var ocrButton: UIButton!

    // MARK:

    public weak var delegate: CardFormLabelStyledViewDelegate?
    private var contentView: UIView!
    private var cardIOProxy: CardIOProxy!
    private let viewModel: CardFormViewViewModelType = CardFormViewViewModel()
    private let expirationFormatter: ExpirationFormatterType = ExpirationFormatter()
    private let nsErrorConverter: NSErrorConverterType = NSErrorConverter()
    private var inputTextColor: UIColor = Style.Color.black

    // MARK: Lifecycle

    override public init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() {
        let bundle = Bundle(for: CardFormLabelStyledView.self)
        let nib = UINib(nibName: "CardFormLabelStyledView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView

        if let view = view {
            contentView = view
            view.frame = bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(view)
        }

        backgroundColor = .clear

        // label
        cardNumberLabel.text = "payjp_card_form_number_label".localized
        expirationLabel.text = "payjp_card_form_expiration_label".localized
        cvcLabel.text = "payjp_card_form_cvc_label".localized
        cardHolderLabel.text = "payjp_card_form_holder_name_label".localized

        // placeholder
        cardNumberTextField.attributedPlaceholder = NSAttributedString(string: "payjp_card_form_label_style_number_placeholder".localized, attributes: [NSAttributedString.Key.foregroundColor: Style.Color.gray])
        expirationTextField.attributedPlaceholder = NSAttributedString(string: "payjp_card_form_label_style_expiration_placeholder".localized, attributes: [NSAttributedString.Key.foregroundColor: Style.Color.gray])
        cvcTextField.attributedPlaceholder = NSAttributedString(string: "payjp_card_form_label_style_cvc_placeholder".localized, attributes: [NSAttributedString.Key.foregroundColor: Style.Color.gray])
        cardHolderTextField.attributedPlaceholder = NSAttributedString(string: "payjp_card_form_label_style_holder_name_placeholder".localized, attributes: [NSAttributedString.Key.foregroundColor: Style.Color.gray])

        cardNumberFieldBackground.roundingCorners(corners: .allCorners, radius: 4.0)
        expirationFieldBackground.roundingCorners(corners: .allCorners, radius: 4.0)
        cvcFieldBackground.roundingCorners(corners: .allCorners, radius: 4.0)
        cardHolderFieldBackground.roundingCorners(corners: .allCorners, radius: 4.0)

        cardNumberTextField.delegate = self
        expirationTextField.delegate = self
        cvcTextField.delegate = self
        cardHolderTextField.delegate = self

        ocrButton.imageView?.contentMode = .scaleAspectFit
        ocrButton.contentHorizontalAlignment = .fill
        ocrButton.contentVerticalAlignment = .fill

        cardIOProxy = CardIOProxy(delegate: self)
        ocrButton.isHidden = !CardIOProxy.isCardIOAvailable()

        viewModel.fetchAcceptedBrands(with: nil, completion: nil)
    }

    override public var intrinsicContentSize: CGSize {
        return contentView.intrinsicContentSize
    }

    // MARK: - Out bound actions

    public var isValid: Bool {
        return viewModel.isValid()
    }

    /// create token for swift
    ///
    /// - Parameters:
    ///   - tenantId: identifier of tenant
    ///   - completion: completion action
    @nonobjc public func createToken(tenantId: String? = nil, completion: @escaping (Result<Token, Error>) -> Void) {
        self.viewModel.createToken(with: tenantId, completion: completion)
    }

    // create token for objective-c
    ///
    /// - Parameters:
    ///   - tenantId: identifier of tenant
    ///   - completion: completion action
    @objc public func createTokenWith(_ tenantId: String?, completion: @escaping (Token?, NSError?) -> Void) {
        self.viewModel.createToken(with: tenantId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                completion(result, nil)
            case .failure(let error):
                completion(nil, self.nsErrorConverter.convert(from: error))
            }
        }
    }

    public func validateCardForm() -> Bool {
        updateCardNumberInput(input: cardNumberTextField.text, forceShowError: true)
        updateExpirationInput(input: expirationTextField.text, forceShowError: true)
        updateCvcInput(input: cvcTextField.text, forceShowError: true)
        updateCardHolderInput(input: cardHolderTextField.text, forceShowError: true)
        self.delegate?.isValidChanged(in: self)
        return isValid
    }

    public func apply(style: FormStyle) {
        let labelTextColor = style.labelTextColor ?? Style.Color.black
        let inputTextColor = style.inputTextColor
        let tintColor = style.tintColor
        self.inputTextColor = inputTextColor
        // label text
        cardNumberLabel.textColor = labelTextColor
        expirationLabel.textColor = labelTextColor
        cvcLabel.textColor = labelTextColor
        cardHolderLabel.textColor = labelTextColor
        // input text
        cardNumberTextField.textColor = inputTextColor
        expirationTextField.textColor = inputTextColor
        cvcTextField.textColor = inputTextColor
        cardHolderTextField.textColor = inputTextColor
        // tint
        cardNumberTextField.tintColor = tintColor
        expirationTextField.tintColor = tintColor
        cvcTextField.tintColor = tintColor
        cardHolderTextField.tintColor = tintColor
    }

    @IBAction func onTapOcrButton(_ sender: Any) {
        if let viewController = parentViewController, CardIOProxy.isCardIOAvailable() {
            cardIOProxy.presentCardIO(from: viewController)
        }
    }
}

extension CardFormLabelStyledView: UITextFieldDelegate {

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if let currentText = textField.text {
            let range = Range(range, in: currentText)!
            let newText = currentText.replacingCharacters(in: range, with: string)

            switch textField {
            case cardNumberTextField:
                updateCardNumberInput(input: newText)
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
        self.delegate?.isValidChanged(in: self)

        return false
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
        self.delegate?.isValidChanged(in: self)

        return true
    }

    /// カード番号の入力フィールドを更新する
    ///
    /// - Parameters:
    ///   - input: カード番号
    ///   - forceShowError: エラー表示を強制するか
    public func updateCardNumberInput(input: String?, forceShowError: Bool = false) {
        let result = viewModel.update(cardNumber: input)
        switch result {
        case let .success(cardNumber):
            cardNumberTextField.text = cardNumber.formatted
            cardNumberTextField.textColor = self.inputTextColor
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
                cardNumberTextField.textColor = forceShowError || instant ? Style.Color.red : self.inputTextColor
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
    public func updateBrandLogo(brand: CardBrand?) {
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
            expirationTextField.textColor = self.inputTextColor
            expirationErrorLabel.text = nil
            focusNextInputField(currentField: expirationTextField)
        case let .failure(error):
            switch error {
            case let .expirationEmptyError(value, instant),
                 let .expirationInvalidError(value, instant):
                expirationTextField.text = value
                expirationTextField.textColor = forceShowError || instant ? Style.Color.red : self.inputTextColor
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
            cvcTextField.textColor = self.inputTextColor
            cvcErrorLabel.text = nil
            focusNextInputField(currentField: cvcTextField)
        case let .failure(error):
            switch error {
            case let .cvcEmptyError(value, instant),
                 let .cvcInvalidError(value, instant):
                cvcTextField.text = value
                cvcTextField.textColor = forceShowError || instant ? Style.Color.red : self.inputTextColor
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
            cardHolderTextField.textColor = self.inputTextColor
            cardHolderErrorLabel.text = nil
        case let .failure(error):
            switch error {
            case let .cardHolderEmptyError(value, instant):
                cardHolderTextField.text = value
                cardHolderTextField.textColor = forceShowError || instant ? Style.Color.red : self.inputTextColor
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
}

extension CardFormLabelStyledView: CardIOProxyDelegate {
    public func didCancel(in proxy: CardIOProxy) {
        ocrButton.isHidden = !CardIOProxy.isCardIOAvailable()
    }

    public func cardIOProxy(_ proxy: CardIOProxy, didFinishWith cardParams: CardIOCardParams) {
        updateCardNumberInput(input: cardParams.number)
        updateExpirationInput(input: expirationFormatter.string(month: cardParams.expiryMonth?.intValue, year: cardParams.expiryYear?.intValue))
        updateCvcInput(input: cardParams.cvc)

        self.delegate?.isValidChanged(in: self)
    }
}
