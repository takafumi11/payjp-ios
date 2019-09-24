//
//  CardFormViewLabelStyle.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/09/19.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import UIKit

@objc(PAYCardFormViewLabelStyleDelegate)
public protocol CardFormViewLabelStyleDelegate: class {
    func isValidChanged(in cardFormView: CardFormViewLabelStyle)
}

@IBDesignable @objcMembers @objc(PAYCardFormViewLabelStyle)
public class CardFormViewLabelStyle: UIView {
    @IBInspectable public var isHolderRequired: Bool = true {
        didSet {
            holderContainer.isHidden = !isHolderRequired
            viewModel.update(isCardHolderEnabled: isHolderRequired)
            self.delegate?.isValidChanged(in: self)
        }
    }

    @IBOutlet weak var brandLogoImage: UIImageView!
    @IBOutlet weak var cvcIconImage: UIImageView!

    @IBOutlet weak var cardNumberFieldBackground: UIView!
    @IBOutlet weak var expirationFieldBackground: UIView!
    @IBOutlet weak var cvcFieldBackground: UIView!
    @IBOutlet weak var cardHolderFieldBackground: UIView!
    
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var expirationTextField: UITextField!
    @IBOutlet weak var cvcTextField: UITextField!
    @IBOutlet weak var cardHolderTextField: UITextField!

    @IBOutlet weak var cardNumberErrorLabel: UILabel!
    @IBOutlet weak var expirationErrorLabel: UILabel!
    @IBOutlet weak var cvcErrorLabel: UILabel!
    @IBOutlet weak var cardHolderErrorLabel: UILabel!

    @IBOutlet weak var holderContainer: UIStackView!

    @IBOutlet weak var ocrButton: UIButton!

    private var contentView: UIView!
    public weak var delegate: CardFormViewLabelStyleDelegate?

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
        let nib = UINib(nibName: "CardFormViewLabelStyle", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView

        if let view = view {
            contentView = view
            view.frame = bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(view)
        }

        backgroundColor = .clear
//        viewModel.registerIsCardIOAvailableChanges { [weak self] isAvailable in
//            guard let self = self else { return }
//            self.ocrButton.isHidden = !isAvailable
//        }
        
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

        getAcceptedBrands()
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

    public func getAcceptedBrands(tenantId: String? = nil, completion: CardBrandsResult? = nil) {
        viewModel.fetchAcceptedBrands(with: tenantId, completion: completion)
    }

    public func validateCardForm() -> Bool {
        updateCardNumberInput(input: cardNumberTextField.text, forceShowError: true)
        updateExpirationInput(input: expirationTextField.text, forceShowError: true)
        updateCvcInput(input: cvcTextField.text, forceShowError: true)
        updateCardHolderInput(input: cardHolderTextField.text, forceShowError: true)
        self.delegate?.isValidChanged(in: self)
        return isValid
    }

    @IBAction func onTapOcrButton(_ sender: Any) {
        viewModel.presentCardIOIfAvailable(from: self.parentViewController!)
    }
}

extension CardFormViewLabelStyle: UITextFieldDelegate {

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
    private func updateCardNumberInput(input: String?, forceShowError: Bool = false) {
        let result = viewModel.update(cardNumber: input)
        switch result {
        case let .success(cardNumber):
            cardNumberTextField.text = cardNumber.formatted
            cardNumberTextField.textColor = Style.Color.black
            cardNumberErrorLabel.text = nil
            updateBrandLogo(brand: cardNumber.brand)
            updateCvcIcon(brand: cardNumber.brand)
        case let .failure(error):
            switch error {
            case let .cardNumberEmptyError(value, instant),
                 let .cardNumberInvalidError(value, instant),
                 let .cardNumberInvalidBrandError(value, instant):
                cardNumberTextField.text = value?.formatted
                cardNumberTextField.textColor = forceShowError || instant ? Style.Color.red : Style.Color.black
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
    private func updateBrandLogo(brand: CardBrand?) {
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
    private func updateExpirationInput(input: String?, forceShowError: Bool = false) {
        let result = viewModel.update(expiration: input)
        switch result {
        case let .success(expiration):
            expirationTextField.text = expiration
            expirationTextField.textColor = Style.Color.black
            expirationErrorLabel.text = nil
        case let .failure(error):
            switch error {
            case let .expirationEmptyError(value, instant),
                 let .expirationInvalidError(value, instant):
                expirationTextField.text = value
                expirationTextField.textColor = forceShowError || instant ? Style.Color.red : Style.Color.black
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
            cvcTextField.textColor = Style.Color.black
            cvcErrorLabel.text = nil
        case let .failure(error):
            switch error {
            case let .cvcEmptyError(value, instant),
                 let .cvcInvalidError(value, instant):
                cvcTextField.text = value
                cvcTextField.textColor = forceShowError || instant ? Style.Color.red : Style.Color.black
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
    private func updateCvcIcon(brand: CardBrand?) {
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
    private func updateCardHolderInput(input: String?, forceShowError: Bool = false) {
        let result = viewModel.update(cardHolder: input)
        switch result {
        case let .success(holderName):
            cardHolderTextField.text = holderName
            cardHolderTextField.textColor = Style.Color.black
            cardHolderErrorLabel.text = nil
        case let .failure(error):
            switch error {
            case let .cardHolderEmptyError(value, instant):
                cardHolderTextField.text = value
                cardNumberTextField.textColor = forceShowError || instant ? Style.Color.red : Style.Color.black
                cardHolderErrorLabel.text = forceShowError || instant ? error.localizedDescription : nil
            default:
                break
            }
        }
        cardHolderErrorLabel.isHidden = cardHolderTextField.text == nil
    }
}

