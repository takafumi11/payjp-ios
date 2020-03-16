//
//  CardDisplayFormView.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2020/03/13.
//

import Foundation

/// CardFormView with card animation.
@IBDesignable @objcMembers @objc(PAYCardFormDisplayStyledView)
public class CardDisplayFormView: UIView, CardFormAction, CardFormView {

    // MARK: CardFormView

    /// Card holder input field enabled.
    @IBInspectable public var isHolderRequired: Bool = true {
        didSet {
            //            holderContainer.isHidden = !isHolderRequired
            viewModel.update(isCardHolderEnabled: isHolderRequired)
            notifyIsValidChanged()
        }
    }

    @IBOutlet weak var brandLogoImage: UIImageView!
    @IBOutlet weak var cvcIconImage: UIImageView!
    @IBOutlet weak var holderContainer: UIStackView!
    @IBOutlet weak var ocrButton: UIButton!

    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var expirationTextField: UITextField!
    @IBOutlet weak var cvcTextField: UITextField!
    @IBOutlet weak var cardHolderTextField: UITextField!

    var cardNumberErrorLabel: UILabel!
    var expirationErrorLabel: UILabel!
    var cvcErrorLabel: UILabel!
    var cardHolderErrorLabel: UILabel!

    // 追加
    @IBOutlet weak var cardDisplayView: UIView!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var cardNumberDisplayLabel: UILabel!
    @IBOutlet weak var cvcDisplayLabel: UILabel!
    @IBOutlet weak var cardHolderDisplayLabel: UILabel!
    @IBOutlet weak var expirationDisplayLabel: UILabel!

    var inputTintColor: UIColor = Style.Color.blue
    var viewModel: CardFormViewViewModelType = CardFormViewViewModel()

    /// Camera scan action
    ///
    /// - Parameter sender: sender
    @IBAction func onTapOcrButton(_ sender: Any) {
        viewModel.requestOcr()
    }

    // MARK: CardFormViewDelegate

    /// CardFormView delegate.
    public weak var delegate: CardFormViewDelegate?

    private var cardIOProxy: CardIOProxy!
    private var contentView: UIView!
    private let expirationFormatter: ExpirationFormatterType = ExpirationFormatter()
    private let nsErrorConverter: NSErrorConverterType = NSErrorConverter()
    private var isCardDisplayFront = true

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
        let nib = UINib(nibName: "CardDisplayFormView", bundle: .payjpBundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView

        if let view = view {
            contentView = view
            view.frame = bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(view)
        }

        backgroundColor = .clear

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

        // set images
        //        brandLogoImage.image = "icon_card".image
        //        cvcIconImage.image = "icon_card_cvc_3".image

        //        ocrButton.setImage("icon_camera".image, for: .normal)
        //        ocrButton.imageView?.contentMode = .scaleAspectFit
        //        ocrButton.contentHorizontalAlignment = .fill
        //        ocrButton.contentVerticalAlignment = .fill

        cardIOProxy = CardIOProxy(delegate: self)
        //        ocrButton.isHidden = !CardIOProxy.isCardIOAvailable()

        apply(style: .defaultStyle)

        viewModel.delegate = self
    }

    override public var intrinsicContentSize: CGSize {
        return contentView.intrinsicContentSize
    }

    // MARK: CardFormAction

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
        errorMessageLabel.textColor = errorTextColor
        // tint
        cardNumberTextField.tintColor = tintColor
        expirationTextField.tintColor = tintColor
        cvcTextField.tintColor = tintColor
        cardHolderTextField.tintColor = tintColor
    }

    private func notifyIsValidChanged() {
        self.delegate?.formInputValidated(in: self, isValid: isValid)
    }

    public func setupInputAccessoryView(view: UIView) {
        cardNumberTextField.inputAccessoryView = view
        expirationTextField.inputAccessoryView = view
        cvcTextField.inputAccessoryView = view
        cardHolderTextField.inputAccessoryView = view
    }

    private func backFlipCard() {
        isCardDisplayFront = false
        cardDisplayView.backgroundColor = .systemRed
        cardNumberDisplayLabel.isHidden = true
        expirationDisplayLabel.isHidden = true
        cvcDisplayLabel.isHidden = false
        cardHolderDisplayLabel.isHidden = true
        UIView.transition(with: cardDisplayView,
                          duration: 0.8,
                          options: .transitionFlipFromLeft,
                          animations: nil,
                          completion: nil)
    }

    private func frontFlipCard() {
        isCardDisplayFront = true
        cardDisplayView.backgroundColor = .systemBlue
        cardNumberDisplayLabel.isHidden = false
        expirationDisplayLabel.isHidden = false
        cvcDisplayLabel.isHidden = true
        cardHolderDisplayLabel.isHidden = false
        UIView.transition(with: cardDisplayView,
                          duration: 0.8,
                          options: .transitionFlipFromRight,
                          animations: nil,
                          completion: nil)
    }
}

// MARK: UITextFieldDelegate
extension CardDisplayFormView: UITextFieldDelegate {

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
        if textField == cvcTextField {
            // backFlip
            backFlipCard()
        } else {
            // frontFlip
            if !isCardDisplayFront {
                frontFlipCard()
            }
        }
    }
}

// MARK: CardIOProxyDelegate
extension CardDisplayFormView: CardIOProxyDelegate {
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

extension CardDisplayFormView: CardFormViewModelDelegate {

    func startScanner() {
        if let viewController = parentViewController, CardIOProxy.canReadCardWithCamera() {
            cardIOProxy.presentCardIO(from: viewController)
        }
    }

    func showPermissionAlert() {
        showCameraPermissionAlert()
    }
}
