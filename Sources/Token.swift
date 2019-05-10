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
    public var rawValue: [String: Any]?
    
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
    }
}

extension Token {
    
    /**
     * Provide a factory function to decode json by JSONDecoder
     * and also desereialize all fields as a arbitrary dictionary by JSONSerialization.
     */
    static func decodeJson(with data: Data, using decoder: JSONDecoder) throws -> Token {
        let token = try decoder.decode(Token.self, from: data)
        // assign rawValue by JSONSerialization
        guard let rawValue = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any],
            let cardRawValue = rawValue["card"] as? [String: Any] else {
                let context = DecodingError.Context(codingPath: [],
                                                    debugDescription: "Cannot deserialize rawValue")
                throw DecodingError.dataCorrupted(context)
        }
        token.rawValue = rawValue
        token.card.rawValue = cardRawValue
        return token
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
