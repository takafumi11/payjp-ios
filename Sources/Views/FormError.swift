//
//  FormError.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/07/30.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

enum FormError: Error {
    case cardNumberEmptyError(value: CardNumber?, isInstant: Bool)
    case cardNumberInvalidError(value: CardNumber?, isInstant: Bool)
    case cardNumberInvalidBrandError(value: CardNumber?, isInstant: Bool)
    case expirationEmptyError(value: String?, isInstant: Bool)
    case expirationInvalidError(value: String?, isInstant: Bool)
    case cvcEmptyError(value: String?, isInstant: Bool)
    case cvcInvalidError(value: String?, isInstant: Bool)
    case cardHolderEmptyError(value: String?, isInstant: Bool)
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
