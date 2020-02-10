//
//  BaseRequest.swift
//  PAYJP
//
//  Created by Li-Hsuan Chen on 2019/07/25.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

protocol BaseRequest: Request {}

extension BaseRequest {
    var baseUrl: URL { return URL(string: "https://api.pay.jp/v1")! }
    var headerFields: [String: String] {
        var fields = [String: String]()
        fields["Authorization"] = PAYJPSDK.authToken
        fields["User-Agent"] = PAYJPSDK.clientInfo.userAgent
        fields["X-Payjp-Client-User-Agent"] = PAYJPSDK.clientInfo.json
        fields["Locale"] = PAYJPSDK.locale?.languageCode
        return fields
    }
}
