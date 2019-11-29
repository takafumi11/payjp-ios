//
//  ErrorTranslator.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/11/29.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

protocol ErrorTranslatorType {
    func translate(error: Error) -> String
}

struct ErrorTranslator: ErrorTranslatorType {

    static let shared = ErrorTranslator()

    func translate(error: Error) -> String {
        if let apiError = error as? APIError {
            switch apiError {
            case .serviceError(let response):
                if response.status == 402 {
                    return response.message ?? "問題が発生しました。"
                } else if (500...600 ~= response.status) {
                    return "サーバーに接続できません。\n時間をあけて再度お試しください。"
                } else {
                    return "アプリケーションに問題が発生しました。"
                }
            case .systemError:
                return "通信に失敗しました。\nネットワークの接続をご確認ください。"
            default:
                return "問題が発生しました。"
            }
        }
        return error.localizedDescription
    }
}
