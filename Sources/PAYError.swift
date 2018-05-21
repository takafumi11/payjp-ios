//
//  PAYError.swift
//  PAYJP
//
//  Created by Li-Hsuan Chen on 2018/05/21.
//

import Foundation

@objc
public protocol PAYErrorType {
    /// The origin reponse's HTTP status code.
    var status: Int { get }
    /// The detail message of the error.
    var message: String? { get }
    /// The param that caused the error happend.
    var param: String? { get }
    /// The code of the error. Check https://pay.jp/docs/api/#error for more details.
    var code: String? { get }
    /// The type of the error. Check https://pay.jp/docs/api/#error for more details.
    var type: String? { get }
}

@objcMembers @objc
public final class PAYError: NSObject, PAYErrorType {
    
    // MARK: - PAYErrorType properties
    
    public let status: Int
    public let message: String?
    public let param: String?
    public let code: String?
    public let type: String?
    
    // MARK: - Decodable
    
    init(_ e: Extractor) {
        status = (try? e <| "status") ?? 0
        message = try? e <| "message"
        param = try? e <| "param"
        code = try? e <| "code"
        type = try? e <| "type"
    }
}

extension PAYError: Decodable {
    public static func decode(_ e: Extractor) throws -> Self {
        return try castOrFail(PAYError(e))
    }
}
