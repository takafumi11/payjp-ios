//
//  CreateTokenForApplePayRequest.swift
//  PAYJP
//
//  Created by Li-Hsuan Chen on 2019/07/25.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation
import PassKit

struct CreateTokenForApplePayRequest: BaseRequest {

    // MARK: - Request

    typealias Response = Token
    var path: String = "tokens"
    var httpMethod: String = "POST"
    var bodyParameters: [String: String]? {
        return ["card": paymentToken]
    }

    // MARK: - Data

    let paymentToken: String

    init(paymentToken: String) {
        self.paymentToken = paymentToken
    }
}
