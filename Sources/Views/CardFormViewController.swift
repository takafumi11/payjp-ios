//
//  CardFormViewController.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/11/15.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

/// CardFormViewController.
/// It's configured with CardFormLabelStyledView.
@objcMembers @objc(PAYCardFormViewController)
public class CardFormViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cardFormView: CardFormLabelStyledView!
    @IBOutlet weak var saveButton: ActionButton!
    @IBOutlet weak var brandsView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorView: ErrorView!

    private var formStyle: FormStyle?
    private var tenantId: String?
    private var accptedBrands: [CardBrand]?
    private var accessorySubmitButton: ActionButton!

    private var presenter: CardFormScreenPresenterType?
    private let errorTranslator = ErrorTranslator.shared

    /// CardFormViewController delegate.
    public weak var delegate: CardFormViewControllerDelegate?

    /// CardFormViewController factory method.
    ///
    /// - Parameters:
    ///   - style: formStyle
    ///   - tenantId: identifier of tenant
    ///   - displayType: display type
    /// - Returns: CardFormViewController
    @objc(createCardFormViewControllerWithStyle: tenantId:)
    public static func createCardFormViewController(style: FormStyle? = nil,
                                                    tenantId: String? = nil) -> CardFormViewController {
        let stotyboard = UIStoryboard(name: "CardForm", bundle: Bundle(for: PAYJPSDK.self))
        let naviVc = stotyboard.instantiateInitialViewController() as? UINavigationController
        guard
            let cardFormVc = naviVc?.topViewController as? CardFormViewController
            else { fatalError("Couldn't instantiate CardFormViewController") }
        cardFormVc.formStyle = style
        cardFormVc.tenantId = tenantId
        return cardFormVc
    }

    @IBAction func registerCardTapped(_ sender: Any) {
        createToken()
    }

    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.didCompleteCardForm(with: .cancel)
        }
    }

    // MARK: Lifecycle

    public override func viewDidLoad() {
        presenter = CardFormScreenPresenter(delegate: self)
        // キーボード上部にカード登録ボタンを表示
        let frame = CGRect.init(x: 0,
                                y: 0,
                                width: (UIScreen.main.bounds.size.width),
                                height: 44)
        let view = UIView(frame: frame)
        accessorySubmitButton = ActionButton(frame: frame)
        accessorySubmitButton.setTitle("payjp_card_form_screen_submit_button".localized, for: .normal)
        accessorySubmitButton.addTarget(self, action: #selector(submitTapped(sender:)), for: .touchUpInside)
        accessorySubmitButton.isEnabled = false
        accessorySubmitButton.cornerRadius = Style.Radius.none
        view.addSubview(accessorySubmitButton)
        cardFormView.setupInputAccessoryView(view: view)

        cardFormView.delegate = self
        brandsView.delegate = self
        brandsView.dataSource = self
        errorView.delegate = self

        // pushの場合、Cancelボタンを非表示にする
        if self.presentingViewController == nil {
            navigationItem.leftBarButtonItem = nil
        }

        saveButton.setTitle("payjp_card_form_screen_submit_button".localized, for: .normal)

        let bundle = Bundle(for: BrandImageCell.self)
        brandsView.register(UINib(nibName: "BrandImageCell", bundle: bundle), forCellWithReuseIdentifier: "BrandCell")

        // style
        if let formStyle = formStyle {
            cardFormView.apply(style: formStyle)
            if let submitButtonColor = formStyle.submitButtonColor {
                saveButton.normalBackgroundColor = submitButtonColor
                accessorySubmitButton.normalBackgroundColor = submitButtonColor
            }
        }

        setupKeyboardNotification()
        fetchAccpetedBrands()
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if isMovingFromParent && presenter?.cardFormResultSuccess == false {
            didCompleteCardForm(with: .cancel)
        }
    }

    // MARK: Selector

    @objc private func submitTapped(sender: UIButton) {
        self.view.endEditing(true)
        createToken()
    }

    @objc private func handleKeyboardShow(notification: Notification) {
        saveButton.isHidden = true
    }

    @objc private func handleKeyboardHide(notification: Notification) {
        saveButton.isHidden = false
    }

    @objc private func keyboardDidChangeFrame(notification: Notification) {
        let keyboardRect = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero
        let keyboardY = scrollView.bounds.height - keyboardRect.origin.y

        var contentInset = scrollView.contentInset
        contentInset.bottom = keyboardY
        scrollView.contentInset = contentInset

        scrollView.showsVerticalScrollIndicator = false
        var scrollIndicatorInsets = scrollView.scrollIndicatorInsets
        scrollIndicatorInsets.bottom = keyboardY
        scrollView.scrollIndicatorInsets = scrollIndicatorInsets
        scrollView.showsVerticalScrollIndicator = true
    }

    // MARK: Private

    private func setupKeyboardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidChangeFrame),
                                               name: UIResponder.keyboardDidChangeFrameNotification,
                                               object: nil)
    }

    private func createToken() {
        cardFormView.cardFormInput { result in
            switch result {
            case .success(let formInput):
                presenter?.createToken(tenantId: tenantId, formInput: formInput)
            case .failure(let error):
                showError(message: error.localizedDescription)
            }
        }
    }

    private func fetchAccpetedBrands() {
        presenter?.fetchBrands(tenantId: tenantId)
    }
}

// MARK: CardFormScreenDelegate
extension CardFormViewController: CardFormScreenDelegate {
    func reloadBrands(brands: [CardBrand]) {
        accptedBrands = brands
        brandsView.reloadData()
    }

    func showIndicator() {
        activityIndicator.startAnimating()
    }

    func dismissIndicator() {
        activityIndicator.stopAnimating()
    }

    func showErrorView(message: String, buttonHidden: Bool) {
        errorView.show(message: message, reloadButtonHidden: buttonHidden)
    }

    func dismissErrorView() {
        errorView.dismiss()
    }

    func showErrorAlert(message: String) {
        showError(message: message)
    }

    func didCompleteCardForm(with result: CardFormResult) {
        delegate?.cardFormViewController(self, didCompleteWith: result)
    }

    func didProduced(with token: Token, completionHandler: @escaping (Error?) -> Void) {
        delegate?.cardFormViewController(self, didProduced: token, completionHandler: completionHandler)
    }
}

// MARK: CardFormViewDelegate
extension CardFormViewController: CardFormViewDelegate {
    public func formInputValidated(in cardFormView: UIView, isValid: Bool) {
        saveButton.isEnabled = isValid
        accessorySubmitButton.isEnabled = isValid
    }

    public func formInputDoneTapped(in cardFormView: UIView) {
        createToken()
    }
}

// MARK: UICollectionViewDataSource
extension CardFormViewController: UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return accptedBrands?.count ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandCell", for: indexPath)

        if let cell = cell as? BrandImageCell {
            if let brand = accptedBrands?[indexPath.row] {
                cell.setup(brand: brand)
            }
        }

        return cell
    }
}

// MARK: ErrorViewDelegate
extension CardFormViewController: ErrorViewDelegate {
    func reload() {
        fetchAccpetedBrands()
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension CardFormViewController: UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets {
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            let cellWidth = Int(flowLayout.itemSize.width)
            let cellSpacing = Int(flowLayout.minimumInteritemSpacing)
            let cellCount = accptedBrands?.count ?? 0

            let totalCellWidth = cellWidth * cellCount
            let totalSpacingWidth = cellSpacing * (cellCount - 1)

            let inset = (collectionView.bounds.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2

            return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        }
        return .zero
    }
}
