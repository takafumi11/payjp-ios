//
//  APIError.swift
//  PAYJP
//
//  Created by k@binc.jp on 10/4/16.
//  Copyright © 2016 BASE, Inc. All rights reserved.
//

import Foundation
import PassKit

public enum APIError: LocalizedError {
    /// The Apple Pay token is invalid.
    case invalidApplePayToken(PKPaymentToken)
    /// The system error.
    case systemError(Error)
    /// No body data or no response error.
    case invalidResponse(HTTPURLResponse?)
    /// The content of response body is not a valid JSON.
    case invalidResponseBody(Data)
    /// The error came back from server side.
    case serviceError(PAYErrorType)
    /// Invalid JSON object.
    case invalidJSON(Any)
    
    // MARK: - LocalizedError
    
    public var errorDescription: String? {
        switch self {
        case .invalidApplePayToken(_):
            return "Invalid Apple Pay Token"
        case .systemError(let error):
            return error.localizedDescription
        case .invalidResponse(_):
            return "The response is not a HTTPURLResponse instance."
        case .invalidResponseBody(_):
            return "The response body's data is not a valid JSON object."
        case .serviceError(let error):
            return error.message
        case .invalidJSON(_):
            return "Unable parse JSON object into expected classes."
        }
    }
    
    // MARK: - NSError helper
    
    public func nsErrorValue()-> NSError? {
        var userInfo = [String: Any]()
        userInfo[NSLocalizedDescriptionKey] = self.errorDescription ?? "Unknown error."
        
        switch self {
        case .invalidApplePayToken(let token):
            userInfo[PAYErrorInvalidApplePayTokenObject] = token
            return NSError(domain: PAYErrorDomain,
                           code: PAYErrorServiceError,
                           userInfo: userInfo)
        case .systemError(let error):
            userInfo[PAYErrorSystemErrorObject] = error
            return NSError(domain: PAYErrorDomain,
                           code: PAYErrorSystemError,
                           userInfo: userInfo)
        case .invalidResponse(let response):
            userInfo[PAYErrorInvalidResponseObject] = response
            return NSError(domain: PAYErrorDomain,
                           code: PAYErrorInvalidResponse,
                           userInfo: userInfo)
        case .invalidResponseBody(let data):
            userInfo[PAYErrorInvalidResponseData] = data
            return NSError(domain: PAYErrorDomain,
                           code: PAYErrorInvalidResponseBody,
                           userInfo: userInfo)
        case .serviceError(let error):
            userInfo[PAYErrorServiceErrorObject] = error
            return NSError(domain: PAYErrorDomain,
                           code: PAYErrorServiceError,
                           userInfo: userInfo)
        case .invalidJSON(let json):
            userInfo[PAYErrorInvalidJSONObject] = json
            return NSError(domain: PAYErrorDomain,
                           code: PAYErrorInvalidJSON,
                           userInfo: userInfo)
        }
    }
}
