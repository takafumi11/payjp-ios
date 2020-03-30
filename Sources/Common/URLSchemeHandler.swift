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
    
    func finishThreeDSecureProcess(appScheme: String, completion: @escaping () -> Void) -> Bool
}

@objc(PAYJPURLSchemeHandler) @objcMembers
public class URLSchemeHandler: NSObject, URLSchemeHandlerType {
    
    @objc(sharedHandler)
    public static let shared = URLSchemeHandler()

    public func finishThreeDSecureProcess(appScheme: String, completion: @escaping () -> Void) -> Bool {

        let topViewController = UIApplication.topViewController()
        if topViewController is SFSafariViewController {
            topViewController?.dismiss(animated: true, completion: completion)
            return true
        }
        
        return false
    }
}
