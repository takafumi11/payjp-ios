//
//  APIError.swift
//  PAYJP
//
//  Created by k@binc.jp on 10/4/16.
//  Copyright © 2016 BASE, Inc. All rights reserved.
//

import Foundation
import PassKit

public enum APIError: Error {
    case invalidApplePayToken(PKPaymentToken)
    case errorResponse(Error)
    case invalidResponse(HTTPURLResponse?)
    case invalidResponseBody(Data)
    case errorJSON(Any)
    case invalidJSON(Any)
}
