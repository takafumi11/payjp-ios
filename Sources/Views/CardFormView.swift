//
//  CardFormView.swift
//  PAYJP
//
//  Created by Li-Hsuan Chen on 2019/07/17.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import UIKit

@objc(PAYCardFormViewDelegate)
public protocol CardFormViewDelegate: class {
    func isValidChanged(in cardFormView: CardFormView)
}

@IBDesignable @objcMembers @objc(PAYCardFormView)
public class CardFormView: UIView {
    @IBInspectable public var isHolderRequired: Bool = true {
        didSet {
            holderContainer.isHidden = !isHolderRequired
            viewModel.update(isCardHolderEnabled: isHolderRequired)
            self.delegate?.isValidChanged(in: self)
        }
    }

    @IBOutlet private weak var cardNumberTitleLabel: UILabel!
    @IBOutlet private weak var expirationTitleLabel: UILabel!
    @IBOutlet private weak var cvcTitleLabel: UILabel!
    @IBOutlet private weak var cardHolderTitleLabel: UILabel!

    @IBOutlet private weak var brandLogoImage: UIImageView!
    @IBOutlet private weak var cardNumberTextField: UITextField!
    @IBOutlet private weak var expirationTextField: UITextField!
    @IBOutlet private weak var cvcTextField: UITextField!
    @IBOutlet private weak var cardHolderTextField: UITextField!

    @IBOutlet private weak var cardNumberErrorLabel: UILabel!
    @IBOutlet private weak var expirationErrorLabel: UILabel!
    @IBOutlet private weak var cvcErrorLabel: UILabel!
    @IBOutlet private weak var cardHolderErrorLabel: UILabel!

    @IBOutlet private weak var holderContainer: UIStackView!

    @IBOutlet private weak var ocrButton: UIButton!
    @IBOutlet private weak var cvcInformationButton: UIButton!

    private var contentView: UIView!
    public weak var delegate: CardFormViewDelegate?
    
    private var cardIOProxy: CardIOProxy!
    private let expirationFormatter: ExpirationFormatterType = ExpirationFormatter()

    // MARK:

    private let viewModel: CardFormViewViewModelType = CardFormViewViewModel()

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
        let bundle = Bundle(for: CardFormView.self)
        let nib = UINib(nibName: "CardFormView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView

        if let view = view {
            contentView = view
            view.frame = bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(view)
        }

        backgroundColor = .clear

        cardNumberTitleLabel.text = "payjp_card_form_number_label".localized
        expirationTitleLabel.text = "payjp_card_form_expiration_label".localized
        cvcTitleLabel.text = "payjp_card_form_cvc_label".localized
        cardHolderTitleLabel.text = "payjp_card_form_holder_name_label".localized

        cardNumberTextField.delegate = self
        expirationTextField.delegate = self
        cvcTextField.delegate = self
        cardHolderTextField.delegate = self

        cardIOProxy = CardIOProxy(delegate: self)
        ocrButton.isHidden = !CardIOProxy.isCardIOAvailable()
        
        getAcceptedBrands()
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
    @nonobjc public func createToken(tenantId: String? = nil, completion: @escaping (Result<Token, APIError>) -> Void) {
        self.viewModel.createToken(with: tenantId, completion: completion)
    }

    // create token for objective-c
    ///
    /// - Parameters:
    ///   - tenantId: identifier of tenant
    ///   - completion: completion action
    @objc public func createTokenWith(_ tenantId: String?, completion: @escaping (Token?, NSError?) -> Void) {
        self.viewModel.createToken(with: tenantId) { result in
            switch result {
            case .success(let result):
                completion(result, nil)
            case .failure(let error):
                completion(nil, error.nsErrorValue())
            }
        }
    }

    public func getAcceptedBrands(tenantId: String? = nil, completion: CardBrandsResult? = nil) {
        viewModel.fetchAcceptedBrands(with: tenantId, completion: completion)
    }
    
    public func validateCardForm() -> Bool {
        updateCardNumberInput(input: cardNumberTextField.text, forceShowError: true)
        updateExpirationInput(input: expirationTextField.text, forceShowError: true)
        updateCvcInput(input: cvcTextField.text, forceShowError: true)
        updateCardHolderInput(input: cardHolderTextField.text, forceShowError: true)
        return isValid
    }
    
    @IBAction func onTapOcrButton(_ sender: Any) {
        if let viewController = parentViewController, CardIOProxy.isCardIOAvailable() {
            cardIOProxy.presentCardIO(from: viewController)
        }
    }
}

extension CardFormView: UITextFieldDelegate {

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
    private func updateCardNumberInput(input: String?, forceShowError: Bool = false) {
        let result = viewModel.update(cardNumber: input)
        switch result {
        case let .success(cardNumber):
            cardNumberTextField.text = cardNumber.formatted
            cardNumberErrorLabel.text = nil
            updateBrandLogo(brand: cardNumber.brand)
            focusNextInputField(currentField: cardNumberTextField)
        case let .failure(error):
            switch error {
            case let .cardNumberEmptyError(value, instant),
                 let .cardNumberInvalidError(value, instant),
                 let .cardNumberInvalidBrandError(value, instant):
                cardNumberTextField.text = value?.formatted
                cardNumberErrorLabel.text = forceShowError || instant ? error.localizedDescription : nil
                updateBrandLogo(brand: value?.brand)
            default:
                break
            }
        }
        cardNumberErrorLabel.isHidden = cardNumberTextField.text == nil

        // ブランドが変わったらcvcのチェックを走らせる
        if viewModel.isBrandChanged {
            updateCvcInput(input: cvcTextField.text)
        }
    }

