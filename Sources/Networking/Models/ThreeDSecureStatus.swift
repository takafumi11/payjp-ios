//
//  ThreeDSecureStatus.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/12/25.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

/// 3D Secure verification status.
public enum ThreeDSecureStatus: String {
    case verified
    case attempted
    case unverified

    public var rawValue: String {
        switch self {
        case .verified:
            return PAYThreeDSecureStatus.verified.rawValue
        case .attempted:
            return PAYThreeDSecureStatus.attempted.rawValue
        case .unverified:
            return PAYThreeDSecureStatus.unverified.rawValue
        }
    }
}
