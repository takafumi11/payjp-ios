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
    
    func testCreateToken_success() {
        let mockDelegate = MockCardFormScreenDelegate()
        let mockService = MockTokenService()
        let presenter = CardFormScreenPresenter(delegate: mockDelegate, tokenService: mockService)
        let input = cardFormInput()
        presenter.createToken(tenantId: "tenant_id", formInput: input)
        
        let expectation = self.expectation(description: "view update")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(mockDelegate.showIndicatorCalled, "showIndicator not called")
            XCTAssertTrue(mockDelegate.didProducedCalled, "didProduced not called")
            XCTAssertTrue(mockDelegate.dismissIndicatorCalled, "dismissIndicator not called")
            XCTAssertTrue(mockDelegate.didCompleteCardFormCalled, "didCompleteCardForm not called")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testCreateToken_failure() {
        let mockDelegate = MockCardFormScreenDelegate()
        let mockService = MockTokenService()
        mockService.isError = true
        let presenter = CardFormScreenPresenter(delegate: mockDelegate, tokenService: mockService)
        let input = cardFormInput()
        presenter.createToken(tenantId: "tenant_id", formInput: input)
        
        let expectation = self.expectation(description: "view update")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(mockDelegate.showIndicatorCalled, "showIndicator not called")
            XCTAssertTrue(mockDelegate.dismissIndicatorCalled, "dismissIndicator not called")
            XCTAssertTrue(mockDelegate.showErrorAlertCalled, "showErrorAlertCalled not called")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testCreateToken_delegate_failure() {
        let mockDelegate = MockCardFormScreenDelegate()
        mockDelegate.isError = true
        let mockService = MockTokenService()
        let presenter = CardFormScreenPresenter(delegate: mockDelegate, tokenService: mockService)
        let input = cardFormInput()
        presenter.createToken(tenantId: "tenant_id", formInput: input)
        
        let expectation = self.expectation(description: "view update")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(mockDelegate.showIndicatorCalled, "showIndicator not called")
            XCTAssertTrue(mockDelegate.dismissIndicatorCalled, "dismissIndicator not called")
            XCTAssertTrue(mockDelegate.showErrorAlertCalled, "showErrorAlertCalled not called")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchBrands_success() {
        let mockDelegate = MockCardFormScreenDelegate()
        let mockService = MockAccountService()
        let presenter = CardFormScreenPresenter(delegate: mockDelegate, accountsService: mockService)
        presenter.fetchBrands(tenantId: "tenant_id")
        
        let expectation = self.expectation(description: "view update")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(mockDelegate.showIndicatorCalled, "showIndicator not called")
            XCTAssertTrue(mockDelegate.reloadBrandsCalled, "reloadBrands not called")
            XCTAssertTrue(mockDelegate.dismissIndicatorCalled, "dismissIndicator not called")
            XCTAssertTrue(mockDelegate.dismissErrorViewCalled, "dismissErrorView not called")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchBrands_failure() {
        let mockDelegate = MockCardFormScreenDelegate()
        let mockService = MockAccountService()
        mockService.isError = true
        let presenter = CardFormScreenPresenter(delegate: mockDelegate, accountsService: mockService)
        presenter.fetchBrands(tenantId: "tenant_id")
        
        let expectation = self.expectation(description: "view update")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(mockDelegate.showIndicatorCalled, "showIndicator not called")
            XCTAssertTrue(mockDelegate.dismissIndicatorCalled, "dismissIndicator not called")
            XCTAssertTrue(mockDelegate.dismissErrorViewCalled, "dismissErrorView not called")
            XCTAssertTrue(mockDelegate.showErrorViewCalled, "showErrorView not called")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}
