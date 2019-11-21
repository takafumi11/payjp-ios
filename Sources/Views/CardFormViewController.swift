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
    @IBOutlet weak var acceptedBrandsView: AcceptedBrandsView!

    private var formStyle: FormStyle?
    private var tenantId: String?
//    private var accptedBrands: [CardBrand]?

    public weak var delegate: CardFormViewControllerDelegate?

    @objc(createCardFormViewControllerWithStyle:tenantId:)
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
//        acceptedBrandsView.delegate = self
//        acceptedBrandsView.dataSource = self
        
        if let formStyle = formStyle {
            cardFormView.apply(style: formStyle)
        }
        
        fetchAccpetedBrands()
    }

    private func createToken() {
        cardFormView.createToken(tenantId: "tenant_id") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.delegate?.cardFormViewController(self, didProducedToken: token) { error in
                    if let error = error {
                        print("[errorResponse] \(error.localizedDescription)")
                        // TODO: エラー
                    } else {
                        self.delegate?.cardFormViewController(self, didCompleteWithResult: .success)
                    }
                }
            case .failure(let error):
                if let apiError = error as? APIError, let payError = apiError.payError {
                    print("[errorResponse] \(payError.description)")
                }
                // TODO: エラー
            }
        }
    }
    
    private func fetchAccpetedBrands() {
        cardFormView.fetchBrands(tenantId: "tenant_id") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let brands):
//                self.accptedBrands = brands
                DispatchQueue.main.async {
                    self.acceptedBrandsView.cardBrands = brands
                }
//                self.acceptedBrandsView.reloadData()
            case .failure(let error):
                if let payError = error.payError {
                    print("[errorResponse] \(payError.description)")
                }
                // TODO: エラー
            }
        }
    }
}

extension CardFormViewController: CardFormViewDelegate {
    public func formInputValidated(in cardFormView: UIView, isValid: Bool) {
        saveButton.isEnabled = isValid
    }
}

//extension CardFormViewController: UICollectionViewDataSource {
//
//    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        accptedBrands?.count ?? 0
//    }
//
//    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = acceptedBrandsView.dequeueReusableCell(withReuseIdentifier: "brandCell", for: indexPath)
//        if let brands = accptedBrands, let brand = brands[indexPath.row] {
//            if let image = cell.contentView.viewWithTag(1) as? UIImageView {
//
//            }
//        }
//    }
//}
