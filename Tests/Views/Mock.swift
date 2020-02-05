//
//  Mock.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/12/06.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import XCTest
import PassKit
@testable import PAYJP

class MockCardFormScreenDelegate: CardFormScreenDelegate {
    var fetchedBrands: [CardBrand] = []
    var showIndicatorCalled = false
    var dismissIndicatorCalled = false
    var showErrorViewMessage: String?
    var showErrorViewButtonHidden = false
    var dismissErrorViewCalled = false
    var showErrorAlertMessage: String?
    var didCompleteCardFormCalled = false
    var didProducedCalled = false

    let error: Error?
    let expectation: XCTestExpectation

    init(error: Error? = nil, expectation: XCTestExpectation) {
        self.error = error
        self.expectation = expectation
    }

    func reloadBrands(brands: [CardBrand]) {
        fetchedBrands = brands
        expectation.fulfill()
    }

    func showIndicator() {
        showIndicatorCalled = true
    }

    func dismissIndicator() {
        dismissIndicatorCalled = true
    }

    func showErrorView(message: String, buttonHidden: Bool) {
        showErrorViewMessage = message
        showErrorViewButtonHidden = buttonHidden
        expectation.fulfill()
    }

    func dismissErrorView() {
        dismissErrorViewCalled = true
    }

    func showErrorAlert(message: String) {
        showErrorAlertMessage = message
        expectation.fulfill()
    }

    func didCompleteCardForm(with result: CardFormResult) {
        didCompleteCardFormCalled = true
        expectation.fulfill()
    }

    func didProduced(with token: Token, completionHandler: @escaping (Error?) -> Void) {
        didProducedCalled = true
        completionHandler(error)
    }
}

class MockTokenService: TokenServiceType {
    let token: Token
    let error: APIError?
    let expectation: XCTestExpectation
    var calledTenantId: String?

    init(token: Token, error: APIError? = nil, expectation: XCTestExpectation) {
        self.token = token
        self.error = error
        self.expectation = expectation
    }

    // swiftlint:disable function_parameter_count
    func createToken(cardNumber: String,
                     cvc: String,
                     expirationMonth: String,
                     expirationYear: String,
                     name: String?,
                     tenantId: String?,
                     completion: @escaping (Result<Token, APIError>) -> Void) -> URLSessionDataTask? {

        self.calledTenantId = tenantId

        if let error  = error {
            completion(.failure(error))
        } else {
            completion(.success(token))
        }

        return nil
    }
    // swiftlint:enable function_parameter_count

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
    let brands: [CardBrand]
    let error: APIError?
    let expectation: XCTestExpectation
    var calledTenantId: String?

    init(brands: [CardBrand], error: APIError? = nil, expectation: XCTestExpectation) {
        self.brands = brands
        self.error = error
        self.expectation = expectation
    }

    func getAcceptedBrands(tenantId: String?,
                           completion: CardBrandsResult?) -> URLSessionDataTask? {

        self.calledTenantId = tenantId

        if let error = error {
            completion?(.failure(error))
        } else {
            completion?(.success(brands))
        }

        return nil
    }
}

class MockPermissionFetcher: PermissionFetcherType {
    let status: PermissionAuthorizationStatus
    let shouldAccess: Bool
    var completion : (() -> Void)?

    init(status: PermissionAuthorizationStatus = .notDetermined,
         shouldAccess: Bool = false) {
        self.status = status
        self.shouldAccess = shouldAccess
    }

    func checkCamera() -> PermissionAuthorizationStatus {
        return self.status
    }

    func requestCamera(completion: @escaping () -> Void) {
        if shouldAccess {
            self.completion = completion
        }
    }
}
