//
//  CardFormScreenViewModel.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/12/04.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

protocol CardFormScreenViewModelType {

    var acceptedBrands: Observable<[CardBrand]> { get }
    var loadingVisible: Observable<Bool> { get }
    var errorViewVisible: Observable<Bool> { get }
    var errorViewText: Observable<String> { get }
    var reloadButtonVisible: Observable<Bool> { get }

    func fetchBrands(tenantId: String?)
}

class CardFormScreenViewModel: CardFormScreenViewModelType {

    var acceptedBrands: Observable<[CardBrand]> = Observable<[CardBrand]>()
    var loadingVisible: Observable<Bool> = Observable<Bool>(false)
    var errorViewVisible: Observable<Bool> = Observable<Bool>(false)
    var errorViewText: Observable<String> = Observable<String>()
    var reloadButtonVisible: Observable<Bool> = Observable<Bool>(false)

    private let accountsService: AccountsServiceType
    private let errorTranslator: ErrorTranslatorType

    init(accountsService: AccountsServiceType = AccountsService.shared,
         errorTranslator: ErrorTranslatorType = ErrorTranslator.shared) {
        self.accountsService = accountsService
        self.errorTranslator = errorTranslator
    }

    func fetchBrands(tenantId: String?) {
        loadingVisible.value = true
        errorViewVisible.value = false
        accountsService.getAcceptedBrands(tenantId: tenantId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let brands):
                self.acceptedBrands.value = brands
                self.loadingVisible.value = false
                self.errorViewVisible.value = false
            case .failure(let error):
                self.loadingVisible.value = false
                self.errorViewText.value = self.errorTranslator.translate(error: error)
                self.reloadButtonVisible.value = {
                    switch error {
                    case .systemError:
                        return false
                    default:
                        return true
                    }
                }()
                self.errorViewVisible.value = true
            }
        }
    }
}
