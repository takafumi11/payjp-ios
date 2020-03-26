//
//  Client.swift
//  PAYJP
//
//  Created by Li-Hsuan Chen on 2019/07/24.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

protocol ClientType {
    func request<Request: PAYJP.Request>(
        with request: Request,
        completion: ((Result<Request.Response, APIError>) -> Void)?
    ) -> URLSessionDataTask?
}

class InterceptRedirectDelegate: NSObject, URLSessionTaskDelegate {

    static let shared = InterceptRedirectDelegate()

    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    willPerformHTTPRedirection response: HTTPURLResponse,
                    newRequest request: URLRequest,
                    completionHandler: @escaping (URLRequest?) -> Void) {

        // 303のresponseが返されるようにリダイレクトのrequestはスルーする
        completionHandler(nil)
    }
}

class Client: ClientType {

    static let shared = Client()

    private let session: URLSession
    private let callbackQueue: CallbackQueue
    private let jsonDecoder: JSONDecoder

    private init(
        session: URLSession = URLSession(configuration: .default,
                                         delegate: InterceptRedirectDelegate.shared,
                                         delegateQueue: nil),
        callbackQueue: CallbackQueue = CallbackQueue.dispatch(
        DispatchQueue(label: "jp.pay.ios", attributes: .concurrent)),
        jsonDecoder: JSONDecoder = JSONDecoder.shared
    ) {
        self.session = session
        self.callbackQueue = callbackQueue
        self.jsonDecoder = jsonDecoder
    }

    @discardableResult
    func request<Request: PAYJP.Request>(
        with request: Request,
        completion: ((Result<Request.Response, APIError>) -> Void)?
    ) -> URLSessionDataTask? {
        do {
            let urlRequest = try request.buildUrlRequest()
            let dataTask = self.session.dataTask(with: urlRequest) { [weak self] data, response, error in
                guard let self = self else { return }

                if error != nil && data == nil && response == nil {
                    completion?(Result.failure(.systemError(error!)))
                    return
                }

                guard let response = response as? HTTPURLResponse else {
                    completion?(Result.failure(.invalidResponse(nil)))
                    return
                }

                guard let data = data else {
                    completion?(Result.failure(.invalidResponse(response)))
                    return
                }

                guard error != nil else {
                    if response.statusCode == 200 {
                        do {
                            let result = try request.response(data: data, response: response)
                            completion?(Result.success(result))
                        } catch {
                            completion?(Result.failure(.invalidJSON(data, error)))
                        }
                    } else if response.statusCode == 303 {
                        if let tdsToken = self.createThreeDSecureToken(response: response) {
                            completion?(Result.failure(.requiredThreeDSecure(tdsToken)))
                        } else {
                            completion?(Result.failure(.invalidResponse(response)))
                        }
                    } else {
                        do {
                            let error = try self.jsonDecoder.decode(PAYErrorResult.self, from: data).error
                            completion?(Result.failure(.serviceError(error)))
                        } catch {
                            completion?(Result.failure(.invalidJSON(data, error)))
                        }
                    }
                    return
                }
            }

            self.callbackQueue.execute { dataTask.resume() }
            return dataTask
        } catch {
            completion?(Result.failure(.systemError(error)))
            return nil
        }
    }

    /// Locationヘッダからtds_idを取得する
    /// - Parameter response: HTTPURLResponse
    /// - Returns: ThreeDSecureToken
    func createThreeDSecureToken(response: HTTPURLResponse) -> ThreeDSecureToken? {
        if let location = response.allHeaderFields["Location"] as? String,
            let url = URL(string: location) {
            let pattern = "^/v1/tds/([\\w\\d_]+)/.*$"
            if let tdsId = url.path.capture(pattern: pattern, group: 1) {
                return ThreeDSecureToken(identifier: tdsId)
            }
        }
        return nil
    }
}
