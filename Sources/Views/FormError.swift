//
//  FormError.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/07/30.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

enum FormError: Error {
    case cardNumberEmptyError(value: CardNumber?, instant: Bool)
    case cardNumberInvalidError(value: CardNumber?, instant: Bool)
    case cardNumberInvalidBrandError(value: CardNumber?, instant: Bool)
    case expirationEmptyError(value: String?, instant: Bool)
    case expirationInvalidError(value: String?, instant: Bool)
    case cvcEmptyError(value: String?, instant: Bool)
    case cvcInvalidError(value: String?, instant: Bool)
    case cardHolderEmptyError(value: String?, instant: Bool)
}

extension FormError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .cardNumberEmptyError:
            return "payjp_card_form_error_no_number".localized
        case .cardNumberInvalidError:
            return "payjp_card_form_error_invalid_number".localized
        case .cardNumberInvalidBrandError:
            return "payjp_card_form_error_invalid_brand".localized
        case .expirationEmptyError:
            return "payjp_card_form_error_no_expiration".localized
        case .expirationInvalidError:
            return "payjp_card_form_error_invalid_expiration".localized
        case .cvcEmptyError:
            return "payjp_card_form_error_no_cvc".localized
        case .cvcInvalidError:
            return "payjp_card_form_error_invalid_cvc".localized
        case .cardHolderEmptyError:
            return "payjp_card_form_error_no_holder_name".localized
        }
    }
}
