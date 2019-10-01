//
//  PAYJPSDK.swift
//  PAYJP
//
//  Created by Li-Hsuan Chen on 2019/07/24.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

protocol PAYJPSDKType: class {
    static var publicKey: String? { get set }
    static var locale: Locale? { get set }
}

@objc(PAYJPSDK) @objcMembers
public final class PAYJPSDK: NSObject, PAYJPSDKType {

    private override init() {}

    // MARK: - PAYJPSDKType

    public static var publicKey: String? {
        didSet {
            guard let publicKey = publicKey else {
                authToken = ""
                return
            }
            let data = "\(publicKey):".data(using: .utf8)!
            let base64String = data.base64EncodedString()
            authToken = "Basic \(base64String)"
        }
    }
    public static var locale: Locale?

    static var authToken: String = ""
}
