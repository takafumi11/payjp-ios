//
//  CardDisplayFormView.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2020/03/13.
//

import Foundation

/// CardFormView with card animation.
@IBDesignable @objcMembers @objc(PAYCardFormDisplayStyledView)
public class CardDisplayFormView: UIView, CardFormView {

    // MARK: CardFormView

    var isHolderRequired: Bool = true

    @IBOutlet weak var brandLogoImage: UIImageView!
    @IBOutlet weak var cvcIconImage: UIImageView!
    @IBOutlet weak var holderContainer: UIStackView!
    @IBOutlet weak var ocrButton: UIButton!

    var cardNumberTextField: UITextField!
    var expirationTextField: UITextField!
    var cvcTextField: UITextField!
    var cardHolderTextField: UITextField!

    // 追加
    @IBOutlet weak var cardDisplayView: UIView!
    @IBOutlet weak var cardFrontView: UIStackView!
    @IBOutlet weak var cardBackView: UIView!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var cardNumberDisplayLabel: UILabel!
    @IBOutlet weak var cvcDisplayLabel: UITextField!
    @IBOutlet weak var cvc4DisplayLabel: UITextField!
    @IBOutlet weak var cardHolderDisplayLabel: UILabel!
    @IBOutlet weak var expirationDisplayLabel: UILabel!
    @IBOutlet weak var formScrollView: UIScrollView!
    @IBOutlet weak var cvc4BorderView: BorderView!
    @IBOutlet weak var cvcBorderView: BorderView!
    @IBOutlet weak var cardNumberBorderView: BorderView!
    @IBOutlet weak var cardHolderBorderView: BorderView!
    @IBOutlet weak var expirationBorderView: BorderView!

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

        setupFormLayout()

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

    // MARK: CardFormView

    func inputCardNumberSuccess(value: CardNumber) {
        updateCvc4LabelVisibility()
        cardNumberDisplayLabel.text = value.display
        errorMessageLabel.text = nil
    }

    func inputCardNumberFailure(value: CardNumber?, error: Error, forceShowError: Bool, instant: Bool) {
        updateCvc4LabelVisibility()
        if let value = value {
            cardNumberDisplayLabel.text = value.display
        } else {
            cardNumberDisplayLabel.text = "XXXX-XXXX-XXXX-XXXX"
        }
        errorMessageLabel.text = forceShowError || instant ? error.localizedDescription : nil
    }

    func inputCardNumberComplete() {
        errorMessageLabel.isHidden = cardNumberTextField.text == nil
    }

    func inputExpirationSuccess(value: String) {
        expirationDisplayLabel.text = value
        errorMessageLabel.text = nil
    }

    func inputExpirationFailure(value: String?, error: Error, forceShowError: Bool, instant: Bool) {
        if let value = value {
            expirationDisplayLabel.text = value
        } else {
            expirationDisplayLabel.text = "MM/YY"
        }
        errorMessageLabel.text = forceShowError || instant ? error.localizedDescription : nil
    }

    func inputExpirationComplete() {
        errorMessageLabel.isHidden = expirationTextField.text == nil
    }

    func inputCvcSuccess(value: String) {
        updateCvcDisplayLabel(cvc: value)
        errorMessageLabel.text = nil
    }

    func inputCvcFailure(value: String?, error: Error, forceShowError: Bool, instant: Bool) {
        updateCvcDisplayLabel(cvc: value)
        errorMessageLabel.text = forceShowError || instant ? error.localizedDescription : nil
    }

    func inputCvcComplete() {
        errorMessageLabel.isHidden = cvcTextField.text == nil
    }

    func inputCardHolderSuccess(value: String) {
        cardHolderDisplayLabel.text = value
        errorMessageLabel.text = nil
    }

    func inputCardHolderFailure(value: String?, error: Error, forceShowError: Bool, instant: Bool) {
        if let value = value {
            cardHolderDisplayLabel.text = value
        } else {
            cardHolderDisplayLabel.text = "NAME"
        }
        errorMessageLabel.text = forceShowError || instant ? error.localizedDescription : nil
    }

    func inputCardHolderComplete() {
        errorMessageLabel.isHidden = cardHolderTextField.text == nil
    }

    func updateBrandLogo(brand: CardBrand?) {
        guard let brandLogoImage = brandLogoImage else { return }
        guard let brand = brand else {
            brandLogoImage.image = nil
            cardDisplayView.backgroundColor = Style.Color.defaultBrand
            return
        }
        if brand == .unknown {
            brandLogoImage.image = nil
            cardDisplayView.backgroundColor = Style.Color.defaultBrand
            return
        }
        brandLogoImage.image = brand.logoResourceName.image
        cardDisplayView.backgroundColor = brand.cardBackgroundColor
    }

    // MARK: Private

    private func notifyIsValidChanged() {
        self.delegate?.formInputValidated(in: self, isValid: isValid)
    }

