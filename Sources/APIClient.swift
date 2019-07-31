//
//  PAY.JP APIClient.swift
//  https://pay.jp/docs/api/
//

import Foundation
import PassKit

@objc(PAYAPIClient) public class APIClient: NSObject {
//    /// Able to set the locale of the error messages. We provide messages in Japanese and English. Default is nil.
//    @objc public var locale: Locale?
//
//    private let publicKey: String
//    private let baseURL: String = "https://api.pay.jp/v1"
//
//    private lazy var authCredential: String = {
//        let credentialData = "\(self.publicKey):".data(using: .utf8)!
//        let base64Credential = credentialData.base64EncodedString()
//        return "Basic \(base64Credential)"
//    }()
//
//    private let decoder: JSONDecoder = .shared
//
//    @objc public init(publicKey: String) {
//        self.publicKey = publicKey
//    }
    
//    public typealias APIResponse = Result<Token, APIError>
//
    
    let accountsService: AccountsServiceType
    let tokensService: TokenServiceType
    
    public static let shared = APIClient()
    
    private init(accountsService: AccountsServiceType = AccountsService.shared,
                 tokensService: TokenServiceType = TokenService.shared) {
        self.accountsService = accountsService
        self.tokensService = tokensService
    }
    
    /// Create PAY.JP Token
    /// - parameter token: ApplePay Token
    public func createToken(with token: PKPaymentToken,
                            completion: @escaping (Result<Token, APIError>) -> ()) {
    }

    /// Create PAY.JP Token
    /// - parameter cardNumber:         Credit card number `1234123412341234`
    /// - parameter cvc:                Credit card cvc e.g. `123`
    /// - parameter expirationMonth:    Credit card expiration month `01`
    /// - parameter expirationYear:     Credit card expiration year `2020`
    /// - parameter name:               Credit card holder name `TARO YAMADA`
    public func createToken(with cardNumber: String,
                            cvc: String,
                            expirationMonth: String,
                            expirationYear: String,
                            name: String? = nil,
                            completion: @escaping (Result<Token, APIError>) -> ()) {
    }

    /// GET PAY.JP Token
    /// - parameter tokenId:    identifier of the Token
    public func getToken(with tokenId: String,
                         completion: @escaping (Result<Token, APIError>) -> ()) {
    }
}

// Objective-C API
extension APIClient {
    @objc public func createTokenWith(_ token: PKPaymentToken,
                                      completion: @escaping (NSError?, Token?) -> ()) {
    }

    @objc public func createTokenWith(_ cardNumber: String,
                                      cvc: String,
                                      expirationMonth: String,
                                      expirationYear: String,
                                      name: String?,
                                      completion: @escaping (NSError?, Token?) -> ()) {
    }

    @objc public func getTokenWith(_ tokenId: String,
                                   completionHandler: @escaping (NSError?, Token?) -> ()) {
    }
}
