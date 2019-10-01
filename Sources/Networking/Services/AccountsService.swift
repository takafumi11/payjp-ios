//
//  AccountsService.swift
//  PAYJP
//
//  Created by Li-Hsuan Chen on 2019/07/26.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

public typealias CardBrandsResult = (Result<[CardBrand], APIError>) -> Void

protocol AccountsServiceType {
    @discardableResult
    func getAcceptedBrands(tenantId: String?, completion: CardBrandsResult?) -> URLSessionDataTask?
}

struct AccountsService: AccountsServiceType {

    private let client: ClientType

    static let shared = AccountsService()

    init(client: ClientType = Client.shared) {
        self.client = client
    }

    func getAcceptedBrands(tenantId: String?, completion: CardBrandsResult?) -> URLSessionDataTask? {
        let request = GetAcceptedBrands(tenantId: tenantId)
        return client.request(with: request) { result in
            switch result {
            case .success(let data):
                completion?(.success(data.acceptedBrands))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
}
