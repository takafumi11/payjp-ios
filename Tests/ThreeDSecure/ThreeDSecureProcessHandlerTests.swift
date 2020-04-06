//
//  ThreeDSecureProcessHandlerTests.swift
//  PAYJPTests
//
//  Created by Tadashi Wakayanagi on 2020/04/03.
//  Copyright © 2020 PAY, Inc. All rights reserved.
//

import XCTest
import SafariServices
@testable import PAYJP

class ThreeDSecureProcessHandlerTests: XCTestCase {

    func testStartThreeDSecureProcess() {
        let mockDriver = MockWebDriver()
        let handler = ThreeDSecureProcessHandler(webDriver: mockDriver)
        let token = ThreeDSecureToken(identifier: "tds_xxx")
        let mockVC = MockViewController()
        
        handler.startThreeDSecureProcess(viewController: mockVC,
                                         delegate: mockVC,
                                         token: token)
        
        XCTAssertEqual(mockDriver.openWebBrowserUrl?.absoluteString, token.tdsEntryUrl.absoluteString)
    }
    
    func testCompleteThreeDSecureProcess() {
        PAYJPSDK.threeDSecureURLConfiguration = ThreeDSecureURLConfiguration(redirectURL: URL(string: "test://")!,
                                                                             redirectURLKey: "test")
        
        let mockDriver = MockWebDriver(isSafariVC: true)
        let handler = ThreeDSecureProcessHandler(webDriver: mockDriver)
        let token = ThreeDSecureToken(identifier: "tds_xxx")
        let mockVC = MockViewController()
        let url = URL(string: "test://")!
        
        handler.startThreeDSecureProcess(viewController: mockVC,
        delegate: mockVC,
        token: token)
        
        let result = handler.completeThreeDSecureProcess(url: url)
        
        XCTAssertTrue(result)
        XCTAssertEqual(mockVC.tdsStatus, ThreeDSecureProcessStatus.completed)
    }
    
    func testCompleteThreeDSecureProcess_invalidUrl() {
        PAYJPSDK.threeDSecureURLConfiguration = ThreeDSecureURLConfiguration(redirectURL: URL(string: "test://")!,
                                                                             redirectURLKey: "test")
        
        let mockDriver = MockWebDriver(isSafariVC: true)
        let handler = ThreeDSecureProcessHandler(webDriver: mockDriver)
        let token = ThreeDSecureToken(identifier: "tds_xxx")
        let mockVC = MockViewController()
        let url = URL(string: "unknown://")!
        
        handler.startThreeDSecureProcess(viewController: mockVC,
        delegate: mockVC,
        token: token)
        
        let result = handler.completeThreeDSecureProcess(url: url)
        
        XCTAssertFalse(result)
        XCTAssertNil(mockVC.tdsStatus)
    }
    
    func testCompleteThreeDSecureProcess_notSafariVC() {
        PAYJPSDK.threeDSecureURLConfiguration = ThreeDSecureURLConfiguration(redirectURL: URL(string: "test://")!,
                                                                             redirectURLKey: "test")
        
        let mockDriver = MockWebDriver(isSafariVC: false)
        let handler = ThreeDSecureProcessHandler(webDriver: mockDriver)
        let token = ThreeDSecureToken(identifier: "tds_xxx")
        let mockVC = MockViewController()
        let url = URL(string: "test://")!
        
        handler.startThreeDSecureProcess(viewController: mockVC,
        delegate: mockVC,
        token: token)
        
        let result = handler.completeThreeDSecureProcess(url: url)
        
        XCTAssertFalse(result)
        XCTAssertNil(mockVC.tdsStatus)
    }
}
