//
//  ParametersSerialization.swift
//  PAYJP
//
//  Created by Li-Hsuan Chen on 2019/07/24.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

struct ParametersSerialization {
    static func string(from parameters: [String: Any]) -> String {
        let pairs = parameters.map { key, value -> String in
            if value is NSNull {
                return key
            }
            
            let valueString = (value as? String) ?? "\(value)"
            return "\(key)=\(valueString)"
        }
        
        return pairs.joined(separator: "&")
    }
}
