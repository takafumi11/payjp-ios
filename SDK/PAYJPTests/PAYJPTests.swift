//
//  PAYJPTests.swift
//  PAYJPTests
//

import XCTest
@testable import PAYJP

class PAYJPTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInit() {
        let apiClient = APIClient(publicKey: "foo")
        XCTAssertEqual(apiClient.publicKey, "foo")
    }

    func testParametersToQueryItems() {
        let parameters = [
            "foo": "1",
            "bar": "2",
            "baz": "3",
        ]
        let apiClient = APIClient(publicKey: "foo")
        let queryItems = apiClient.parametersToQueryItems(parameters)
        XCTAssertEqual(queryItems.count, 3)
        for item in queryItems {
            switch item.name {
                case "foo":
                    XCTAssertEqual(item.value, "1")
                case "bar":
                    XCTAssertEqual(item.value, "2")
                case "baz":
                    XCTAssertEqual(item.value, "3")
                default:
                    break
            }
        }
    }

    func testBasicAuthCredentialWithUsername() {
        let apiClient = APIClient(publicKey: "foo")
        let credential = apiClient.basicAuthCredentialWithUsername()
        XCTAssertEqual(credential, "Basic Zm9vOg==")
    }
}
