//
//  Mock.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/12/06.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation
import PassKit
@testable import PAYJP

class MockCardFormScreenDelegate: CardFormScreenDelegate {
    var reloadBrandsCalled = false
    var showIndicatorCalled = false
    var dismissIndicatorCalled = false
    var showErrorViewCalled = false
    var showErrorViewButtonHidden = false
    var dismissErrorViewCalled = false
    var showErrorAlertCalled = false
    var didCompleteCardFormCalled = false
    var didProducedCalled = false

    var isError = false

    func reloadBrands(brands: [CardBrand]) {
        reloadBrandsCalled = true
    }

    func showIndicator() {
        showIndicatorCalled = true
    }

    func dismissIndicator() {
        dismissIndicatorCalled = true
    }

    func showErrorView(message: String, buttonHidden: Bool) {
        showErrorViewCalled = true
    }

    func dismissErrorView() {
        dismissErrorViewCalled = true
    }

    func showErrorAlert(message: String) {
        showErrorAlertCalled = true
    }

    func didCompleteCardForm(with result: CardFormResult) {
        didCompleteCardFormCalled = true
    }

    func didProduced(with token: Token, completionHandler: @escaping (Error?) -> Void) {
        didProducedCalled = true

        if isError {
            completionHandler(APIError.invalidResponse(nil))
        } else {
            completionHandler(nil)
        }
    }
}

class MockClient: ClientType {
    func request<Request: PAYJP.Request>(with request: Request,
                                         completion: ((Result<Request.Response, APIError>) -> Void)?)
        -> URLSessionDataTask? {
            return nil
    }
}

class MockTokenService: TokenServiceType {
    var isError = false

    func createToken(cardNumber: String,
                     cvc: String,
                     expirationMonth: String,
                     expirationYear: String,
                     name: String?,
                     tenantId: String?,
                     completion: @escaping (Result<Token, APIError>) -> Void) -> URLSessionDataTask? {

        let json = TestFixture.JSON(by: "token.json")
        // swiftlint:disable force_try
        let token = try! Token.decodeJson(with: json, using: JSONDecoder.shared)
        // swiftlint:enable force_try

        if isError {
            completion(.failure(.invalidResponse(nil)))
        } else {
            completion(.success(token))
        }

        let request = CreateTokenRequest(
            cardNumber: cardNumber,
            cvc: cvc,
            expirationMonth: expirationMonth,
            expirationYear: expirationYear,
            name: name,
            tenantId: tenantId)

        let client = MockClient()
        return client.request(with: request, completion: nil)
    }

    func createTokenForApplePay(paymentToken: PKPaymentToken,
                                completion: @escaping (Result<Token, APIError>) -> Void) -> URLSessionDataTask? {
        return nil
    }

    func getToken(with tokenId: String,
                  completion: @escaping (Result<Token, APIError>) -> Void) -> URLSessionDataTask? {
        return nil
    }
}

class MockAccountService: AccountsServiceType {
    var isError = false

    func getAcceptedBrands(tenantId: String?,
                           completion: CardBrandsResult?) -> URLSessionDataTask? {

        let json = TestFixture.JSON(by: "cardBrands.json")
        // swiftlint:disable force_try
        let brands = try! JSONDecoder.shared.decode(GetAcceptedBrandsResponse.self, from: json)
        // swiftlint:enable force_try

        if isError {
            completion?(.failure(.invalidResponse(nil)))
        } else {
            completion?(.success(brands.acceptedBrands))
        }

        let request = GetAcceptedBrands(tenantId: tenantId)

        let client = MockClient()
        return client.request(with: request, completion: nil)
    }
}
