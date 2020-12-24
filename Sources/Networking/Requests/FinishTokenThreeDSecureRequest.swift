//
//  FinishTokenThreeDSecureRequest.swift
//  PAYJP
//
//  Created by 北川達也 on 2020/12/22.
//  Copyright © 2020 PAY, Inc. All rights reserved.
//

import Foundation

struct FinishTokenThreeDSecureRequest: BaseRequest {
    typealias Response = Token

    var path: String { return "tokens/\(tokenId)/tds_finish" }
    var httpMethod: String = "POST"

    let tokenId: String

    init(tokenId: String) {
        self.tokenId = tokenId
    }
}
