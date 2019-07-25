//
//  Request.swift
//  PAYJP
//
//  Created by Li-Hsuan Chen on 2019/07/24.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

protocol Request {
    associatedtype Response
    
    var baseUrl: URL { get }
    var path: String { get }
    var queryParameters: [String: Any]?  { get }
    var bodyParameters: [String: String]?  { get } // Dealing with String content only
    var headerFields: [String: String] { get }
    var httpMethod: String { get }
    
    func response(data: Data, response: HTTPURLResponse) throws -> Response
}

enum RequestError: Error {
    case invalidBaseUrl
}

extension Request {
    
    var queryParameters: [String: Any]?  { return nil }
    var bodyParameters: [String: String]?  { return nil }
    var httpMethod: String { return "GET" }
    
    func buildUrlRequest() throws -> URLRequest {
        let url = path.isEmpty ? baseUrl : baseUrl.appendingPathComponent(path)
        var request = URLRequest(url: url)
        
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            throw RequestError.invalidBaseUrl
        }
        
        if let queryParameters = queryParameters, !queryParameters.isEmpty {
            components.percentEncodedQuery = ParametersSerialization.string(from: queryParameters)
        }
        
        let method = httpMethod.uppercased()
        
        if ["POST", "PUT", "PATCH"].contains(method), let bodyParameters = bodyParameters {
            let body = ParametersSerialization.string(from: bodyParameters)
            request.httpBody = body.data(using: .utf8)
        }
        
        headerFields.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        request.url = components.url
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        return request
    }
}

extension Request where Response: Decodable {
    func response(data: Data, response: HTTPURLResponse) throws -> Response {
        return try JSONDecoder.shared.decode(Response.self, from: data)
    }
}
