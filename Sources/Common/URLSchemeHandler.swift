//
//  URLSchemeHandler.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2020/03/30.
//  Copyright © 2020 PAY, Inc. All rights reserved.
//

import Foundation
import SafariServices

public protocol URLSchemeHandlerType {
    var redirectCompleted: Bool? { get }

    func startThreeDSecureProcess()
    func completeThreeDSecureProcess(appScheme: String, completion: @escaping () -> Void) -> Bool
    func resetThreeDSecureProcess()
}

@objc(PAYJPURLSchemeHandler) @objcMembers
public class URLSchemeHandler: NSObject, URLSchemeHandlerType {

    @objc(sharedHandler)
    public static let shared = URLSchemeHandler()

    public var redirectCompleted: Bool?

    public func startThreeDSecureProcess() {
        redirectCompleted = false
    }

    public func completeThreeDSecureProcess(appScheme: String, completion: @escaping () -> Void) -> Bool {
        let topViewController = UIApplication.topViewController()
        if topViewController is SFSafariViewController {
            redirectCompleted = true
            topViewController?.dismiss(animated: true, completion: completion)
            return true
        }
        return false
    }

    public func resetThreeDSecureProcess() {
        redirectCompleted = nil
    }
}
