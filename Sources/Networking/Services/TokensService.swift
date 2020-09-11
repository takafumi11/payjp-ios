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
    func createTokenForThreeDSecure(
        tdsId: String,
        completion: @escaping (Result<Token, APIError>) -> Void
    ) -> URLSessionDataTask?

    @discardableResult
    func getToken(
        with tokenId: String,
        completion: @escaping (Result<Token, APIError>) -> Void
    ) -> URLSessionDataTask?

    var tokenOperationObserver: TokenOperationObserverType { get }
}

class TokenService: TokenServiceType {

    let client: ClientType
    let tokenOperationObserverInternal: TokenOperationObserverInternalType

    static let shared = TokenService()

    init(client: ClientType = Client.shared,
         tokenOperationObserverInternal: TokenOperationObserverInternalType = TokenOperationObserver.shared) {
        self.client = client
        self.tokenOperationObserverInternal = tokenOperationObserverInternal
    }

    var tokenOperationObserver: TokenOperationObserverType {
        return self.tokenOperationObserverInternal
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
        self.tokenOperationObserverInternal.startRequest()
        return self.client.request(with: request) { [weak self] result in
            self?.tokenOperationObserverInternal.completeRequest()
            completion(result)
        }
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
        self.tokenOperationObserverInternal.startRequest()
        return self.client.request(with: request) { [weak self] result in
            self?.tokenOperationObserverInternal.completeRequest()
            completion(result)
        }
    }

    func createTokenForThreeDSecure(
        tdsId: String,
        completion: @escaping (Result<Token, APIError>) -> Void
    ) -> URLSessionDataTask? {
        let request = CreateTokenForThreeDSecureRequest(tdsId: tdsId)
        self.tokenOperationObserverInternal.startRequest()
        return client.request(with: request) { [weak self] result in
            self?.tokenOperationObserverInternal.completeRequest()
            completion(result)
        }
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
