//
//  ThreeDSecureURLConfiguration.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2020/03/31.
//

import Foundation

@objcMembers @objc(PAYThreeDSecureURLConfiguration)
public class ThreeDSecureURLConfiguration: NSObject {
    let appScheme: String
    let redirectURL: String
    let redirectURLKey: String

    public init(appScheme: String, url: String, urlKey: String) {
        self.appScheme = appScheme
        self.redirectURL = url
        self.redirectURLKey = urlKey
    }
}
