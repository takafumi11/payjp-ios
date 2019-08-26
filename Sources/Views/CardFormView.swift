//
//  CardFormView.swift
//  PAYJP
//
//  Created by Li-Hsuan Chen on 2019/07/17.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import UIKit

@objc(PAYCardFormInputDelegate)
public protocol FormInputDelegate: class {
    func inputValidated()
}

@IBDesignable @objcMembers @objc(PAYCardFormView)
public class CardFormView: UIView {
    @IBInspectable public var isHolderRequired: Bool = true {
        didSet {
//            holderContainer.isHidden = !isHolderRequired
        }
    }

    @IBOutlet private weak var cardNumberTitleLabel: UILabel!
    @IBOutlet private weak var expirationTitleLabel: UILabel!
    @IBOutlet private weak var cvcTitleLabel: UILabel!
    @IBOutlet private weak var cardHolderTitleLabel: UILabel!

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
    public weak var delegate: FormInputDelegate?

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

        getAcceptedBrands() { _ in }
    }

    override public var intrinsicContentSize: CGSize {
        return contentView.intrinsicContentSize
    }

    // MARK: - Out bound actions

    public var isValid: Bool {
        return viewModel.isValid()
    }

    public func createToken(tenantId: String? = nil, completion: (Result<String, Error>) -> Void) {
        // TODO: ask the view model
    }

    public func getAcceptedBrands(tenantId: String? = nil, completion: @escaping (Result<[CardBrand], Error>) -> Void) {
        viewModel.getAcceptedBrands(with: tenantId, completion: completion)
    }

    public func validateCardForm() -> Bool {
        updateCardNumberInput(input: cardNumberTextField.text, forceShowError: true)
        updateExpirationInput(input: expirationTextField.text, forceShowError: true)
        updateCvcInput(input: cvcTextField.text, forceShowError: true)
        updateCardHolderInput(input: cardHolderTextField.text, forceShowError: true)
        return isValid
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
        self.delegate?.inputValidated()

        return false
    }

    /// カード番号の入力フィールドを更新する
    ///
    /// - Parameters:
    ///   - input: カード番号
    ///   - forceShowError: エラー表示を強制するか
    private func updateCardNumberInput(input: String?, forceShowError: Bool = false) {
        let result = viewModel.updateCardNumber(input: input)
        switch result {
        case let .success(cardNumber):
            cardNumberTextField.text = cardNumber.formatted
            cardNumberErrorLabel.text = nil
            // TODO: show brand logo

        case let .failure(error):
            switch error {
            case let .cardNumberEmptyError(value, instant),
                 let .cardNumberInvalidError(value, instant),
                 let .cardNumberInvalidBrandError(value, instant):
                cardNumberTextField.text = value?.formatted
                cardNumberErrorLabel.text = forceShowError || instant ? error.localizedDescription : nil
            default:
                break
            }
        }
        cardNumberErrorLabel.isHidden = cardNumberTextField.text == nil
    }

    /// 有効期限の入力フィールドを更新する
    ///
    /// - Parameters:
    ///   - input: 有効期限
    ///   - forceShowError: エラー表示を強制するか
    private func updateExpirationInput(input: String?, forceShowError: Bool = false) {
        let result = viewModel.updateExpiration(input: input)
        switch result {
        case let .success(expiration):
            expirationTextField.text = expiration
            expirationErrorLabel.text = nil
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
        let result = viewModel.updateCvc(input: input)
        switch result {
        case let .success(cvc):
            cvcTextField.text = cvc
            cvcErrorLabel.text = nil
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
        let result = viewModel.updateCardHolder(input: input)
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
}
