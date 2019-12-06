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

    // swiftlint:disable force_try
    private func tokenFromJson() -> Token {
        let json = TestFixture.JSON(by: "token.json")
        let token = try! Token.decodeJson(with: json, using: JSONDecoder.shared)
        return token
    }

    private func brandsFromJson() -> [CardBrand] {
        let json = TestFixture.JSON(by: "cardBrands.json")
        let brands = try! JSONDecoder.shared.decode(GetAcceptedBrandsResponse.self, from: json)
        return brands.acceptedBrands
    }
    // swiftlint:enable force_try

    func testCreateToken_success() {
        let expectation = self.expectation(description: "view update")
        let mockDelegate = MockCardFormScreenDelegate(expectation: expectation)
        let mockService = MockTokenService(token: tokenFromJson(), expectation: expectation)

        let presenter = CardFormScreenPresenter(delegate: mockDelegate, tokenService: mockService)
        presenter.createToken(tenantId: "tenant_id", formInput: cardFormInput())

        waitForExpectations(timeout: 1, handler: nil)

        XCTAssertEqual(mockService.calledTenantId, "tenant_id")
        XCTAssertTrue(mockDelegate.showIndicatorCalled, "showIndicator not called")
        XCTAssertTrue(mockDelegate.didProducedCalled, "didProduced not called")
        XCTAssertTrue(mockDelegate.dismissIndicatorCalled, "dismissIndicator not called")
        XCTAssertTrue(mockDelegate.didCompleteCardFormCalled, "didCompleteCardForm not called")
    }

    func testCreateToken_failure() {
        let error = NSError(domain: "mock_domain", code: 0, userInfo: [NSLocalizedDescriptionKey: "mock api error"])
        let apiError = APIError.systemError(error)
        let expectation = self.expectation(description: "view update")
        let mockDelegate = MockCardFormScreenDelegate(expectation: expectation)
        let mockService = MockTokenService(token: tokenFromJson(), error: apiError, expectation: expectation)

        let presenter = CardFormScreenPresenter(delegate: mockDelegate, tokenService: mockService)
        presenter.createToken(tenantId: "tenant_id", formInput: cardFormInput())

        waitForExpectations(timeout: 1, handler: nil)

        XCTAssertEqual(mockService.calledTenantId, "tenant_id")
        XCTAssertTrue(mockDelegate.showIndicatorCalled, "showIndicator not called")
        XCTAssertTrue(mockDelegate.dismissIndicatorCalled, "dismissIndicator not called")
        XCTAssertEqual(mockDelegate.showErrorAlertMessage, "mock api error")
    }

    func testCreateToken_delegate_failure() {
        let error = NSError(domain: "mock_domain",
                            code: 0,
                            userInfo: [NSLocalizedDescriptionKey: "mock delegate error"])
        let expectation = self.expectation(description: "view update")
        let mockDelegate = MockCardFormScreenDelegate(error: error, expectation: expectation)
        let mockService = MockTokenService(token: tokenFromJson(), expectation: expectation)

        let presenter = CardFormScreenPresenter(delegate: mockDelegate, tokenService: mockService)
        presenter.createToken(tenantId: "tenant_id", formInput: cardFormInput())

        waitForExpectations(timeout: 1, handler: nil)

        XCTAssertEqual(mockService.calledTenantId, "tenant_id")
        XCTAssertTrue(mockDelegate.showIndicatorCalled, "showIndicator not called")
        XCTAssertTrue(mockDelegate.dismissIndicatorCalled, "dismissIndicator not called")
        XCTAssertEqual(mockDelegate.showErrorAlertMessage, "mock delegate error")
    }

    func testFetchBrands_success() {
        let expectation = self.expectation(description: "view update")
        let mockDelegate = MockCardFormScreenDelegate(expectation: expectation)
        let brands = brandsFromJson()
        let mockService = MockAccountService(brands: brands, expectation: expectation)

        let presenter = CardFormScreenPresenter(delegate: mockDelegate, accountsService: mockService)
        presenter.fetchBrands(tenantId: "tenant_id")

        waitForExpectations(timeout: 1, handler: nil)

        XCTAssertEqual(mockService.calledTenantId, "tenant_id")
        XCTAssertTrue(mockDelegate.showIndicatorCalled, "showIndicator not called")
        XCTAssertEqual(mockDelegate.fetchedBrands, brands)
        XCTAssertTrue(mockDelegate.dismissIndicatorCalled, "dismissIndicator not called")
        XCTAssertTrue(mockDelegate.dismissErrorViewCalled, "dismissErrorView not called")
    }

    func testFetchBrands_failure() {
        let error = NSError(domain: "mock_domain",
                            code: 0,
                            userInfo: [NSLocalizedDescriptionKey: "mock api error"])
        let apiError = APIError.systemError(error)
        let expectation = self.expectation(description: "view update")
        let mockDelegate = MockCardFormScreenDelegate(expectation: expectation)
        let mockService = MockAccountService(brands: brandsFromJson(), error: apiError, expectation: expectation)

        let presenter = CardFormScreenPresenter(delegate: mockDelegate, accountsService: mockService)
        presenter.fetchBrands(tenantId: "tenant_id")

        waitForExpectations(timeout: 1, handler: nil)

        XCTAssertEqual(mockService.calledTenantId, "tenant_id")
        XCTAssertTrue(mockDelegate.showIndicatorCalled, "showIndicator not called")
        XCTAssertTrue(mockDelegate.dismissIndicatorCalled, "dismissIndicator not called")
        XCTAssertTrue(mockDelegate.dismissErrorViewCalled, "dismissErrorView not called")
        XCTAssertEqual(mockDelegate.showErrorViewMessage, "mock api error")
        XCTAssertFalse(mockDelegate.showErrorViewButtonHidden)
    }
}
