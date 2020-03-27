//
//  ThreeDSecureToken.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2020/03/23.
//  Copyright © 2020 PAY, Inc. All rights reserved.
//

import Foundation

public class ThreeDSecureToken: NSObject {

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
        components.queryItems = [URLQueryItem(name: "publickey", value: PAYJPSDK.publicKey),
                                 URLQueryItem(name: "redirect_url", value: PAYJPSDK.tdsRedirectURLKey)]
        return components.url!
    }

    var tdsFinishUrl: URL {
        return tdsBaseUrl.appendingPathComponent("finish")
    }
}
