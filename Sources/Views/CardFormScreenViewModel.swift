//
//  CardFormScreenViewModel.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/12/04.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

protocol CardFormScreenView: class {
    func reloadBrands(brands: [CardBrand])
    func showIndicator()
    func dismissIndicator()
    func showErrorView(message: String, buttonHidden: Bool)
    func dismissErrorView()
    func showErrorAlert(message: String)
}

protocol CardFormScreenViewModelDelegate: class {
    func tokenOperation(didCompleteWith result: CardFormResult)
    func tokenOperation(didProduced token: Token,
                        completionHandler: @escaping (Error?) -> Void)
}

protocol CardFormScreenViewModelType {
    func createToken(tenantId: String?, formInput: CardFormInput)
    func fetchBrands(tenantId: String?)
}

class CardFormScreenViewModel: CardFormScreenViewModelType {

    private weak var view: CardFormScreenView?
    private weak var delegate: CardFormScreenViewModelDelegate?

    private let accountsService: AccountsServiceType
    private let tokenService: TokenServiceType
    private let errorTranslator: ErrorTranslatorType

    init(view: CardFormScreenView,
         delegate: CardFormScreenViewModelDelegate,
         accountsService: AccountsServiceType = AccountsService.shared,
         tokenService: TokenServiceType = TokenService.shared,
         errorTranslator: ErrorTranslatorType = ErrorTranslator.shared) {
        self.view = view
        self.delegate = delegate
        self.accountsService = accountsService
        self.tokenService = tokenService
        self.errorTranslator = errorTranslator
    }

    func createToken(tenantId: String?, formInput: CardFormInput) {
        view?.showIndicator()
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
                                        DispatchQueue.main.async { [weak self] in
                                            guard let self = self else { return }
                                            self.view?.dismissIndicator()
                                            self.view?.showErrorAlert(message: self.errorTranslator.translate(error: error))
                                        }
                                    }
        }
    }

    private func creatingTokenCompleted(token: Token) {
        self.delegate?.tokenOperation(didProduced: token) { error in
            if let error = error {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.view?.dismissIndicator()
                    self.view?.showErrorAlert(message: error.localizedDescription)
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.view?.dismissIndicator()
                    self.delegate?.tokenOperation(didCompleteWith: .success)
                }
            }
        }
    }

    func fetchBrands(tenantId: String?) {
        view?.showIndicator()
        view?.dismissErrorView()
        accountsService.getAcceptedBrands(tenantId: tenantId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let brands):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.view?.reloadBrands(brands: brands)
                    self.view?.dismissIndicator()
                    self.view?.dismissErrorView()
                }
            case .failure(let error):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.view?.dismissIndicator()
                    let message = self.errorTranslator.translate(error: error)
                    let buttonHidden: Bool = {
                        switch error {
                        case .systemError:
                            return false
                        default:
                            return true
                        }
                    }()
                    self.view?.showErrorView(message: message, buttonHidden: buttonHidden)
                }
            }
        }
    }
}
