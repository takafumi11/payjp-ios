//
//  ThreeDSecureURLConfiguration.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2020/03/31.
//

import Foundation

/// Configuration for using URL in 3DSecure process
@objcMembers @objc(PAYThreeDSecureURLConfiguration)
public class ThreeDSecureURLConfiguration: NSObject {
    /// Redirect URL for launching app from web
    let redirectURL: String
    /// Redirect URL key
    let redirectURLKey: String

    public init(redirectURL: String, redirectURLKey: String) {
        self.redirectURL = redirectURL
        self.redirectURLKey = redirectURLKey
    }
}
