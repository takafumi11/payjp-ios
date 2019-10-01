//
//  CreateTokenRequest.swift
//  PAYJP
//
//  Created by Li-Hsuan Chen on 2019/07/25.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

struct CreateTokenRequest: BaseRequest {
    typealias Response = Token

    var path: String = "tokens"
    var httpMethod: String = "POST"
    var bodyParameters: [String: String]? {
        var parameters = [
            "card[number]": cardNumber,
            "card[cvc]": cvc,
            "card[exp_month]": expirationMonth,
            "card[exp_year]": expirationYear
        ]

        parameters["card[name]"] = name
        return parameters
    }

    // MARK: - Data

    private let cardNumber: String
    private let cvc: String
    private let expirationMonth: String
    private let expirationYear: String
    private let name: String?

    // MARK: - Lifecycle

    init(
        cardNumber: String,
        cvc: String,
        expirationMonth: String,
        expirationYear: String,
        name: String?
        ) {
        self.cardNumber = cardNumber
        self.cvc = cvc
        self.expirationMonth = expirationMonth
        self.expirationYear = expirationYear
        self.name = name
    }
}
