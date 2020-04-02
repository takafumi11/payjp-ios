//
//  ThreeDSecureStatus.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2020/04/02.
//

import Foundation

class ThreeDSecureStatus {

    static func find(rawValue: String) -> PAYThreeDSecureStatus? {
        switch rawValue {
        case PAYThreeDSecureStatus.verified.rawValue:
            return PAYThreeDSecureStatus.verified
        case PAYThreeDSecureStatus.attempted.rawValue:
            return PAYThreeDSecureStatus.attempted
        case PAYThreeDSecureStatus.unverified.rawValue:
            return PAYThreeDSecureStatus.unverified
        default:
            return nil
        }
    }
}
