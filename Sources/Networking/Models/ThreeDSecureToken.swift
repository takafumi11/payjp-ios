//
//  ThreeDSecureToken.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2020/03/23.
//  Copyright © 2020 PAY, Inc. All rights reserved.
//

import Foundation

/// 3DSecure token object.
/// used for 3DSecure verification.
public class ThreeDSecureToken: NSObject {
    /// Identifier.
    public let identifier: String

    init(identifier: String) {
        self.identifier = identifier
    }
}

extension ThreeDSecureToken {

    private var tdsBaseUrl: URL {
        return URL(string: "\(PAYJPApiEndpoint)tds/\(identifier)")!
    }

    var tdsEntryUrl: URL {
        let url = tdsBaseUrl.appendingPathComponent("start")
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        components.queryItems = [
            URLQueryItem(name: "publickey", value: PAYJPSDK.publicKey),
            URLQueryItem(name: "back", value: PAYJPSDK.threeDSecureURLConfiguration?.redirectURLKey)
        ]
        return components.url!
    }

    var tdsFinishUrl: URL {
        return tdsBaseUrl.appendingPathComponent("finish")
    }
}
