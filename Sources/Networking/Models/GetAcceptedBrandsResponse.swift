//
//  GetAcceptedBrandsResponse.swift
//  PAYJP
//
//  Created by Li-Hsuan Chen on 2019/07/26.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

struct GetAcceptedBrandsResponse: Decodable {
    /// 利用可能なブランドの配列
    let acceptedBrands: [CardBrand]
    /// livemodeかどうか
    let liveMode: Bool

    private enum CodingKeys: String, CodingKey {
        case acceptedBrands = "card_types_supported"
        case liveMode = "livemode"
    }
}
