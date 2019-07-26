//
//  GetAcceptedBrands.swift
//  PAYJP
//
//  Created by Li-Hsuan Chen on 2019/07/25.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

struct GetAcceptedBrands: BaseRequest {
    
    // MARK: - Request
    
    typealias Response = GetAcceptedBrandsResponse
    
    var path: String = "accounts/brands"
    var httpMethod: String = "GET"
    var queryParameters: [String : Any]? {
        if let tenantId = tenantId {
            return ["tenant": tenantId]
        }
        return nil
    }
    
    // MARK: - Data
    
    let tenantId: String?
    
    init(tenantId: String?) {
        self.tenantId = tenantId
    }
}
