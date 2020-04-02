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

class Client: NSObject, ClientType {

    static let shared = Client()

    private var session: URLSession?
    private let callbackQueue: CallbackQueue
    private let jsonDecoder: JSONDecoder

    private init(
        callbackQueue: CallbackQueue = CallbackQueue.dispatch(
        DispatchQueue(label: "jp.pay.ios", attributes: .concurrent)),
        jsonDecoder: JSONDecoder = JSONDecoder.shared
    ) {
        self.callbackQueue = callbackQueue
        self.jsonDecoder = jsonDecoder
    }

    private func getSession() -> URLSession {
        if session == nil {
            session = URLSession(configuration: .default,
                                 delegate: self,
                                 delegateQueue: nil)
        }
        return session!
    }

    @discardableResult
    func request<Request: PAYJP.Request>(
        with request: Request,
        completion: ((Result<Request.Response, APIError>) -> Void)?
    ) -> URLSessionDataTask? {
        do {
            let urlRequest = try request.buildUrlRequest()
            let dataTask = getSession().dataTask(with: urlRequest) { [weak self] data, response, error in
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
                        if let tdsToken = self.createThreeDSecureToken(data: data,
                                                                       request: request,
                                                                       response: response) {
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

    /// Response bodyから3DSecureのidを取り出してThreeDSecureTokenを生成する
    /// - Parameters:
    ///   - data: Data
    ///   - request: Request
    ///   - response: Response
    /// - Returns: ThreeDSecureToken
    func createThreeDSecureToken<Request: PAYJP.Request>(data: Data,
                                                         request: Request,
                                                         response: HTTPURLResponse) -> ThreeDSecureToken? {

        guard let url = response.url?.absoluteString else { return nil }
        guard url == "\(PAYJPApiEndpoint)tokens" else { return nil }
        guard request.httpMethod == "POST" else { return nil }

        let response = try? self.jsonDecoder.decode(PAYCommonResponse.self, from: data)
        if response?.object == "three_d_secure_token" {
            if let tdsId = response?.id {
                return ThreeDSecureToken(identifier: tdsId)
            }
        }
        return nil
    }
}

// MARK: URLSessionTaskDelegate
extension Client: URLSessionTaskDelegate {

    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    willPerformHTTPRedirection response: HTTPURLResponse,
                    newRequest request: URLRequest,
                    completionHandler: @escaping (URLRequest?) -> Void) {

        // 303のresponseが返されるようにリダイレクトのrequestはスルーする
        completionHandler(nil)
    }
}
