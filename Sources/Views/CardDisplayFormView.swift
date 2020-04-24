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
    var cvcIconImage: UIImageView!

    var cardNumberTextField: UITextField!
    var expirationTextField: UITextField!
    var cvcTextField: UITextField!
    var cardHolderTextField: UITextField!
    var ocrButton: UIButton!

    var cardNumberErrorLabel: UILabel!
    var expirationErrorLabel: UILabel!
    var cvcErrorLabel: UILabel!
    var cardHolderErrorLabel: UILabel!

    var inputTextColor: UIColor = Style.Color.label
    var inputTintColor: UIColor = Style.Color.blue
    let inputTextErrorColorEnabled: Bool = true
    var viewModel: CardFormViewViewModelType = CardFormViewViewModel()

    @IBOutlet weak var cardDisplayView: UIView!
    @IBOutlet weak var cardFrontView: UIStackView!
    @IBOutlet weak var cardBackView: UIView!

    @IBOutlet weak var cardNumberDisplayLabel: UILabel!
    @IBOutlet weak var cvcDisplayLabel: UILabel!
    @IBOutlet weak var cvc4DisplayLabel: UILabel!
    @IBOutlet weak var cardHolderDisplayLabel: UILabel!
    @IBOutlet weak var expirationDisplayLabel: UILabel!

    @IBOutlet weak var formScrollView: UIScrollView!
    @IBOutlet weak var cvc4BorderView: BorderView!
    @IBOutlet weak var cvcBorderView: BorderView!
    @IBOutlet weak var cardNumberBorderView: BorderView!
    @IBOutlet weak var cardHolderBorderView: BorderView!
    @IBOutlet weak var expirationBorderView: BorderView!

    private var cardNumberFieldBackground: UIView!
    private var expirationFieldBackground: UIView!
    private var cvcFieldBackground: UIView!
    private var cardHolderFieldBackground: UIView!

    private var cardNumberFieldContentView: UIStackView!
    private var expirationFieldContentView: UIStackView!
    private var cvcFieldContentView: UIStackView!
    private var cardHolderFieldContentView: UIStackView!

    private let inputFieldMargin: CGFloat = 16.0
    private var contentPositionX: CGFloat = 0.0
    private var isScrolling: Bool = false
    private let formContentStackView: UIStackView = UIStackView()

    /// Camera scan action
    ///
    /// - Parameter sender: sender
    @objc private func onTapOcrButton(_ sender: Any) {
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

        cardNumberDisplayLabel.adjustsFontSizeToFitWidth = true

        setupViews()
        setupInputFields()
        setupScrollableForm()
        apply(style: .defaultStyle)

        viewModel.delegate = self
        formScrollView.delegate = self
    }

    override public var intrinsicContentSize: CGSize {
        return contentView.intrinsicContentSize
    }

    // MARK: CardFormView

    func inputCardNumberSuccess(value: CardNumber) {
        updateCvc4LabelVisibility()
        updateCardNumber(value: value)
        cardNumberErrorLabel.text = nil
    }

    func inputCardNumberFailure(value: CardNumber?, error: Error, forceShowError: Bool, instant: Bool) {
        updateCvc4LabelVisibility()
        if let value = value {
            updateCardNumber(value: value)
        } else {
            cardNumberDisplayLabel.text = "payjp_card_display_form_number_default".localized
        }
        cardNumberErrorLabel.text = forceShowError || instant ? error.localizedDescription : nil
    }

    func inputExpirationSuccess(value: Expiration) {
        updateExpiration(value: value)
        expirationErrorLabel.text = nil
    }

    func inputExpirationFailure(value: Expiration?, error: Error, forceShowError: Bool, instant: Bool) {
        if let value = value {
            updateExpiration(value: value)
        } else {
            expirationDisplayLabel.text = "payjp_card_display_form_expiration_default".localized
        }
        expirationErrorLabel.text = forceShowError || instant ? error.localizedDescription : nil
    }

    func inputCvcSuccess(value: String) {
        updateCvcDisplayLabel(cvc: value)
        cvcErrorLabel.text = nil
    }

    func inputCvcFailure(value: String?, error: Error, forceShowError: Bool, instant: Bool) {
        updateCvcDisplayLabel(cvc: value)
        cvcErrorLabel.text = forceShowError || instant ? error.localizedDescription : nil
    }

    func inputCardHolderSuccess(value: String) {
        updateCardHolder(value: value)
        cardHolderErrorLabel.text = nil
    }

    func inputCardHolderFailure(value: String?, error: Error, forceShowError: Bool, instant: Bool) {
        if let value = value {
            updateCardHolder(value: value)
        } else {
            cardHolderDisplayLabel.text = "payjp_card_display_form_holder_name_default".localized
        }
        cardHolderErrorLabel.text = forceShowError || instant ? error.localizedDescription : nil
    }

    func updateBrandLogo(brand: CardBrand?) {
        guard let brandLogoImage = brandLogoImage else { return }
        brandLogoImage.image = brand?.displayLogoResourceName?.image
    }

    func focusNextInputField(currentField: UITextField) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self = self else { return }
            self.focusNext(currentField: currentField)
        }
    }

    func updateCardNumber(value: CardNumber?) {
        cardNumberTextField.text = value?.spaceFormatted
    }

    // MARK: Private

    private func notifyIsValidChanged() {
        self.delegate?.formInputValidated(in: self, isValid: isValid)
    }

    /// 各Viewのセットアップ
    private func setupViews() {
        cardNumberFieldBackground = UIView()
        expirationFieldBackground = UIView()
        cvcFieldBackground = UIView()
        cardHolderFieldBackground = UIView()

        cardNumberErrorLabel = UILabel()
        expirationErrorLabel = UILabel()
        cvcErrorLabel = UILabel()
        cardHolderErrorLabel = UILabel()

        ocrButton = UIButton()
        ocrButton.addTarget(self,
                            action: #selector(onTapOcrButton(_:)),
                            for: UIControl.Event.touchUpInside)
        ocrButton.setImage("icon_camera".image, for: .normal)
        ocrButton.imageView?.contentMode = .scaleAspectFit
        ocrButton.contentHorizontalAlignment = .fill
        ocrButton.contentVerticalAlignment = .fill

        cardIOProxy = CardIOProxy(delegate: self)
        ocrButton.isHidden = !CardIOProxy.isCardIOAvailable()

        cardNumberDisplayLabel.textColor = Style.Color.placeholderText
        expirationDisplayLabel.textColor = Style.Color.placeholderText
        cvcDisplayLabel.textColor = Style.Color.placeholderText
        cvc4DisplayLabel.textColor = Style.Color.placeholderText
        cardHolderDisplayLabel.textColor = Style.Color.placeholderText
    }

    private func setupInputFields() {
        cardNumberTextField = UITextField()
        expirationTextField = UITextField()
        cvcTextField = UITextField()
        cardHolderTextField = UITextField()

        cardNumberTextField.borderStyle = .none
        expirationTextField.borderStyle = .none
        cvcTextField.borderStyle = .none
        cardHolderTextField.borderStyle = .none

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

    /// 横スクロール可能なフォームの作成
    /// ScrollViewとStackViewの組み合わせで実装
    private func setupScrollableForm() {
        // 横ScrollViewにaddするStackView
        formContentStackView.spacing = 0.0
        formContentStackView.axis = .horizontal
        formContentStackView.alignment = .fill
        formContentStackView.distribution = .fillEqually
        formContentStackView.translatesAutoresizingMaskIntoConstraints = false
        formScrollView.addSubview(formContentStackView)

        NSLayoutConstraint.activate([
            formContentStackView.topAnchor.constraint(equalTo: formScrollView.topAnchor),
            formContentStackView.leadingAnchor.constraint(equalTo: formScrollView.leadingAnchor),
            formContentStackView.bottomAnchor.constraint(equalTo: formScrollView.bottomAnchor),
            formContentStackView.trailingAnchor.constraint(equalTo: formScrollView.trailingAnchor),
            formContentStackView.heightAnchor.constraint(equalTo: formScrollView.heightAnchor),
            // widthはscrollView.widthAnchor x ページ数
            formContentStackView.widthAnchor.constraint(equalTo: formScrollView.widthAnchor,
                                                        multiplier: CGFloat(4))
        ])

        // 各入力フィールド
        cardNumberFieldContentView = setupInputContentView(backgroundView: cardNumberFieldBackground,
                                                           textField: cardNumberTextField,
                                                           errorLabel: cardNumberErrorLabel,
                                                           actionButton: ocrButton,
                                                           spacing: 8.0)
        expirationFieldContentView = setupInputContentView(backgroundView: expirationFieldBackground,
                                                           textField: expirationTextField,
                                                           errorLabel: expirationErrorLabel)
        cvcFieldContentView = setupInputContentView(backgroundView: cvcFieldBackground,
                                                    textField: cvcTextField,
                                                    errorLabel: cvcErrorLabel)
        cardHolderFieldContentView = setupInputContentView(backgroundView: cardHolderFieldBackground,
                                                           textField: cardHolderTextField,
                                                           errorLabel: cardHolderErrorLabel)

        formContentStackView.addArrangedSubview(cardNumberFieldContentView)
        formContentStackView.addArrangedSubview(expirationFieldContentView)
        formContentStackView.addArrangedSubview(cvcFieldContentView)
        formContentStackView.addArrangedSubview(cardHolderFieldContentView)
    }

    private func setupInputContentView(backgroundView: UIView,
                                       textField: UITextField,
                                       errorLabel: UILabel,
                                       actionButton: UIButton? = nil,
                                       spacing: CGFloat = 0.0) -> UIStackView {

        let inputStackView = UIStackView()
        inputStackView.spacing = spacing
        inputStackView.axis = .horizontal
        inputStackView.alignment = .fill
        inputStackView.distribution = .fill
        inputStackView.translatesAutoresizingMaskIntoConstraints = false
        inputStackView.addArrangedSubview(textField)

        backgroundView.roundingCorners(corners: .allCorners, radius: 4.0)
        backgroundView.backgroundColor = FormStyle.defaultStyle.inputFieldBackgroundColor
        backgroundView.addSubview(inputStackView)

        NSLayoutConstraint.activate([
            inputStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor,
                                                    constant: inputFieldMargin),
            inputStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor,
                                                     constant: -inputFieldMargin),
            inputStackView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            textField.heightAnchor.constraint(equalToConstant: 30.0)
        ])

        if let button = actionButton {
            inputStackView.addArrangedSubview(button)
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: 24.0)
            ])
        }

        let contentStackView = UIStackView()
        contentStackView.spacing = 4.0
        contentStackView.axis = .vertical
        contentStackView.alignment = .fill
        contentStackView.distribution = .fill
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.addArrangedSubview(backgroundView)
        contentStackView.addArrangedSubview(errorLabel)

        NSLayoutConstraint.activate([
            errorLabel.heightAnchor.constraint(equalToConstant: 24.0),
            contentStackView.heightAnchor.constraint(equalToConstant: 72.0)
        ])

        return contentStackView
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

    private func updateCardNumber(value: CardNumber) {
        let range = (value.display as NSString).range(of: value.spaceFormatted)
        let attributed = NSMutableAttributedString.init(string: value.display)
        attributed.addAttribute(.foregroundColor,
                                value: UIColor.white,
                                range: range)
        cardNumberDisplayLabel.attributedText = attributed
    }

    private func updateExpiration(value: Expiration) {
        let range = (value.display as NSString).range(of: value.formatted)
        let attributed = NSMutableAttributedString.init(string: value.display)
        attributed.addAttribute(.foregroundColor,
                                value: UIColor.white,
                                range: range)
        expirationDisplayLabel.attributedText = attributed
    }

    private func updateCvcDisplayLabel(cvc: String?) {
        if let cvc = cvc {
            let mask = String(repeating: "•", count: cvc.count)
            let range = (mask as NSString).range(of: mask)
            let attributed = NSMutableAttributedString.init(string: mask)
            switch currentCardBrand {
            case .americanExpress:
                attributed.addAttribute(.foregroundColor,
                                        value: UIColor.white,
                                        range: range)
                cvc4DisplayLabel.attributedText = attributed
            default:
                attributed.addAttribute(.foregroundColor,
                                        value: Style.Color.label,
                                        range: range)
                cvcDisplayLabel.attributedText = attributed
            }
        } else {
            cvc4DisplayLabel.text = "payjp_card_display_form_cvc4_default".localized
            cvcDisplayLabel.text = "payjp_card_display_form_cvc_default".localized
        }
    }

    private func updateCardHolder(value: String) {
        let range = (value as NSString).range(of: value)
        let attributed = NSMutableAttributedString.init(string: value)
        attributed.addAttribute(.foregroundColor,
                                value: UIColor.white,
                                range: range)
        cardHolderDisplayLabel.attributedText = attributed
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

    private func focusNext(currentField: UITextField) {
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

// MARK: UIScrollViewDelegate
extension CardDisplayFormView: UIScrollViewDelegate {

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 各入力Viewに設定しているマージン分だけスクロール位置がずれるため調整する
        let diff = contentPositionX - scrollView.contentOffset.x
        if !isScrolling &&
            (diff == inputFieldMargin || diff == -inputFieldMargin) {
            formScrollView.setContentOffset(CGPoint(x: contentPositionX, y: 0), animated: false)
        }
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isScrolling = true
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isScrolling = false
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
        let inputFieldBackgroundColor = style.inputFieldBackgroundColor
        self.inputTextColor = inputTextColor
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
        // input field background
        cardNumberFieldBackground.backgroundColor = inputFieldBackgroundColor
        expirationFieldBackground.backgroundColor = inputFieldBackgroundColor
        cvcFieldBackground.backgroundColor = inputFieldBackgroundColor
        cardHolderFieldBackground.backgroundColor = inputFieldBackgroundColor
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
            backFlipCard()
        } else {
            if !isCardDisplayFront {
                frontFlipCard()
            }
        }

        // スクロール位置調整のため、各入力Viewのpositionを保持する
        switch textField {
        case cardNumberTextField:
            contentPositionX = cardNumberFieldContentView.frame.origin.x
        case expirationTextField:
            contentPositionX = expirationFieldContentView.frame.origin.x
        case cvcTextField:
            contentPositionX = cvcFieldContentView.frame.origin.x
        case cardHolderTextField:
            contentPositionX = cardHolderFieldContentView.frame.origin.x
        default:
            break
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
