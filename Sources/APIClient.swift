//
//  PAY.JP APIClient.swift
//  https://pay.jp/docs/api/
//

import Foundation
import PassKit

@objc(PAYAPIClient) public class APIClient: NSObject {

    let accountsService: AccountsServiceType
    let tokensService: TokenServiceType

    @objc(sharedClient) public static let shared = APIClient()

    private init(accountsService: AccountsServiceType = AccountsService.shared,
                 tokensService: TokenServiceType = TokenService.shared) {
        self.accountsService = accountsService
        self.tokensService = tokensService
    }

    /// Create PAY.JP Token
    /// - parameter token:         ApplePay Token
    /// - parameter completion:    completion action
    @nonobjc
    public func createToken(with token: PKPaymentToken,
                            completion: @escaping (Result<Token, APIError>) -> Void) {
        tokensService.createTokenForApplePay(paymentToken: token, completion: completion)
    }

    /// Create PAY.JP Token
    /// - parameter cardNumber:         Credit card number `1234123412341234`
    /// - parameter cvc:                Credit card cvc e.g. `123`
    /// - parameter expirationMonth:    Credit card expiration month `01`
    /// - parameter expirationYear:     Credit card expiration year `2020`
    /// - parameter name:               Credit card holder name `TARO YAMADA`
    /// - parameter completion:         completion action
    @nonobjc
    public func createToken(with cardNumber: String,
                            cvc: String,
                            expirationMonth: String,
                            expirationYear: String,
                            name: String? = nil,
                            completion: @escaping (Result<Token, APIError>) -> Void) {
        tokensService.createToken(cardNumber: cardNumber,
                                  cvc: cvc,
                                  expirationMonth: expirationMonth,
                                  expirationYear: expirationYear,
                                  name: name,
                                  completion: completion)
    }

    /// GET PAY.JP Token
    /// - parameter tokenId:       identifier of the Token
    /// - parameter completion:    completion action
    @nonobjc
    public func getToken(with tokenId: String,
                         completion: @escaping (Result<Token, APIError>) -> Void) {
        tokensService.getToken(with: tokenId, completion: completion)
    }

    /// GET PAY.JP CardBrands
    /// - parameter tenantId:      identifier of the Tenant
    /// - parameter completion:    completion action
    @nonobjc
    public func getAcceptedBrands(with tenantId: String?,
                                  completion: CardBrandsResult?) {
        accountsService.getAcceptedBrands(tenantId: tenantId, completion: completion)
    }
}

// Objective-C API
extension APIClient {
    @objc public func createTokenWith(_ token: PKPaymentToken,
                                      completionHandler: @escaping (Token?, NSError?) -> Void) {
        tokensService.createTokenForApplePay(paymentToken: token) { result in
            switch result {
            case .success(let result):
                completionHandler(result, nil)
            case .failure(let error):
                completionHandler(nil, error.nsErrorValue())
            }
        }
    }

    @objc public func createTokenWith(_ cardNumber: String,
                                      cvc: String,
                                      expirationMonth: String,
                                      expirationYear: String,
                                      name: String?,
                                      completionHandler: @escaping (Token?, NSError?) -> Void) {
        tokensService.createToken(cardNumber: cardNumber, cvc: cvc, expirationMonth: expirationMonth, expirationYear: expirationYear, name: name) { result in
            switch result {
            case .success(let result):
                completionHandler(result, nil)
            case .failure(let error):
                completionHandler(nil, error.nsErrorValue())
            }
        }
    }

    @objc public func getTokenWith(_ tokenId: String,
                                   completionHandler: @escaping (Token?, NSError?) -> Void) {
        tokensService.getToken(with: tokenId) { result in
            switch result {
            case .success(let result):
                completionHandler(result, nil)
            case .failure(let error):
                completionHandler(nil, error.nsErrorValue())
            }
        }
    }

    @objc public func getAcceptedBrandsWith(_ tenantId: String?,
                                            completionHandler: @escaping ([NSString]?, NSError?) -> Void) {
        accountsService.getAcceptedBrands(tenantId: tenantId) { result in
            switch result {
            case .success(let result):
                let converted = result.map { (brand: CardBrand) -> NSString in return NSString(string: brand.rawValue) }
                completionHandler(converted, nil)
            case .failure(let error):
                completionHandler(nil, error.nsErrorValue())
            }
        }
    }
}
