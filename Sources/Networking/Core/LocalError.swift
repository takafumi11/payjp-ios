//
//  BaseError.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/10/01.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

/// Local error types.
public enum LocalError: LocalizedError, NSErrorSerializable {
    /// Invalid form input.
    case invalidFormInput

    // MARK: - LocalizedError

    public var errorDescription: String? {
        switch self {
        case .invalidFormInput:
            return "Form input data is invalid."
        }
    }

    public var errorCode: Int {
        switch self {
        case .invalidFormInput:
            return PAYErrorFormInvalid
        }
    }
}
