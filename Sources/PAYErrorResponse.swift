//
//  PAYErrorResponse.swift
//  PAYJP
//
//  Created by Li-Hsuan Chen on 2018/05/21.
//

import Foundation

@objc
public protocol PAYErrorResponseType: NSObjectProtocol {
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
public final class PAYErrorResponse: NSObject, PAYErrorResponseType, Decodable {
    
    // MARK: - PAYErrorResponseType properties
    
    public let status: Int
    public let message: String?
    public let param: String?
    public let code: String?
    public let type: String?
    
    // MARK: - Decodable
    
    private enum CodingKeys: String, CodingKey {
        case error
    }
    
    private enum ErrorKeys: String, CodingKey {
        case status
        case message
        case param
        case code
        case type
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let error = try container.nestedContainer(keyedBy: ErrorKeys.self, forKey: .error)
        status = try error.decodeIfPresent(Int.self, forKey: .status) ?? 0
        message = try error.decode(String.self, forKey: .message)
        param = try error.decode(String.self, forKey: .param)
        code = try error.decode(String.self, forKey: .code)
        type = try error.decode(String.self, forKey: .type)
    }
    
    public override var description: String {
        return "status: \(status) message: \(message ?? "") param: \(param ?? "") code: \(code ?? "") type: \(type ?? "")"
    }
}
