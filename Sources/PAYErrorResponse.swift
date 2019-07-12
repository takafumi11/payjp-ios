//
//  PAYErrorResponse.swift
//  PAYJP
//
//  Created by Li-Hsuan Chen on 2018/05/21.
//

import Foundation

struct PAYErrorResult: Decodable {
    let error: PAYErrorResponse
}

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
    
    public override var description: String {
        return "status: \(status) message: \(message ?? "") param: \(param ?? "") code: \(code ?? "") type: \(type ?? "")"
    }
}
