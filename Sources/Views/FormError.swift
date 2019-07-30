//
//  FormError.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/07/30.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

enum FormError<T>: Error {
    case error(value: T?, message: String)
    case instantError(value: T?, message: String)
}
