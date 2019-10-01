//
//  APIError.swift
//  PAYJP
//
//  Created by k@binc.jp on 10/4/16.
//  Copyright © 2016 PAY, Inc. All rights reserved.
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
    /// The error response object that is coming back from the server side.
    case serviceError(PAYErrorResponseType)
    /// Invalid JSON object.
    case invalidJSON(Data, Error?)
    /// Invalid Form input.
    case invalidFormInput
    
    // MARK: - LocalizedError
    
    public var errorDescription: String? {
        switch self {
        case .invalidApplePayToken(_):
            return "Invalid Apple Pay Token"
        case .systemError(let error):
            return error.localizedDescription
        case .invalidResponse(_):
            return "The response is not a HTTPURLResponse instance."
        case .serviceError(let errorResponse):
            return errorResponse.message
        case .invalidJSON(_):
            return "Unable parse JSON object into expected classes."
        case .invalidFormInput:
            return "Form input data is invalid."
        }
    }
    
    // MARK: - NSError helper
    
    public func nsErrorValue()-> APINSError? {
        var userInfo = [String: Any]()
        userInfo[NSLocalizedDescriptionKey] = self.errorDescription ?? "Unknown error."
        
        switch self {
        case .invalidApplePayToken(let token):
            userInfo[PAYErrorInvalidApplePayTokenObject] = token
            return APINSError(domain: PAYErrorDomain,
                              code: PAYErrorInvalidApplePayToken,
                              userInfo: userInfo)
        case .systemError(let error):
            userInfo[PAYErrorSystemErrorObject] = error
            return APINSError(domain: PAYErrorDomain,
                              code: PAYErrorSystemError,
                              userInfo: userInfo)
        case .invalidResponse(let response):
            userInfo[PAYErrorInvalidResponseObject] = response
            return APINSError(domain: PAYErrorDomain,
                              code: PAYErrorInvalidResponse,
                              userInfo: userInfo)
        case .serviceError(let errorResponse):
            userInfo[PAYErrorServiceErrorObject] = errorResponse
            return APINSError(domain: PAYErrorDomain,
                              code: PAYErrorServiceError,
                              userInfo: userInfo)
        case .invalidJSON(let json, let error):
            userInfo[PAYErrorInvalidJSONObject] = json
            if (error != nil) {
                userInfo[PAYErrorInvalidJSONErrorObject] = error
            }
            return APINSError(domain: PAYErrorDomain,
                              code: PAYErrorInvalidJSON,
                              userInfo: userInfo)
        case .invalidFormInput:
            return APINSError(domain: PAYErrorDomain,
                              code: PAYErrorFormInvalid,
                              userInfo: nil)
        }
    }
    
    /// Returns error response object if the type is `.serviceError`.
    public var payError: PAYErrorResponseType? {
        switch self {
        case .serviceError(let errorResponse):
            return errorResponse
        default:
            return nil
        }
    }
}

@objcMembers @objc(APIError)
public class APINSError: NSError {
    /// Returns error response object if the type is `.serviceError`.
    public var payError: PAYErrorResponseType? {
        if domain == PAYErrorDomain && code == PAYErrorServiceError {
            return userInfo[PAYErrorServiceErrorObject] as? PAYErrorResponseType
        }
        
        return nil
    }
}
