//
//  CardFormView.swift
//  PAYJP
//
//  Created by Li-Hsuan Chen on 2019/07/17.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import UIKit

@IBDesignable @objcMembers @objc(PAYCardFormView)
public class CardFormView: UIView {
    @IBInspectable public var isHolderRequired: Bool = true {
        didSet {
            holderContainer.isHidden = !isHolderRequired
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

        cardNumberTextField.delegate = self
        expirationTextField.delegate = self
    }

    override public var intrinsicContentSize: CGSize {
        return contentView.intrinsicContentSize
    }

    // MARK: - Out bound actions

    public var isValid: Bool {
        // TODO: ask the view model
        return false
    }

    public func createToken(tenantId: String? = nil, completion: (Result<String, Error>) -> Void) {
        // TODO: ask the view model
    }
}

extension CardFormView: UITextFieldDelegate {

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if let currentText = textField.text {
            if (range.location == 0 && string.isEmpty) { return true }

            let range = Range(range, in: currentText)!
            let newText = currentText.replacingCharacters(in: range, with: string)

            switch textField {
            case cardNumberTextField:
                updateCardNumberInput(input: newText)
            case expirationTextField:
                updateExpirationInput(input: newText)
            default:
                break
            }
        }

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
            case let .error(value, message):
                cardNumberTextField.text = value?.formatted
                cardNumberErrorLabel.text = forceShowError ? message : nil
            case let .instantError(value, message):
                cardNumberTextField.text = value?.formatted
                cardNumberErrorLabel.text = message
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
            case let .error(value, message):
                expirationTextField.text = value
                expirationErrorLabel.text = forceShowError ? message : nil
            case let .instantError(value, message):
                expirationTextField.text = value
                expirationErrorLabel.text = message
            }
        }
        expirationErrorLabel.isHidden = expirationTextField.text == nil
    }
}
