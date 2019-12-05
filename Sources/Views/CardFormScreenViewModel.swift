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

protocol CardFormScreenViewModelType {
    func fetchBrands(tenantId: String?)
}

class CardFormScreenViewModel: CardFormScreenViewModelType {

    private weak var view: CardFormScreenView?

    private let accountsService: AccountsServiceType
    private let errorTranslator: ErrorTranslatorType

    init(view: CardFormScreenView,
         accountsService: AccountsServiceType = AccountsService.shared,
         errorTranslator: ErrorTranslatorType = ErrorTranslator.shared) {
        self.view = view
        self.accountsService = accountsService
        self.errorTranslator = errorTranslator
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
