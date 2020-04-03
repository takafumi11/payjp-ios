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
    func enableSubmitButton()
    func disableSubmitButton()
    func showErrorView(message: String, buttonHidden: Bool)
    func dismissErrorView()
    func showErrorAlert(message: String)
    func presentVerificationScreen(with tdsToken: ThreeDSecureToken)
    // callback
    func didCompleteCardForm(with result: CardFormResult)
    func didProduced(with token: Token,
                     completionHandler: @escaping (Error?) -> Void)
}

protocol CardFormScreenPresenterType {
    var cardFormResultSuccess: Bool { get }
    var tdsToken: ThreeDSecureToken? { get }

    func createToken(tenantId: String?, formInput: CardFormInput)
    func createTokenByTds()
    func fetchBrands(tenantId: String?)
}

class CardFormScreenPresenter: CardFormScreenPresenterType {
    var cardFormResultSuccess: Bool = false
    var tdsToken: ThreeDSecureToken?

    private weak var delegate: CardFormScreenDelegate?

    private let accountsService: AccountsServiceType
    private let tokenService: TokenServiceType
    private let errorTranslator: ErrorTranslatorType
    private let processHandler: ThreeDSecureProcessHandlerType
    private let dispatchQueue: DispatchQueue

    init(delegate: CardFormScreenDelegate,
         accountsService: AccountsServiceType = AccountsService.shared,
         tokenService: TokenServiceType = TokenService.shared,
         errorTranslator: ErrorTranslatorType = ErrorTranslator.shared,
         processHandler: ThreeDSecureProcessHandlerType = ThreeDSecureProcessHandler.shared,
         dispatchQueue: DispatchQueue = DispatchQueue.main) {
        self.delegate = delegate
        self.accountsService = accountsService
        self.tokenService = tokenService
        self.errorTranslator = errorTranslator
        self.processHandler = processHandler
        self.dispatchQueue = dispatchQueue
    }

    func createToken(tenantId: String?, formInput: CardFormInput) {
        showLoading()
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
                                        switch error {
                                        case .requiredThreeDSecure(let tdsToken):
                                            self.tdsToken = tdsToken
                                            self.validateThreeDSecure(tdsToken: tdsToken)
                                        default:
                                            self.showErrorAlert(message: self.errorTranslator.translate(error: error))
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

    func createTokenByTds() {
        if let tdsToken = tdsToken {
            tokenService.createTokenForThreeDSecure(tdsId: tdsToken.identifier) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let token):
                    self.creatingTokenCompleted(token: token)
                case .failure(let error):
                    self.showErrorAlert(message: self.errorTranslator.translate(error: error))
                }
            }
        }
    }

    private func validateThreeDSecure(tdsToken: ThreeDSecureToken, alreadyVerify: Bool = false) {
        self.dispatchQueue.async { [weak self] in
            guard let self = self else { return }
            self.delegate?.presentVerificationScreen(with: tdsToken)
        }
    }

    private func creatingTokenCompleted(token: Token) {
        delegate?.didProduced(with: token) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showErrorAlert(message: error.localizedDescription)
            } else {
                self.dispatchQueue.async { [weak self] in
                    guard let self = self else { return }
                    self.cardFormResultSuccess = true
                    self.dismissLoading()
                    self.delegate?.didCompleteCardForm(with: .success)
                }
            }
        }
    }

    private func showLoading() {
        delegate?.showIndicator()
        delegate?.disableSubmitButton()
    }

    private func dismissLoading() {
        delegate?.dismissIndicator()
        delegate?.enableSubmitButton()
    }

    private func showErrorAlert(message: String) {
        dispatchQueue.async { [weak self] in
            guard let self = self else { return }
            self.dismissLoading()
            self.delegate?.showErrorAlert(message: message)
        }
    }
}
