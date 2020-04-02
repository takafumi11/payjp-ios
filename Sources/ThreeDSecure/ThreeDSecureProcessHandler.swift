//
//  ThreeDSecureProcessHandler.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2020/03/30.
//  Copyright © 2020 PAY, Inc. All rights reserved.
//

import Foundation
import SafariServices

/// 3DSecure process status
@objc public enum ThreeDSecureProcessStatus: Int {
    /// when 3DSecure process is starting
    case processing
    /// when 3DSecure process is finished
    case completed
    /// when 3DSecure process is not starting
    case none
}

/// Handler for 3DSecure process
public protocol ThreeDSecureProcessHandlerType {
    /// 3DSecure process status
    var status: ThreeDSecureProcessStatus { get }

    /// Start 3DSecure prpcess
    func startThreeDSecureProcess()
    /// Complete 3DSecure prpcess
    /// - Parameters:
    ///   - url: redirect URL
    ///   - completion: completion for dismiss SFSafariViewController
    func completeThreeDSecureProcess(url: URL, completion: (() -> Void)?) -> Bool
    /// Reset 3DSecure prpcess
    func resetThreeDSecureProcess()
}

@objc(PAYJPThreeDSecureProcessHandler) @objcMembers
public class ThreeDSecureProcessHandler: NSObject, ThreeDSecureProcessHandlerType {

    @objc(sharedHandler)
    public static let shared = ThreeDSecureProcessHandler()

    public var status: ThreeDSecureProcessStatus = .none

    public func startThreeDSecureProcess() {
        status = .processing
    }

    public func completeThreeDSecureProcess(url: URL, completion: (() -> Void)? = nil) -> Bool {
        print(debug: "tds redirect url => \(url)")

        if let redirectUrl = PAYJPSDK.threeDSecureURLConfiguration?.redirectURL {
            if url.absoluteString.starts(with: redirectUrl.absoluteString) {
                let topViewController = UIApplication.topViewController()
                if topViewController is SFSafariViewController {
                    status = .completed
                    topViewController?.dismiss(animated: true, completion: completion)
                    return true
                }
            }
        }
        return false
    }

    public func resetThreeDSecureProcess() {
        status = .none
    }
}
