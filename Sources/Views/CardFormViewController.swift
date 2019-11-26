//
//  CardFormViewController.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/11/15.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

@objcMembers @objc(PAYCardFormViewController)
public class CardFormViewController: UIViewController {

    @IBOutlet weak var cardFormView: CardFormLabelStyledView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var brandsView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    private var formStyle: FormStyle?
    private var tenantId: String?

    private var accptedBrands: [CardBrand]?

    public weak var delegate: CardFormViewControllerDelegate?

    @objc(createCardFormViewControllerWithStyle: tenantId:)
    public static func createCardFormViewController(style: FormStyle? = nil,
                                                    tenantId: String? = nil) -> CardFormViewController {
        let stotyboard = UIStoryboard(name: "CardForm", bundle: Bundle(for: PAYJPSDK.self))
        guard
            let cardFormVc = stotyboard.instantiateInitialViewController() as? CardFormViewController
            else { fatalError("Couldn't instantiate CardFormViewController") }
        cardFormVc.formStyle = style
        cardFormVc.tenantId = tenantId
        return cardFormVc
    }

    @IBAction func registerCardTapped(_ sender: Any) {
        createToken()
    }

    public override func viewDidLoad() {
        cardFormView.delegate = self
        brandsView.dataSource = self

        let bundle = Bundle(for: BrandImageCell.self)
        brandsView.register(UINib(nibName: "BrandImageCell", bundle: bundle), forCellWithReuseIdentifier: "BrandCell")

        if let formStyle = formStyle {
            cardFormView.apply(style: formStyle)
        }

        fetchAccpetedBrands()
    }

    private func createToken() {
        activityIndicator.startAnimating()
        cardFormView.createToken(tenantId: "tenant_id") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.delegate?.cardFormViewController(self, didProducedToken: token) { error in
                    if let error = error {
                        print(debug: "[errorResponse] \(error.localizedDescription)")
                        // エラー
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            self.activityIndicator.stopAnimating()
                            self.showError(message: error.localizedDescription)
                        }
                    } else {
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            self.activityIndicator.stopAnimating()
                            self.delegate?.cardFormViewController(self, didCompleteWithResult: .success)
                        }
                    }
                }
            case .failure(let error):
                print(debug: "[errorResponse] \(error.localizedDescription)")
                // エラー
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.activityIndicator.stopAnimating()
                    self.showError(message: error.localizedDescription)
                }
            }
        }
    }

    private func fetchAccpetedBrands() {
        activityIndicator.startAnimating()
        cardFormView.fetchBrands(tenantId: "tenant_id") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let brands):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.accptedBrands = brands
                    self.activityIndicator.stopAnimating()
                    self.brandsView.reloadData()
                }
            case .failure(let error):
                print(debug: "[errorResponse] \(error.localizedDescription)")
                // TODO: エラー
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
}

extension CardFormViewController: CardFormViewDelegate {
    public func formInputValidated(in cardFormView: UIView, isValid: Bool) {
        saveButton.isEnabled = isValid
    }
}

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
