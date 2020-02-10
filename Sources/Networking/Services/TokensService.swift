//
//  TokensService.swift
//  PAYJP
//
//  Created by Li-Hsuan Chen on 2019/07/26.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation
import PassKit

// swiftlint:disable function_parameter_count
protocol TokenServiceType {
    @discardableResult
    func createToken(
        cardNumber: String,
        cvc: String,
        expirationMonth: String,
        expirationYear: String,
        name: String?,
        tenantId: String?,
        completion: @escaping (Result<Token, APIError>) -> Void
    ) -> URLSessionDataTask?

    @discardableResult
    func createTokenForApplePay(
        paymentToken: PKPaymentToken,
        completion: @escaping (Result<Token, APIError>) -> Void
    ) -> URLSessionDataTask?

    @discardableResult
    func getToken(
        with tokenId: String,
        completion: @escaping (Result<Token, APIError>) -> Void
    ) -> URLSessionDataTask?
}

struct TokenService: TokenServiceType {

    let client: ClientType

    static let shared = TokenService()

    init(client: ClientType = Client.shared) {
        self.client = client
    }

    func createToken(
        cardNumber: String,
        cvc: String,
        expirationMonth: String,
        expirationYear: String,
        name: String?,
        tenantId: String?,
        completion: @escaping (Result<Token, APIError>) -> Void
    ) -> URLSessionDataTask? {
        let request = CreateTokenRequest(
            cardNumber: cardNumber,
            cvc: cvc,
            expirationMonth: expirationMonth,
            expirationYear: expirationYear,
            name: name,
            tenantId: tenantId)
        return client.request(with: request, completion: completion)
    }

    func createTokenForApplePay(
        paymentToken: PKPaymentToken,
        completion: @escaping (Result<Token, APIError>) -> Void
    ) -> URLSessionDataTask? {
        guard let decodedToken = String(data: paymentToken.paymentData, encoding: .utf8)?
            .addingPercentEncoding(withAllowedCharacters: .alphanumerics) else {
                completion(.failure(APIError.invalidApplePayToken(paymentToken)))
                return nil
        }

        let request = CreateTokenForApplePayRequest(paymentToken: decodedToken)
        return client.request(with: request, completion: completion)
    }

    func getToken(
        with tokenId: String,
        completion: @escaping (Result<Token, APIError>) -> Void
    ) -> URLSessionDataTask? {
        let request = GetTokenRequest(tokenId: tokenId)
        return client.request(with: request, completion: completion)
    }
}
// swiftlint:enable function_parameter_count
