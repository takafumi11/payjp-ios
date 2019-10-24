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

/// PAY.JP API error response.
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

/// see PAYErrorResponseType.
@objcMembers @objc
public final class PAYErrorResponse: NSObject, PAYErrorResponseType, LocalizedError, Decodable {

    // MARK: - PAYErrorResponseType properties

    public let status: Int
    public let message: String?
    public let param: String?
    public let code: String?
    public let type: String?

    public override var description: String {
        // swiftlint:disable line_length
        return "status: \(status) message: \(message ?? "") param: \(param ?? "") code: \(code ?? "") type: \(type ?? "")"
        // swiftlint:enable line_length
    }

    public var errorDescription: String? { return description }
}
