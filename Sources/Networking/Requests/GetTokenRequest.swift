//
//  GetTokenRequest.swift
//  PAYJP
//
//  Created by Li-Hsuan Chen on 2019/07/25.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

struct GetTokenRequest: BaseRequest {
    typealias Response = Token
    
    var path: String { return "tokens/\(tokenId)" }
    var httpMethod: String = "GET"
    
    let tokenId: String
    
    init(tokenId: String) {
        self.tokenId = tokenId
    }
}
