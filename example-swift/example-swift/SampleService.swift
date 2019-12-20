//
//  SampleService.swift
//  example-swift
//
//  Created by Tadashi Wakayanagi on 2019/11/26.
//

import Foundation

// TODO: REPLACE WITH YOUR ENDPOINT URL
private let BACKEND_URL = ""
private let API_PATH = "/save_card"

enum SampleError: LocalizedError {
    case unexpected

    var errorDescription: String? {
        switch self {
        case .unexpected:
            return "予期しない問題が発生しました"
        }
    }
}

struct SampleService {

    static let shared = SampleService()

    func saveCard(withToken token: String, completion: @escaping (Error?) -> Void) {
        if BACKEND_URL.isEmpty {
            completion(nil)
            return
        }

        do {
            let dict = ["card": token]
            let data = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let urlString = BACKEND_URL + API_PATH
            let request = NSMutableURLRequest(url: URL(string: urlString)!)
            request.cachePolicy = .reloadIgnoringLocalCacheData
            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = data

            let configuration = URLSessionConfiguration.ephemeral
            let session = URLSession(configuration: configuration)
            let dataTask = session.dataTask(with: request as URLRequest) { (_, response, error) in
                if let httpResponse = response as? HTTPURLResponse {
                    print("Status code: \(httpResponse.statusCode)")

                    if httpResponse.statusCode == 201 {
                        print("SampleService Success.")
                        completion(nil)
                    } else {
                        if let error = error {
                            print("SampleService Error => \(error)")
                            completion(error)
                        } else {
                            print("SampleService Error other.")
                            completion(SampleError.unexpected)
                        }
                    }
                }
            }
            dataTask.resume()
        } catch {
            print("Error: \(error)")
        }
    }
}
