//
//  PAYJPTests.swift
//  PAYJPTests
//

import XCTest
import PassKit
@testable import PAYJP

class PAYJPTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCreateToken() {
        let apiClient = APIClient(publicKey: "foo")
        let token =  PKPaymentToken()
        apiClient.createToken(with: token) { result in
            switch result {
            case .success(let payToken):
                print(payToken)
                break
            default:
                print("")
            }
            
        }
    }
}
