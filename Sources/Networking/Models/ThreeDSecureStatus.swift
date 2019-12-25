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
    case attempt
    case unverified
}
