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
        case PAYThreeDSecureStatus.unverified.rawValue:
            return PAYThreeDSecureStatus.unverified
        case PAYThreeDSecureStatus.verified.rawValue:
            return PAYThreeDSecureStatus.verified
        case PAYThreeDSecureStatus.failed.rawValue:
            return PAYThreeDSecureStatus.failed
        case PAYThreeDSecureStatus.attempted.rawValue:
            return PAYThreeDSecureStatus.attempted
        case PAYThreeDSecureStatus.aborted.rawValue:
            return PAYThreeDSecureStatus.aborted
        case PAYThreeDSecureStatus.error.rawValue:
            return PAYThreeDSecureStatus.error
        default:
            return nil
        }
    }
}
