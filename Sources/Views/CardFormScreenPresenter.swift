//
//  CardFormScreenPresenter.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/12/04.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

protocol CardFormScreenDelegate: class {
    // update view
    func reloadBrands(brands: [CardBrand])
    func showIndicator()
    func dismissIndicator()
    func showErrorView(message: String, buttonHidden: Bool)
    func dismissErrorView()
    func showErrorAlert(message: String)
    // callback
    func didCompleteCardForm(with result: CardFormResult)
    func didProduced(with token: Token,
                     completionHandler: @escaping (Error?) -> Void)
}

protocol CardFormScreenPresenterType {
    func createToken(tenantId: String?, formInput: CardFormInput)
    func fetchBrands(tenantId: String?)
}

class CardFormScreenPresenter: CardFormScreenPresenterType {

    private weak var delegate: CardFormScreenDelegate?

    private let accountsService: AccountsServiceType
    private let tokenService: TokenServiceType
    private let errorTranslator: ErrorTranslatorType
    private let dispatchQueue: DispatchQueue

    init(delegate: CardFormScreenDelegate,
         accountsService: AccountsServiceType = AccountsService.shared,
         tokenService: TokenServiceType = TokenService.shared,
         errorTranslator: ErrorTranslatorType = ErrorTranslator.shared,
         dispatchQueue: DispatchQueue = DispatchQueue.main) {
        self.delegate = delegate
        self.accountsService = accountsService
        self.tokenService = tokenService
        self.errorTranslator = errorTranslator
        self.dispatchQueue = dispatchQueue
    }

    func createToken(tenantId: String?, formInput: CardFormInput) {
        delegate?.showIndicator()
        tokenService.createToken(cardNumber: formInput.cardNumber,
                                 cvc: formInput.cvc,
                                 expirationMonth: formInput.expirationMonth,
                                 expirationYear: formInput.expirationYear,
                                 name: formInput.cardHolder,
                                 tenantId: tenantId) { [weak self] result in
                                    guard let self = self else { return }
                                    switch result {
                                    case .success(let token):
                                        self.creatingTokenCompleted(token: token)
                                    case .failure(let error):
                                        self.dispatchQueue.async { [weak self] in
                                            guard let self = self else { return }
                                            self.delegate?.dismissIndicator()
                                            self.delegate?.showErrorAlert(
                                                message: self.errorTranslator.translate(error: error)
                                            )
                                        }
                                    }
        }
    }

    private func creatingTokenCompleted(token: Token) {
        self.delegate?.didProduced(with: token) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.dispatchQueue.async { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.dismissIndicator()
                    self.delegate?.showErrorAlert(message: error.localizedDescription)
                }
            } else {
                self.dispatchQueue.async { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.dismissIndicator()
                    self.delegate?.didCompleteCardForm(with: .success)
                }
            }
        }
    }

    func fetchBrands(tenantId: String?) {
        delegate?.showIndicator()
        delegate?.dismissErrorView()
        accountsService.getAcceptedBrands(tenantId: tenantId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let brands):
                self.dispatchQueue.async { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.dismissIndicator()
                    self.delegate?.dismissErrorView()
                    self.delegate?.reloadBrands(brands: brands)
                }
            case .failure(let error):
                self.dispatchQueue.async { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.dismissIndicator()
                    let message = self.errorTranslator.translate(error: error)
                    let buttonHidden: Bool = {
                        switch error {
                        case .systemError:
                            return false
                        default:
                            return true
                        }
                    }()
                    self.delegate?.showErrorView(message: message, buttonHidden: buttonHidden)
                }
            }
        }
    }
}
