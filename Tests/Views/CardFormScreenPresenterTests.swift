//
//  CardFormScreenPresenterTests.swift
//  PAYJPTests
//
//  Created by Tadashi Wakayanagi on 2019/12/05.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import XCTest
@testable import PAYJP

class CardFormScreenPresenterTests: XCTestCase {

    private func cardFormInput() -> CardFormInput {
        return CardFormInput(cardNumber: "1234",
                             expirationMonth: "4",
                             expirationYear: "20",
                             cvc: "123",
                             cardHolder: "waka")
    }

    private func mockToken(tdsStatus: ThreeDSecureStatus? = nil) -> Token {
        let card = Card(identifier: "card_id",
                        name: "paykun",
                        last4Number: "1234",
                        brand: "visa",
                        expirationMonth: 12,
                        expirationYear: 19,
                        fingerprint: "abcdefg",
                        liveMode: false,
                        createAt: Date(),
                        threeDSecureStatus: tdsStatus)
        let token = Token(identifier: "token_id",
                          livemode: false,
                          used: false,
                          card: card,
                          createAt: Date())
        return token
    }

    private func mockAccpetedBrands() -> [CardBrand] {
        let brands: [CardBrand] = [.visa, .mastercard, .jcb]
        return brands
    }

    func testCreateToken_success() {
        let expectation = self.expectation(description: "view update")
        let mockDelegate = MockCardFormScreenDelegate(expectation: expectation)
        let mockService = MockTokenService(token: mockToken())

        let presenter = CardFormScreenPresenter(delegate: mockDelegate, tokenService: mockService)
        presenter.createToken(tenantId: "tenant_id", formInput: cardFormInput())

        waitForExpectations(timeout: 1, handler: nil)

        XCTAssertEqual(mockService.calledTenantId, "tenant_id")
        XCTAssertTrue(mockDelegate.showIndicatorCalled, "showIndicator not called")
        XCTAssertTrue(mockDelegate.didProducedCalled, "didProduced not called")
        XCTAssertTrue(mockDelegate.dismissIndicatorCalled, "dismissIndicator not called")
        XCTAssertTrue(mockDelegate.didCompleteCardFormCalled, "didCompleteCardForm not called")
        XCTAssertTrue(presenter.cardFormResultSuccess)
    }

    func testCreateToken_failure() {
        let error = NSError(domain: "mock_domain", code: 0, userInfo: [NSLocalizedDescriptionKey: "mock api error"])
        let apiError = APIError.systemError(error)
        let expectation = self.expectation(description: "view update")
        let mockDelegate = MockCardFormScreenDelegate(expectation: expectation)
        let mockService = MockTokenService(token: mockToken(), error: apiError)

        let presenter = CardFormScreenPresenter(delegate: mockDelegate, tokenService: mockService)
        presenter.createToken(tenantId: "tenant_id", formInput: cardFormInput())

        waitForExpectations(timeout: 1, handler: nil)

        XCTAssertEqual(mockService.calledTenantId, "tenant_id")
        XCTAssertTrue(mockDelegate.showIndicatorCalled, "showIndicator not called")
        XCTAssertTrue(mockDelegate.dismissIndicatorCalled, "dismissIndicator not called")
        XCTAssertEqual(mockDelegate.showErrorAlertMessage, "mock api error")
        XCTAssertFalse(presenter.cardFormResultSuccess)
    }

    func testCreateToken_delegate_failure() {
        let error = NSError(domain: "mock_domain",
                            code: 0,
                            userInfo: [NSLocalizedDescriptionKey: "mock delegate error"])
        let expectation = self.expectation(description: "view update")
        let mockDelegate = MockCardFormScreenDelegate(error: error, expectation: expectation)
        let mockService = MockTokenService(token: mockToken())

        let presenter = CardFormScreenPresenter(delegate: mockDelegate, tokenService: mockService)
        presenter.createToken(tenantId: "tenant_id", formInput: cardFormInput())

        waitForExpectations(timeout: 1, handler: nil)

        XCTAssertEqual(mockService.calledTenantId, "tenant_id")
        XCTAssertTrue(mockDelegate.showIndicatorCalled, "showIndicator not called")
        XCTAssertTrue(mockDelegate.dismissIndicatorCalled, "dismissIndicator not called")
        XCTAssertEqual(mockDelegate.showErrorAlertMessage, "mock delegate error")
        XCTAssertFalse(presenter.cardFormResultSuccess)
    }

    func testFetchBrands_success() {
        let expectation = self.expectation(description: "view update")
        let mockDelegate = MockCardFormScreenDelegate(expectation: expectation)
        let brands = mockAccpetedBrands()
        let mockService = MockAccountService(brands: brands)

        let presenter = CardFormScreenPresenter(delegate: mockDelegate, accountsService: mockService)
        presenter.fetchBrands(tenantId: "tenant_id")

        waitForExpectations(timeout: 1, handler: nil)

        XCTAssertEqual(mockService.calledTenantId, "tenant_id")
        XCTAssertTrue(mockDelegate.showIndicatorCalled, "showIndicator not called")
        XCTAssertEqual(mockDelegate.fetchedBrands, brands)
        XCTAssertTrue(mockDelegate.dismissIndicatorCalled, "dismissIndicator not called")
        XCTAssertTrue(mockDelegate.dismissErrorViewCalled, "dismissErrorView not called")
        XCTAssertFalse(presenter.cardFormResultSuccess)
    }

