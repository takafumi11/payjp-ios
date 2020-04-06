//
//  ThreeDSecureSFSafariViewControllerDriverTests.swift
//  PAYJPTests
//
//  Created by Tadashi Wakayanagi on 2020/04/06.
//  Copyright © 2020 PAY, Inc. All rights reserved.
//

import XCTest
import SafariServices
@testable import PAYJP

class ThreeDSecureSFSafariViewControllerDriverTests: XCTestCase {
        
    func testOpenWebBrowser() {
        let driver = ThreeDSecureSFSafariViewControllerDriver()
        let mockVC = MockViewController()
        let mockDelegate = MockSafariDelegateImpl()
        let url = URL(string: "https://test")!
        
        driver.openWebBrowser(host: mockVC, url: url, delegate: mockDelegate)
        
        XCTAssertTrue(mockVC.presentedVC is SFSafariViewController)
    }
    
    func testCloseWebBrowser() {
        let driver = ThreeDSecureSFSafariViewControllerDriver()
        let mockVC = MockSafariViewController(url: URL(string: "https://test")!)
        
        let result = driver.closeWebBrowser(host: mockVC, completion: nil)
        
        XCTAssertTrue(result)
        XCTAssertTrue(mockVC.dismissCalled)
    }
    
    func testCloseWebBrowser_notSafariVC() {
        let driver = ThreeDSecureSFSafariViewControllerDriver()
        let mockVC = MockViewController()
        
        let result = driver.closeWebBrowser(host: mockVC, completion: nil)
        
        XCTAssertFalse(result)
    }
}
