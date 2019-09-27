//
//  APIClientTests.swift
//  PAYJPTests
//

import XCTest
import PassKit
import OHHTTPStubs
@testable import PAYJP

class APIClientTests: XCTestCase {
    override func setUp() {
        super.setUp()
        stub(condition: { (req) -> Bool in
            req.url?.host == "api.pay.jp" && req.url?.path.starts(with: "/v1/tokens") ?? false
        }) { (req) -> OHHTTPStubsResponse in
            let data = TestFixture.JSON(by: "token.json")
            return OHHTTPStubsResponse(data: data, statusCode: 200, headers: nil)
        }.name = "default"
    }
    
    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    func testCreateToken_withPKPaymentToken() {
        PAYJPSDK.publicKey = "pk_test_d5b6d618c26b898d5ed4253c"
        let apiClient = APIClient.shared
        
        let expectation = self.expectation(description: self.description)
        
        apiClient.createToken(with: StubPaymentToken()) { result in
            switch result {
            case .success(let payToken):
                let json = TestFixture.JSON(by: "token.json")
                let decoder = JSONDecoder.shared
                let token = try! decoder.decode(Token.self, from: json)
                
                XCTAssertEqual(payToken, token)
                expectation.fulfill()
                break
            default:
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testCreateToken_withCardInput() {
        OHHTTPStubs.removeAllStubs()
        stub(condition: { (req) -> Bool in
            // check request
            if let body = req.ohhttpStubs_httpBody {
                let bodyString = String(data: body, encoding: String.Encoding.utf8)
                let body = bodyString?.split(separator: "&").map(String.init).reduce([String: String]()) { original, string -> [String: String] in
                    var result = original
                    let pair = string.split(separator: "=").map(String.init)
                    result[pair[0]] = pair[1]
                    print(string)
                    return result
                }
                
                XCTAssertEqual(body?["card%5Bnumber%5D"], "4242424242424242")
                XCTAssertEqual(body?["card%5Bcvc%5D"], "123")
                XCTAssertEqual(body?["card%5Bexp_month%5D"], "02")
                XCTAssertEqual(body?["card%5Bexp_year%5D"], "2020")
                XCTAssertEqual(body?["card%5Bname%5D"], "TARO%20YAMADA")
                return true
            }
            return false
        }) { (req) -> OHHTTPStubsResponse in
            OHHTTPStubsResponse(data: TestFixture.JSON(by: "token.json"), statusCode: 200, headers: nil)
            }
        
        PAYJPSDK.publicKey = "pk_test_d5b6d618c26b898d5ed4253c"
        let apiClient = APIClient.shared

        let expectation = self.expectation(description: self.description)
        
        apiClient.createToken(with: "4242424242424242",
                              cvc: "123",
                              expirationMonth: "02",
                              expirationYear: "2020",
                              name: "TARO YAMADA")
        { result in
            switch result {
            case .success(let payToken):
                let json = TestFixture.JSON(by: "token.json")
                let decoder = JSONDecoder.shared
                let token = try! decoder.decode(Token.self, from: json)
                
                XCTAssertEqual(payToken, token)
                expectation.fulfill()
                break
            default:
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testGetToken() {
        PAYJPSDK.publicKey = "pk_test_d5b6d618c26b898d5ed4253c"
        let apiClient = APIClient.shared
        
        let expectation = self.expectation(description: self.description)
        
        apiClient.getToken(with: "tok_eff34b780cbebd61e87f09ecc9c6") { result in
            switch result {
            case .success(let payToken):
                let json = TestFixture.JSON(by: "token.json")
                let decoder = JSONDecoder.shared
                let token = try! decoder.decode(Token.self, from: json)
                
                XCTAssertEqual(payToken, token)
                expectation.fulfill()
                break
            default:
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testGetAcceptedBrands() {
        PAYJPSDK.publicKey = "pk_test_d5b6d618c26b898d5ed4253c"
        let apiClient = APIClient.shared
        
        let expectation = self.expectation(description: self.description)
        
        apiClient.getAcceptedBrands(with: "tenand_id") { result in
            switch result {
            case .success(let brands):
                let json = TestFixture.JSON(by: "cardBrands.json")
                let decoder = JSONDecoder.shared
                let response = try! decoder.decode(GetAcceptedBrandsResponse.self, from: json)
                
                XCTAssertEqual(brands, response.acceptedBrands)
                expectation.fulfill()
                break
            default:
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}
