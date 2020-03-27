//
//  ThreeDSecureToken.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2020/03/23.
//  Copyright © 2020 PAY, Inc. All rights reserved.
//

import Foundation

public struct ThreeDSecureToken {

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
        return tdsBaseUrl.appendingPathComponent("start")
    }

    var tdsFinishUrl: URL {
        return tdsBaseUrl.appendingPathComponent("finish")
    }
}
