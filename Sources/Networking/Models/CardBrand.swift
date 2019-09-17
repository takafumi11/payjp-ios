//
//  CardBrand.swift
//  PAYJP
//
//  Created by Li-Hsuan Chen on 2019/07/26.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

public enum CardBrand: String, Codable {
    case visa = "Visa"
    case mastercard = "MasterCard"
    case jcb = "JCB"
    case americanExpress = "American Express"
    case dinersClub = "Diners Club"
    case discover = "Discover"
    case unknown = "Unknown"

    func display() -> String {
        return String(describing: self).uppercased()
    }
}

extension CardBrand {
    static let allBrands = [visa, mastercard, jcb, americanExpress, dinersClub, discover]

    var regex: String {
        switch self {
        case .visa:
            return "^4(?:[0-9]{0,})$"
        case .mastercard:
            return "^(?:5[1-5]|2[2-7])[0-9]{0,}$"
        case .jcb:
            return "^35(?:[0-9]{0,})$"
        case .americanExpress:
            return "^3(?:[47][0-9]{0,})$"
        case .dinersClub:
            return "^3(?:[0689][0-9]{0,})$"
        case .discover:
            return "^6(?:[0245][0-9]{0,})$"
        case .unknown:
            return ""
        }
    }

    var numberLength: Int {
        switch self {
        case .americanExpress:
            return 15
        case .dinersClub:
            return 14
        default:
            return 16
        }
    }

    var cvcLength: Int {
        switch self {
        case .americanExpress, .unknown:
            return 4
        default:
            return 3
        }
    }

    var logoResourceName: String {
        switch self {
        case .visa:
            return "logo_visa"
        case .mastercard:
            return "logo_master"
        case .jcb:
            return "logo_jcb"
        case .americanExpress:
            return "logo_amex"
        case .dinersClub:
            return "logo_diners"
        case .discover:
            return "logo_discover"
        case .unknown:
            return "icon_card"
        }
    }

    var cvcIconResourceName: String {
        switch self {
        case .americanExpress, .unknown:
            return "icon_card_cvc_4"
        default:
            return "icon_card_cvc_3"
        }
    }
}
