//
//  AccountsService.swift
//  PAYJP
//
//  Created by Li-Hsuan Chen on 2019/07/26.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

protocol AccountsServiceType {
    func getAcceptedBrands(tenantId: String?, completion: @escaping (Result<[CardBrand], Error>) -> Void) -> URLSessionDataTask?
}

struct AccountService: AccountsServiceType {
    
    private let client: ClientType
    
    static let shared = AccountService()
    
    init(client: ClientType = Client.shared) {
        self.client = client
    }
    
    func getAcceptedBrands(tenantId: String?, completion: @escaping (Result<[CardBrand], Error>) -> Void) -> URLSessionDataTask? {
        let request = GetAcceptedBrands(tenantId: tenantId)
        return client.request(with: request) { result in
            switch result {
            case .success(let data):
                completion(.success(data.acceptedBrands))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
