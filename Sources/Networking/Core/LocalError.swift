//
//  BaseError.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/10/01.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

public enum LocalError: NSErrorCompatible {
    /// Invalid Form input.
    case invalidFormInput

    // MARK: - LocalizedError

    public var errorDescription: String? {
        switch self {
        case .invalidFormInput:
            return "Form input data is invalid."
        }
    }

    // MARK: - NSError helper

    public func nsErrorValue() -> NSError? {
        var userInfo = [String: Any]()
        userInfo[NSLocalizedDescriptionKey] = self.errorDescription ?? "Unknown error."

        switch self {
        case .invalidFormInput:
            return APINSError(domain: PAYErrorDomain,
                              code: PAYErrorFormInvalid,
                              userInfo: userInfo)
        }
    }
}