    func testFetchBrands_failure() {
        let error = NSError(domain: "mock_domain",
                            code: 0,
                            userInfo: [NSLocalizedDescriptionKey: "mock api error"])
        let apiError = APIError.systemError(error)
        let expectation = self.expectation(description: "view update")
        let mockDelegate = MockCardFormScreenDelegate(expectation: expectation)
        let mockService = MockAccountService(brands: mockAccpetedBrands(), error: apiError)

        let presenter = CardFormScreenPresenter(delegate: mockDelegate, accountsService: mockService)
        presenter.fetchBrands(tenantId: "tenant_id")

        waitForExpectations(timeout: 1, handler: nil)

        XCTAssertEqual(mockService.calledTenantId, "tenant_id")
        XCTAssertTrue(mockDelegate.showIndicatorCalled, "showIndicator not called")
        XCTAssertTrue(mockDelegate.dismissIndicatorCalled, "dismissIndicator not called")
        XCTAssertTrue(mockDelegate.dismissErrorViewCalled, "dismissErrorView not called")
        XCTAssertEqual(mockDelegate.showErrorViewMessage, "mock api error")
        XCTAssertFalse(mockDelegate.showErrorViewButtonHidden)
        XCTAssertFalse(presenter.cardFormResultSuccess)
    }

    func testValidateThreeDSecure_execute() {
        let expectation = self.expectation(description: "view update")
        let mockDelegate = MockCardFormScreenDelegate(expectation: expectation)
        let token = mockToken(tdsStatus: .unverified)
        let mockService = MockTokenService(token: token)

        let presenter = CardFormScreenPresenter(delegate: mockDelegate, tokenService: mockService)
        presenter.createToken(tenantId: "tenant_id", formInput: cardFormInput())

        waitForExpectations(timeout: 1, handler: nil)

        XCTAssertEqual(mockService.calledTenantId, "tenant_id")
        XCTAssertTrue(mockDelegate.showIndicatorCalled, "showIndicator not called")
        XCTAssertTrue(mockDelegate.dismissIndicatorCalled, "dismissIndicator not called")
        XCTAssertEqual(mockDelegate.presentVerificationScreenToken, token)
        XCTAssertFalse(presenter.cardFormResultSuccess)
    }

    func testValidateThreeDSecure_failure() {
        let expectation = self.expectation(description: "view update")
        let mockDelegate = MockCardFormScreenDelegate(expectation: expectation)
        let token = mockToken(tdsStatus: .unverified)
        let mockService = MockTokenService(token: token)

        let presenter = CardFormScreenPresenter(delegate: mockDelegate, tokenService: mockService)
        presenter.fetchToken(tokenId: "token_id")

        waitForExpectations(timeout: 1, handler: nil)

        XCTAssertEqual(mockService.calledTokenId, "token_id")
        XCTAssertTrue(mockDelegate.showIndicatorCalled, "showIndicator not called")
        XCTAssertTrue(mockDelegate.dismissIndicatorCalled, "dismissIndicator not called")
        XCTAssertEqual(mockDelegate.showErrorAlertMessage,
                       "Card verification is successful. There isn`t verified card.")
        XCTAssertFalse(presenter.cardFormResultSuccess)
    }

    func testFetchToken_success() {
        let expectation = self.expectation(description: "view update")
        let mockDelegate = MockCardFormScreenDelegate(expectation: expectation)
        let token = mockToken(tdsStatus: .verified)
        let mockService = MockTokenService(token: token)

        let presenter = CardFormScreenPresenter(delegate: mockDelegate, tokenService: mockService)
        presenter.fetchToken(tokenId: "token_id")

        waitForExpectations(timeout: 1, handler: nil)

        XCTAssertEqual(mockService.calledTokenId, "token_id")
        XCTAssertTrue(mockDelegate.showIndicatorCalled, "showIndicator not called")
        XCTAssertTrue(mockDelegate.didProducedCalled, "didProduced not called")
        XCTAssertTrue(mockDelegate.dismissIndicatorCalled, "dismissIndicator not called")
        XCTAssertTrue(mockDelegate.didCompleteCardFormCalled, "didCompleteCardForm not called")
        XCTAssertTrue(presenter.cardFormResultSuccess)
    }

    func testFetchToken_failure() {
        let error = NSError(domain: "mock_domain",
                            code: 0,
                            userInfo: [NSLocalizedDescriptionKey: "mock api error"])
        let apiError = APIError.systemError(error)
        let expectation = self.expectation(description: "view update")
        let mockDelegate = MockCardFormScreenDelegate(expectation: expectation)
        let token = mockToken(tdsStatus: .verified)
        let mockService = MockTokenService(token: token, error: apiError)

        let presenter = CardFormScreenPresenter(delegate: mockDelegate, tokenService: mockService)
        presenter.fetchToken(tokenId: "token_id")

        waitForExpectations(timeout: 1, handler: nil)

        XCTAssertEqual(mockService.calledTokenId, "token_id")
        XCTAssertTrue(mockDelegate.showIndicatorCalled, "showIndicator not called")
        XCTAssertTrue(mockDelegate.dismissIndicatorCalled, "dismissIndicator not called")
        XCTAssertEqual(mockDelegate.showErrorAlertMessage, "mock api error")
        XCTAssertFalse(presenter.cardFormResultSuccess)
    }
}
