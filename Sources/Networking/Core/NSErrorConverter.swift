//
//  NSErrorConverter.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/10/03.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

protocol NSErrorConverterType {
    func convert(from error: Error) -> NSError?
}

struct NSErrorConverter: NSErrorConverterType {

    static let shared = NSErrorConverter()

    func convert(from error: Error) -> NSError? {
        if let error = error as? NSErrorSerializable {
            var baseUserInfo = [String: Any]()
            baseUserInfo[NSLocalizedDescriptionKey] = error.errorDescription ?? "Unknown error."
            let mergedUserInfo = baseUserInfo.merging(error.userInfo) { $1 }

            return NSError(domain: PAYErrorDomain,
                           code: error.errorCode,
                           userInfo: mergedUserInfo)
        } else {
            return NSError(domain: PAYErrorDomain,
                           code: PAYErrorSystemError,
                           userInfo: [NSLocalizedDescriptionKey: error.localizedDescription])
        }
    }
}
