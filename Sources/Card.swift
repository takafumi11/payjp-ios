//
//  Card.swift
//  PAYJP
//
//  Created by k@binc.jp on 10/3/16.
//  Copyright © 2016 PAY, Inc. All rights reserved.
//
//  https://pay.jp/docs/api/#token-トークン
//
//

import Foundation

@objcMembers @objc(PAYCard) public final class Card: NSObject, Decodable {
    public let identifer: String
    public let name: String?
    public let last4Number: String
    public let brand: String
    public let expirationMonth: UInt8
    public let expirationYear: UInt16
    public let fingerprint: String
    public let liveMode: Bool
    public let createdAt: Date
    public var rawValue: [String: Any]?

    // MARK: - Decodable

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case last4Number = "last4"
        case brand
        case expirationMonth = "exp_month"
        case expirationYear = "exp_year"
        case fingerprint
        case liveMode = "livemode"
        case createdAt = "created"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        identifer = try container.decode(String.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        last4Number = try container.decode(String.self, forKey: .last4Number)
        brand = try container.decode(String.self, forKey: .brand)
        expirationMonth = try container.decode(UInt8.self, forKey: .expirationMonth)
        expirationYear = try container.decode(UInt16.self, forKey: .expirationYear)
        fingerprint = try container.decode(String.self, forKey: .fingerprint)
        liveMode = try container.decode(Bool.self, forKey: .liveMode)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
    }
}

public enum CardBrand: String, Codable {
    case visa = "Visa"
    case masterCard = "MasterCard"
    case JCB = "JCB"
    case amex = "American Express"
    case dinersClub = "Diners Club"
    case discover = "Discover"
    case unknown = ""

    func display() -> String {
        return String(describing: self).uppercased()
    }
}

extension CardBrand {
    static let allBrands = [visa, masterCard, JCB, amex, dinersClub, discover, unknown]

    var regex: String {
        switch self {
        case .visa:
            return "^4(?:[0-9]{0,15})$"
        case .masterCard:
            return "^(?:5[1-5]|2[2-7])[0-9]{0,14}$"
        case .JCB:
            return "^35(?:[0-9]{0,14})$"
        case .amex:
            return "^3(?:[47][0-9]{0,13})$"
        case .dinersClub:
            return "^3(?:[0689][0-9]{0,12})$"
        case .discover:
            return "^6(?:[0245][0-9]{0,14})$"
        default:
            return ""
        }
    }
}
