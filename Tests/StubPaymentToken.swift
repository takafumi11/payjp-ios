//
//  StubPaymentToken.swift
//  PAYJP
//
//  Created by Li-Hsuan Chen on 2019/07/31.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation
import PassKit

class StubPaymentToken: PKPaymentToken {
    override var paymentData: Data {
        let data = TestFixture.JSON(by: "paymentData.json")
        let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments)
        return try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
    }
}
