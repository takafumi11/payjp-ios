//
//  ThreeDSecureURLConfiguration.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2020/03/31.
//

import Foundation

@objcMembers @objc(PAYThreeDSecureURLConfiguration)
public class ThreeDSecureURLConfiguration: NSObject {
    let redirectURL: String
    let redirectURLKey: String

    public init(redirectURL: String, redirectURLKey: String) {
        self.redirectURL = redirectURL
        self.redirectURLKey = redirectURLKey
    }
}
