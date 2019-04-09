//
//  Token.swift
//  PAYJP
//
//  Created by k@binc.jp on 9/29/16.
//  Copyright © 2016 PAY, Inc. All rights reserved.
//
//  https://pay.jp/docs/api/#token-トークン
//

import Foundation

@objcMembers @objc(PAYToken) public final class Token: NSObject, Decodable {
    public let identifer: String
    public let livemode: Bool
    public let used: Bool
    public let card: Card
    public let createdAt: Date
//    public let rawValue: String
    
    // MARK: - Decodable
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case livemode
        case used
        case card
        case createdAt = "created"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        identifer = try container.decode(String.self, forKey: .id)
        livemode = try container.decode(Bool.self, forKey: .livemode)
        used = try container.decode(Bool.self, forKey: .used)
        card = try container.decode(Card.self, forKey: .card)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
//        rawValue = try decoder.singleValueContainer().decode(String.self)
    }
}

extension Token {
    public override func isEqual(_ object: Any?) -> Bool {
        if let object = object as? Token {
            return self.identifer == object.identifer
        }
        
        return false
    }
}
