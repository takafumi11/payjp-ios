//
//  AccountsService.swift
//  PAYJP
//
//  Created by Li-Hsuan Chen on 2019/07/26.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

protocol AccountsServiceType {
    func getAcceptedBrands(completion: (Result<[CardBrand], Error>) -> Void)
}

struct AccountService: AccountsServiceType {
    func getAcceptedBrands(completion: (Result<[CardBrand], Error>) -> Void) {
    }
}
