//
//  ClientInfoTests.swift
//  PAYJPTests
//
//  Created by Tatsuya Kitagawa on 2020/02/06.
//  Copyright © 2020 PAY, Inc. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import PAYJP

class ClientInfoTests: XCTestCase {

    func testCreate() {
        let clientInfo = ClientInfo.clientInfo()
        XCTAssertEqual(clientInfo.bindingsName, "jp.pay.ios")
        XCTAssertEqual(clientInfo.platform, "ios")
        XCTAssertEqual(clientInfo.bindingsPlugin, nil)
        XCTAssertEqual(clientInfo.publisher, "payjp")
    }

    func testCreate_plugin() {
        let clientInfo = ClientInfo.clientInfo(with: "jp.pay.kitagawa/1.0.0", publisher: "kitagawa")
        XCTAssertEqual(clientInfo.bindingsName, "jp.pay.ios")
        XCTAssertEqual(clientInfo.platform, "ios")
        XCTAssertEqual(clientInfo.bindingsPlugin, "jp.pay.kitagawa/1.0.0")
        XCTAssertEqual(clientInfo.publisher, "kitagawa")
    }

    func testBindingVersion() {
        let clientInfo = ClientInfo(
            bindingsName: "jp.pay.ios",
            bindingsVersion: "1.0.0",
            bindingsPlugin: nil,
            unameString: "iPhone X",
            platform: "ios",
            publisher: "payjp")
        XCTAssertEqual(clientInfo.bindingInfo, "jp.pay.ios/1.0.0")
    }

    func testBindingVersion_withPlugin() {
        let clientInfo = ClientInfo(
            bindingsName: "jp.pay.ios",
            bindingsVersion: "1.0.0",
            bindingsPlugin: "jp.pay.kitagawa/1.0.0",
            unameString: "iPhone X",
            platform: "ios",
            publisher: "payjp")
        XCTAssertEqual(clientInfo.bindingInfo, "jp.pay.ios/1.0.0@jp.pay.kitagawa/1.0.0")
    }

    func testUserAgent() {
        let clientInfo = ClientInfo(
        bindingsName: "jp.pay.ios",
        bindingsVersion: "1.0.0",
        bindingsPlugin: nil,
        unameString: "iPhone X",
        platform: "ios",
        publisher: "payjp")
        XCTAssertEqual(clientInfo.userAgent, "jp.pay.ios/1.0.0; iPhone X")
    }

    func testJson() {
        let clientInfo = ClientInfo(
        bindingsName: "jp.pay.ios",
        bindingsVersion: "1.1.0",
        bindingsPlugin: "jp.pay.kitagawa/1.0.0",
        unameString: "iPhoneX",
        platform: "ios",
        publisher: "payjp")
        XCTAssertNotNil(clientInfo.json)
    }
}
