//
//  CardFormTableStyledView.swift
//  PAYJP
//
//  Created by Li-Hsuan Chen on 2019/07/17.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import UIKit

/// CardFormView without label.
/// It's suitable for UITableView design.
@IBDesignable @objcMembers @objc(PAYCardFormTableStyledView)
public class CardFormTableStyledView: CardFormView {

    // MARK: CardFormView

    /// Card holder input field enabled.
    @IBInspectable override public var isHolderRequired: Bool {
        didSet {
            holderContainer.isHidden = !isHolderRequired
            holderSeparator.isHidden = !isHolderRequired
            viewModel.update(isCardHolderEnabled: isHolderRequired)
            notifyIsValidChanged()
        }
    }

    @IBOutlet private weak var _brandLogoImage: UIImageView!
    override weak var brandLogoImage: UIImageView! {
        get { return _brandLogoImage } set { }
    }
    @IBOutlet private weak var _cvcIconImage: UIImageView!
    override weak var cvcIconImage: UIImageView! {
        get { return _cvcIconImage } set { }
    }
    @IBOutlet private weak var holderContainer: UIStackView!
    @IBOutlet private weak var _ocrButton: UIButton!
    override weak var ocrButton: UIButton! {
        get { return _ocrButton } set { }
    }

    @IBOutlet private weak var _cardNumberTextField: UITextField!
    override weak var cardNumberTextField: UITextField! {
        get { return _cardNumberTextField } set { }
    }
    @IBOutlet private weak var _expirationTextField: UITextField!
    override weak var expirationTextField: UITextField! {
        get { return _expirationTextField } set { }
    }
    @IBOutlet private weak var _cvcTextField: UITextField!
    override weak var cvcTextField: UITextField! {
        get { return _cvcTextField } set { }
    }
    @IBOutlet private weak var _cardHolderTextField: UITextField!
    override weak var cardHolderTextField: UITextField! {
        get { return _cardHolderTextField } set { }
    }

    @IBOutlet private weak var _cardNumberErrorLabel: UILabel!
    override weak var cardNumberErrorLabel: UILabel! {
        get { return _cardNumberErrorLabel } set { }
    }
    @IBOutlet private weak var _expirationErrorLabel: UILabel!
    override weak var expirationErrorLabel: UILabel! {
        get { return _expirationErrorLabel } set { }
    }
    @IBOutlet private weak var _cvcErrorLabel: UILabel!
    override weak var cvcErrorLabel: UILabel! {
        get { return _cvcErrorLabel } set { }
    }
    @IBOutlet private weak var _cardHolderErrorLabel: UILabel!
    override weak var cardHolderErrorLabel: UILabel! {
        get { return _cardHolderErrorLabel } set { }
    }

    @IBOutlet private weak var expirationSeparator: UIView!
    @IBOutlet private weak var cvcSeparator: UIView!
    @IBOutlet private weak var holderSeparator: UIView!

    @IBOutlet private weak var expirationSeparatorConstraint: NSLayoutConstraint!
    @IBOutlet private weak var cvcSeparatorConstraint: NSLayoutConstraint!
    @IBOutlet private weak var holderSeparatorConstraint: NSLayoutConstraint!

    override var inputTintColor: UIColor {
        get { return Style.Color.blue } set { }
    }

    /// Camera scan action
    ///
    /// - Parameter sender: sender
    @IBAction func onTapOcrButton(_ sender: Any) {
        viewModel.requestOcr()
    }

    private var contentView: UIView!

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
        let nib = UINib(nibName: "CardFormTableStyledView", bundle: .payjpBundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView

        if let view = view {
            contentView = view
            view.frame = bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(view)
        }

        backgroundColor = Style.Color.groupedBackground

        setupInputFields()

        // set images
        brandLogoImage.image = "icon_card".image
        cvcIconImage.image = "icon_card_cvc_3".image

        ocrButton.setImage("icon_camera".image, for: .normal)
        ocrButton.imageView?.contentMode = .scaleAspectFit
        ocrButton.contentHorizontalAlignment = .fill
        ocrButton.contentVerticalAlignment = .fill

        ocrButton.isHidden = !CardIOProxy.isCardIOAvailable()

        // separatorのheightを 0.5 で指定すると太さが統一ではなくなってしまうためscaleを使って対応
        // cf. https://stackoverflow.com/a/21553495
        let height = 1.0 / UIScreen.main.scale
        expirationSeparatorConstraint.constant = height
        cvcSeparatorConstraint.constant = height
        holderSeparatorConstraint.constant = height

        expirationSeparator.backgroundColor = Style.Color.separator
        cvcSeparator.backgroundColor = Style.Color.separator
        holderSeparator.backgroundColor = Style.Color.separator

        apply(style: .defaultStyle)

        viewModel.delegate = self
    }

    override public var intrinsicContentSize: CGSize {
        return contentView.intrinsicContentSize
    }

    // MARK: Private

    private func setupInputFields() {
        // placeholder
        cardNumberTextField.attributedPlaceholder = NSAttributedString(
            string: "payjp_card_form_number_placeholder".localized,
            attributes: [NSAttributedString.Key.foregroundColor: Style.Color.placeholderText])
        expirationTextField.attributedPlaceholder = NSAttributedString(
            string: "payjp_card_form_expiration_placeholder".localized,
            attributes: [NSAttributedString.Key.foregroundColor: Style.Color.placeholderText])
        cvcTextField.attributedPlaceholder = NSAttributedString(
            string: "payjp_card_form_cvc_placeholder".localized,
            attributes: [NSAttributedString.Key.foregroundColor: Style.Color.placeholderText])
        cardHolderTextField.attributedPlaceholder = NSAttributedString(
            string: "payjp_card_form_holder_name_placeholder".localized,
            attributes: [NSAttributedString.Key.foregroundColor: Style.Color.placeholderText])

        cardNumberTextField.delegate = self
        expirationTextField.delegate = self
        cvcTextField.delegate = self
        cardHolderTextField.delegate = self
    }
}

extension CardFormTableStyledView: CardFormViewProtocol {

    public func apply(style: FormStyle) {
        let inputTextColor = style.inputTextColor
        let errorTextColor = style.errorTextColor
        let tintColor = style.tintColor
        self.inputTintColor = tintColor

        // input text
        cardNumberTextField.textColor = inputTextColor
        expirationTextField.textColor = inputTextColor
        cvcTextField.textColor = inputTextColor
        cardHolderTextField.textColor = inputTextColor
        // error text
        cardNumberErrorLabel.textColor = errorTextColor
        expirationErrorLabel.textColor = errorTextColor
        cvcErrorLabel.textColor = errorTextColor
        cardHolderErrorLabel.textColor = errorTextColor
        // tint
        cardNumberTextField.tintColor = tintColor
        expirationTextField.tintColor = tintColor
        cvcTextField.tintColor = tintColor
        cardHolderTextField.tintColor = tintColor
    }
}