    /// ブランドロゴの表示を更新する
    ///
    /// - Parameter brand: カードブランド
    private func updateBrandLogo(brand: CardBrand?) {
        guard let brand = brand else {
            brandLogoImage.image = "default".image
            return
        }
        brandLogoImage.image = brand.logoResourceName.image
    }

    /// 有効期限の入力フィールドを更新する
    ///
    /// - Parameters:
    ///   - input: 有効期限
    ///   - forceShowError: エラー表示を強制するか
    private func updateExpirationInput(input: String?, forceShowError: Bool = false) {
        let result = viewModel.update(expiration: input)
        switch result {
        case let .success(expiration):
            expirationTextField.text = expiration
            expirationErrorLabel.text = nil
            focusNextInputField(currentField: expirationTextField)
        case let .failure(error):
            switch error {
            case let .expirationEmptyError(value, instant),
                 let .expirationInvalidError(value, instant):
                expirationTextField.text = value
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
    private func updateCvcInput(input: String?, forceShowError: Bool = false) {
        let result = viewModel.update(cvc: input)
        switch result {
        case let .success(cvc):
            cvcTextField.text = cvc
            cvcErrorLabel.text = nil
            focusNextInputField(currentField: cvcTextField)
        case let .failure(error):
            switch error {
            case let .cvcEmptyError(value, instant),
                 let .cvcInvalidError(value, instant):
                cvcTextField.text = value
                cvcErrorLabel.text = forceShowError || instant ? error.localizedDescription : nil
            default:
                break
            }
        }
        cvcErrorLabel.isHidden = cvcTextField.text == nil
    }

    /// カード名義の入力フィールドを更新する
    ///
    /// - Parameters:
    ///   - input: カード名義
    ///   - forceShowError: エラー表示を強制するか
    private func updateCardHolderInput(input: String?, forceShowError: Bool = false) {
        let result = viewModel.update(cardHolder: input)
        switch result {
        case let .success(holderName):
            cardHolderTextField.text = holderName
            cardHolderErrorLabel.text = nil
        case let .failure(error):
            switch error {
            case let .cardHolderEmptyError(value, instant):
                cardHolderTextField.text = value
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
    private func focusNextInputField(currentField: UITextField) {

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

extension CardFormView: CardIOProxyDelegate {
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
