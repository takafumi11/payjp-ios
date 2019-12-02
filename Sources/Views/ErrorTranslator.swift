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
                switch response.status {
                case 402:
                    return response.message ?? "payjp_card_form_screen_error_unknown".localized
                case 500..<600:
                    return "payjp_card_form_screen_error_server".localized
                default:
                    return "payjp_card_form_screen_error_application".localized
                }
            case .systemError(let error):
                return error.localizedDescription
            default:
                return "payjp_card_form_screen_error_unknown".localized
            }
        }
        return error.localizedDescription
    }
}