    private func setupFormLayout() {
        // 横スクロール可能なフォームの作成
        let formContentView = UIStackView()
        formContentView.spacing = 0.0
        formContentView.axis = .horizontal
        formContentView.alignment = .fill
        formContentView.distribution = .fillEqually
        formContentView.translatesAutoresizingMaskIntoConstraints = false
        formScrollView.addSubview(formContentView)

        NSLayoutConstraint.activate([
            formContentView.topAnchor.constraint(equalTo: formScrollView.topAnchor),
            formContentView.leadingAnchor.constraint(equalTo: formScrollView.leadingAnchor),
            formContentView.bottomAnchor.constraint(equalTo: formScrollView.bottomAnchor),
            formContentView.trailingAnchor.constraint(equalTo: formScrollView.trailingAnchor),
            formContentView.heightAnchor.constraint(equalTo: formScrollView.heightAnchor),
            // widthはscrollView.widthAnchor x ページ数
            formContentView.widthAnchor.constraint(equalTo: formScrollView.widthAnchor,
                                                   multiplier: CGFloat(4))
        ])

        let pageWidth = formScrollView.frame.width
        let textFieldWidth = pageWidth
        let textFieldHeight = CGFloat(60.0)

        cardNumberTextField = UITextField(frame: CGRect(x: 0.0,
                                                        y: 0.0,
                                                        width: textFieldWidth,
                                                        height: textFieldHeight))
        expirationTextField = UITextField(frame: CGRect(x: pageWidth ,
                                                        y: 0.0,
                                                        width: textFieldWidth,
                                                        height: textFieldHeight))
        cvcTextField = UITextField(frame: CGRect(x: pageWidth*2,
                                                 y: 0.0,
                                                 width: textFieldWidth,
                                                 height: textFieldHeight))
        cardHolderTextField = UITextField(frame: CGRect(x: pageWidth*3,
                                                        y: 0.0,
                                                        width: textFieldWidth,
                                                        height: textFieldHeight))

        cardNumberTextField.borderStyle = .roundedRect
        expirationTextField.borderStyle = .roundedRect
        cvcTextField.borderStyle = .roundedRect
        cardHolderTextField.borderStyle = .roundedRect

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

        formContentView.addArrangedSubview(cardNumberTextField)
        formContentView.addArrangedSubview(expirationTextField)
        formContentView.addArrangedSubview(cvcTextField)
        formContentView.addArrangedSubview(cardHolderTextField)
    }

    private func backFlipCard() {
        isCardDisplayFront = false
        cardFrontView.isHidden = true
        cardBackView.isHidden = false
        UIView.transition(with: cardDisplayView,
                          duration: 0.4,
                          options: .transitionFlipFromLeft,
                          animations: nil,
                          completion: nil)
    }

    private func frontFlipCard() {
        isCardDisplayFront = true
        cardFrontView.isHidden = false
        cardBackView.isHidden = true
        UIView.transition(with: cardDisplayView,
                          duration: 0.4,
                          options: .transitionFlipFromRight,
                          animations: nil,
                          completion: nil)
    }

    private func updateCvc4LabelVisibility() {
        switch currentCardBrand {
        case .americanExpress:
            cvc4BorderView.isHidden = false
        default:
            cvc4BorderView.isHidden = true
        }
    }

    private func updateCvcDisplayLabel(cvc: String?) {
        switch currentCardBrand {
        case .americanExpress:
            cvc4DisplayLabel.text = cvc
        default:
            cvcDisplayLabel.text = cvc
        }
    }

    private func updateDisplayLabelHighlight(textField: UITextField) {
        switch textField {
        case cardNumberTextField:
            cardNumberBorderView.highlightOn()
            expirationBorderView.highlightOff()
            cvcBorderView.highlightOff()
            cvc4BorderView.highlightOff()
            cardHolderBorderView.highlightOff()
        case expirationTextField:
            cardNumberBorderView.highlightOff()
            expirationBorderView.highlightOn()
            cvcBorderView.highlightOff()
            cvc4BorderView.highlightOff()
            cardHolderBorderView.highlightOff()
        case cvcTextField:
            if currentCardBrand == .americanExpress {
                cvcBorderView.highlightOff()
                cvc4BorderView.highlightOn()
            } else {
                cvcBorderView.highlightOn()
                cvc4BorderView.highlightOff()
            }
            cardNumberBorderView.highlightOff()
            expirationBorderView.highlightOff()
            cardHolderBorderView.highlightOff()
        case cardHolderTextField:
            cardNumberBorderView.highlightOff()
            expirationBorderView.highlightOff()
            cvcBorderView.highlightOff()
            cvc4BorderView.highlightOff()
            cardHolderBorderView.highlightOn()
        default:
            break
        }
    }
}

// MARK: CardFormAction
extension CardDisplayFormView: CardFormAction {

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

    public func setupInputAccessoryView(view: UIView) {
        cardNumberTextField.inputAccessoryView = view
        expirationTextField.inputAccessoryView = view
        cvcTextField.inputAccessoryView = view
        cardHolderTextField.inputAccessoryView = view
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
        updateDisplayLabelHighlight(textField: textField)
        if textField == cvcTextField && currentCardBrand != .americanExpress {
            // backFlip
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                guard let self = self else { return }
                self.backFlipCard()
            }
        } else {
            // frontFlip
            if !isCardDisplayFront {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                    guard let self = self else { return }
                    self.frontFlipCard()
                }
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
