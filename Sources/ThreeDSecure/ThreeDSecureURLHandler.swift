//
//  ThreeDSecureURLHandler.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2020/03/30.
//  Copyright © 2020 PAY, Inc. All rights reserved.
//

import Foundation
import SafariServices

/// Handler for using URL in 3DSecure process
public protocol ThreeDSecureURLHandlerType {
    /// Complete flag for redirected from web
    var redirectCompleted: Bool? { get }

    /// Start 3DSecure prpcess
    func startThreeDSecureProcess()
    /// Complete 3DSecure prpcess
    /// - Parameters:
    ///   - url: redirect URL
    ///   - completion: completion for dismiss SFSafariViewController
    func completeThreeDSecureProcess(url: URL, completion: @escaping () -> Void) -> Bool
    /// Reset 3DSecure prpcess
    func resetThreeDSecureProcess()
}

@objc(PAYJPThreeDSecureURLHandler) @objcMembers
public class ThreeDSecureURLHandler: NSObject, ThreeDSecureURLHandlerType {

    @objc(sharedHandler)
    public static let shared = ThreeDSecureURLHandler()

    public var redirectCompleted: Bool?

    public func startThreeDSecureProcess() {
        redirectCompleted = false
    }

    public func completeThreeDSecureProcess(url: URL, completion: @escaping () -> Void) -> Bool {
        print(debug: "tds redirect url => \(url)")

        if let redirectUrl = PAYJPSDK.threeDSecureURLConfiguration?.redirectURL {
            if url.absoluteString.starts(with: redirectUrl) {
                let topViewController = UIApplication.topViewController()
                if topViewController is SFSafariViewController {
                    redirectCompleted = true
                    topViewController?.dismiss(animated: true, completion: completion)
                    return true
                }
            }
        }
        return false
    }

    public func resetThreeDSecureProcess() {
        redirectCompleted = nil
    }
}
