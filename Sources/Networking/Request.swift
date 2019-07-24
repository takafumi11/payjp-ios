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
    var httpMethod: String { get }
    
    func response(data: Data, response: HTTPURLResponse) throws -> Response
}

enum RequestError: Error {
    case invalidBaseUrl
}

extension Request {
    
    var queryParameters: [String: Any]?  { return [:] }
    var httpMethod: String { return "GET" }
    
    func buildUrlRequest() throws -> URLRequest {
        let url = path.isEmpty ? baseUrl : baseUrl.appendingPathComponent(path)
        var request = URLRequest(url: url)
        
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            throw RequestError.invalidBaseUrl
        }
        
        if let queryParameters = queryParameters, !queryParameters.isEmpty {
            components.percentEncodedQuery = QuerySerialization.string(from: queryParameters)
        }
        
        request.url = components.url
        request.httpMethod = httpMethod.uppercased()
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        return request
    }
}

extension Request where Response: Decodable {
    func response(data: Data, response: HTTPURLResponse) throws -> Response {
        return try JSONDecoder.shared.decode(Response.self, from: data)
    }
}
