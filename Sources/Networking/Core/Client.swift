//
//  Client.swift
//  PAYJP
//
//  Created by Li-Hsuan Chen on 2019/07/24.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

protocol ClientType {
    func request<Request: PAYJP.Request>(with request: Request, completion: ((Result<Request.Response, Error>) -> Void)?) -> URLSessionDataTask?
}

private var taskRequestKey = 0

public class Client: ClientType {
    
    let shared = Client()
    
    private let session: URLSession
    private let callbackQueue: CallbackQueue
    private let jsonDecoder: JSONDecoder
    
    private init(session: URLSession = URLSession(configuration: .default),
                 callbackQueue: CallbackQueue = CallbackQueue.dispatch(DispatchQueue(label: "jp.pay.ios", attributes: .concurrent)),
                 jsonDecoder: JSONDecoder = JSONDecoder.shared) {
        self.session = session
        self.callbackQueue = callbackQueue
        self.jsonDecoder = jsonDecoder
    }
    
    @discardableResult
    func request<Request: PAYJP.Request>(with request: Request, completion: ((Result<Request.Response, Error>) -> Void)?) -> URLSessionDataTask? {
        do {
            let urlRequest = try request.buildUrlRequest()
            let dataTask = self.session.dataTask(with: urlRequest) { [weak self] data, response, error in
                guard let self = self else { return }
                
                if error != nil && data == nil && response == nil {
                    completion?(Result.failure(APIError.systemError(error!)))
                }
                
                guard let response = response as? HTTPURLResponse else {
                    completion?(Result.failure(APIError.invalidResponse(nil)))
                    return
                }
                
                guard let data = data else {
                    completion?(Result.failure(APIError.invalidResponse(response)))
                    return
                }
            
                guard error != nil else {
                    if response.statusCode == 200 {
                        do {
                            let result = try request.response(data: data, response: response)
                            completion?(Result.success(result))
                        } catch {
                            completion?(Result.failure(APIError.invalidJSON(data, error)))
                        }
                    } else {
                        completion?(Result.failure(APIError.invalidResponse(response)))
                    }
                    return
                }
                
                do {
                    let error = try self.jsonDecoder.decode(PAYErrorResult.self, from: data).error
                    completion?(Result.failure(error))
                    return
                } catch {
                    completion?(Result.failure(APIError.invalidJSON(data, error)))
                    return
                }
            }
            
            self.callbackQueue.execute { dataTask.resume() }
            return dataTask
        } catch {
            completion?(Result.failure(error))
            return nil
        }
    }
    
    private func setRequest<Request: PAYJP.Request>(_ request: Request, forTask task: URLSessionDataTask) {
        objc_setAssociatedObject(task, &taskRequestKey, request, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
