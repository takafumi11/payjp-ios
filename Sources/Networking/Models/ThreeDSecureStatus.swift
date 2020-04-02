//
//  ThreeDSecureStatus.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/12/25.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

/// 3D Secure verification status.
public enum ThreeDSecureStatus: String, Codable {
    case verified
    case attempted
    case unverified
}

@objc public enum ThreeDSecureStatusObjc: Int {
    case verified
    case attempted
    case unverified

    func value() -> String {
        switch self {
        case .verified: return "verified"
        case .attempted: return "attempted"
        case .unverified: return "unverified"
        }
    }
}
