//
//  CardBrand.swift
//  PAYJP
//
//  Created by Li-Hsuan Chen on 2019/07/26.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

/// Card brand types.
public enum CardBrand: String, Codable {
    /// VISA.
    case visa = "Visa"
    /// MasterCard.
    case mastercard = "MasterCard"
    /// JCB.
    case jcb = "JCB"
    /// American Express.
    case americanExpress = "American Express"
    /// Diners Club.
    case dinersClub = "Diners Club"
    /// Discover.
    case discover = "Discover"
    /// Unknown brand.
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
            return "^4[0-9]*$"
        case .mastercard:
            return "^(?:5[1-5]|2[2-7])[0-9]*$"
        case .jcb:
            return "^(?:352[8-9]|35[3-8])[0-9]*$"
        case .americanExpress:
            return "^3[47][0-9]*$"
        case .dinersClub:
            return "^3(?:0[0-5]|[68])[0-9]*$"
        case .discover:
            return "^6(?:011|5)[0-9]*$"
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

    private var logoResourceName: String {
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

    var logoImage: UIImage? {
        return UIImage(named: self.logoResourceName, in: .payjpBundle, compatibleWith: nil)
    }

    private var cvcIconResourceName: String {
        switch self {
        case .americanExpress:
            return "icon_card_cvc_4"
        default:
            return "icon_card_cvc_3"
        }
    }

    var cvcIconImage: UIImage? {
        return UIImage(named: self.cvcIconResourceName, in: .payjpBundle, compatibleWith: nil)
    }

    private var displayLogoResourceName: String? {
        switch self {
        case .visa:
            return "visa"
        case .mastercard:
            return "mastercard"
        case .jcb:
            return "jcb"
        case .americanExpress:
            return "amex"
        case .dinersClub:
            return "diners"
        case .discover:
            return "discover"
        case .unknown:
            return nil
        }
    }

    var displayLogoImage: UIImage? {
        if let resource = self.displayLogoResourceName {
            return UIImage(named: resource, in: .payjpBundle, compatibleWith: nil)
        }
        return nil
    }
}
