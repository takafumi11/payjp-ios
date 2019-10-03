//
//  APIError.swift
//  PAYJP
//
//  Created by k@binc.jp on 10/4/16.
//  Copyright © 2016 PAY, Inc. All rights reserved.
//

import Foundation
import PassKit

protocol NSErrorSerializable: Error {
    associatedtype TypedError: NSError
    var errorCode: Int { get }
    var errorDescription: String? { get }
    var userInfo: [String: Any] { get }
    var addUserInfo: [String: Any] { get }
}

extension NSErrorSerializable {
    public var userInfo: [String: Any] {
        var userInfo = [String: Any]()
        userInfo[NSLocalizedDescriptionKey] = self.errorDescription ?? "Unknown error."
        return userInfo.merging(self.addUserInfo) { $1 }
    }
    
    public var addUserInfo: [String: Any] {
        return [String: Any]()
    }

    public func nsErrorValue() -> TypedError? {
        guard let convertible = self as? NSErrorCastable else {
            return nil
        }
        return convertible.nsErrorValue()
    }
}

protocol NSErrorCastable {
    func nsErrorValue<T>() -> T?
}

protocol PAYError: NSErrorSerializable, NSErrorCastable {
    func nsErrorValue() -> TypedError?
}

extension PAYError {
    func nsErrorValue<T>() -> T {
        return TypedError(domain: PAYErrorDomain,
                          code: self.errorCode,
                          userInfo: self.userInfo) as! T
    }
}

public enum APIError: LocalizedError, PAYError {
    public typealias TypedError = APINSError
    // The Apple Pay token is invalid.
    case invalidApplePayToken(PKPaymentToken)
    /// The system error.
    case systemError(Error)
    /// No body data or no response error.
    case invalidResponse(HTTPURLResponse?)
    /// The error response object that is coming back from the server side.
    case serviceError(PAYErrorResponseType)
    /// Invalid JSON object.
    case invalidJSON(Data, Error?)
    
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
        }
    }

    public var errorCode: Int {
        switch self {
        case .invalidApplePayToken(_):
            return PAYErrorInvalidApplePayToken
        case .systemError(_):
            return PAYErrorSystemError
        case .invalidResponse(_):
            return PAYErrorInvalidResponse
        case .serviceError(_):
            return PAYErrorServiceError
        case .invalidJSON(_):
            return PAYErrorInvalidJSON
        }
    }

    public var addUserInfo: [String: Any] {
        var userInfo = [String: Any]()
        switch self {
        case .invalidApplePayToken(let token):
            userInfo[PAYErrorInvalidApplePayTokenObject] = token
        case .systemError(let error):
            userInfo[PAYErrorSystemErrorObject] = error
        case .invalidResponse(let response):
            userInfo[PAYErrorInvalidResponseObject] = response
        case .serviceError(let errorResponse):
            userInfo[PAYErrorServiceErrorObject] = errorResponse
        case .invalidJSON(let json, let error):
            userInfo[PAYErrorInvalidJSONObject] = json
            if (error != nil) {
                userInfo[PAYErrorInvalidJSONErrorObject] = error
            }
        }
        return userInfo
    }

    // MARK: - NSError helper

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
