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

    private func mockToken() -> Token {
        let card = Card(identifier: "card_id",
                        name: "paykun",
                        last4Number: "1234",
                        brand: "visa",
                        expirationMonth: 12,
                        expirationYear: 19,
                        fingerprint: "abcdefg",
                        liveMode: false,
                        createAt: Date())
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
        let mockService = MockTokenService(token: mockToken(), expectation: expectation)

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
        let mockService = MockTokenService(token: mockToken(), error: apiError, expectation: expectation)

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
        let mockService = MockTokenService(token: mockToken(), expectation: expectation)

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
        let mockService = MockAccountService(brands: brands, expectation: expectation)

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
        let mockService = MockAccountService(brands: mockAccpetedBrands(), error: apiError, expectation: expectation)

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
}
