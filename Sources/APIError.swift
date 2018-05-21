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
        case .serviceError(let error):
            return error.message
        default:
            return ""
        }
    }
}
