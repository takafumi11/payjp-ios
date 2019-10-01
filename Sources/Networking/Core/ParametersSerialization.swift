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
            return "\(escape(key))=\(escape(valueString))"
        }

        return pairs.joined(separator: "&")
    }

    private static func escape(_ string: String) -> String {
        return string.addingPercentEncoding(withAllowedCharacters: .payUrlQueryAllowed) ?? string
    }
}

extension CharacterSet {
    /// RFC 3986 Section 2.2, Section 3.4
    /// reserved    = gen-delims / sub-delims
    /// gen-delims  = ":" / "/" / "?" / "#" / "[" / "]" / "@"
    /// sub-delims  = "!" / "$" / "&" / "'" / "(" / ")" / "*" / "+" / "," / ";" / "="
    static let payUrlQueryAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // Remove "?" and "/" due to RFC3986, Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        let encodableDelimiters = CharacterSet(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return CharacterSet.urlQueryAllowed.subtracting(encodableDelimiters)
    }()
}
