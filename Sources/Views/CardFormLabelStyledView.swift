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
public class CardFormLabelStyledView: UIView, CardFormView {
    
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
    
    public var baseBrandLogoImage: UIImageView {
        return brandLogoImage
    }
    public var baseCvcIconImage: UIImageView {
        return cvcIconImage
    }
    public var baseHolderContainer: UIStackView {
        return holderContainer
    }
    public var baseOcrButton: UIButton {
        return ocrButton
    }
    public var baseCardNumberTextField: UITextField {
        return cardNumberTextField
    }
    public var baseExpirationTextField: UITextField {
        return expirationTextField
    }
    public var baseCvcTextField: UITextField {
        return cvcTextField
    }
    public var baseCardHolderTextField: UITextField {
        return cardHolderTextField
    }
    public var baseCardNumberErrorLabel: UILabel {
        return cardNumberErrorLabel
    }
    public var baseExpirationErrorLabel: UILabel {
        return expirationErrorLabel
    }
    public var baseCvcErrorLabel: UILabel {
        return cvcErrorLabel
    }
    public var baseCardHolderErrorLabel: UILabel {
        return cardHolderErrorLabel
    }
    public var baseInputTextColor: UIColor {
        return inputTextColor
    }
    
    public func isValidChanged() {
        self.delegate?.isValidChanged(in: self)
    }

    // MARK:
    
    public weak var delegate: CardFormLabelStyledViewDelegate?
    private var contentView: UIView!
    private var cardIOProxy: CardIOProxy!
    private let expirationFormatter: ExpirationFormatterType = ExpirationFormatter()
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

    public func apply(style: FormStyle) {
        let labelTextColor = UIColor(hex: style.labelTextColor ?? Style.Color.black.hexString)
        let inputTextColor = UIColor(hex: style.inputTextColor)
        let tintColor = UIColor(hex: style.tintColor)
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
