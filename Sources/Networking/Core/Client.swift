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

class Client: ClientType {

    static let shared = Client()

    private let session: URLSession
    private let callbackQueue: CallbackQueue
    private let jsonDecoder: JSONDecoder

    private init(
        session: URLSession = URLSession(configuration: .default),
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
                        if let tdsId = self.findThreeDSecureId(response: response) {
                            completion?(Result.failure(.requiredThreeDSecure(tdsId)))
                        } else {
                            // TODO: tdsIdがない場合はエラーにする？
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
    func findThreeDSecureId(response: HTTPURLResponse) -> ThreeDSecureId? {
        if let location = response.allHeaderFields["Location"] as? String {
            if let url = URL(string: location) {
                let components = url.pathComponents
                let filters = components.filter { $0.starts(with: "tds_") }
                if let tdsId = filters.first {
                    return ThreeDSecureId(identifier: tdsId)
                }
            }
        }
        return nil
    }
}
