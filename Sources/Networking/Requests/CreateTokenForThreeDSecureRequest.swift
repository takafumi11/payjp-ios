//
//  CreateTokenForThreeDSecureRequest.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2020/03/23.
//

import Foundation

struct CreateTokenForThreeDSecureRequest: BaseRequest {

    // MARK: - Request

    typealias Response = Token
    var path: String = "tokens"
    var httpMethod: String = "POST"
    var bodyParameters: [String: String]? {
        return ["tds_id": tdsId]
    }

    // MARK: - Data

    let tdsId: String

    init(tdsId: String) {
        self.tdsId = tdsId
    }
}
