//
//  ThreeDSecureWebDriver.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2020/04/06.
//  Copyright © 2020 PAY, Inc. All rights reserved.
//

import Foundation
import SafariServices

/// Web browse driver for 3DSecure.
public protocol ThreeDSecureWebDriver {
    
    /// Open web browser with SFSafariViewController.
    /// - Parameters:
    ///   - host: host ViewController
    ///   - url: load url
    ///   - delegate: SFSafariViewControllerDelegate
    func openWebBrowser(host: UIViewController, url: URL, delegate: SFSafariViewControllerDelegate)
    
    /// Close web browser.
    /// - Parameters:
    ///   - host: host ViewController
    ///   - completion: completion action after dismiss SFSafariViewController
    func closeWebBrowser(host: UIViewController?, completion: (() -> Void)?) -> Bool
}

/// see ThreeDSecureWebDriver.
public class ThreeDSecureSFSafariViewControllerDriver: ThreeDSecureWebDriver {
    
    /// Shared instance.
    public static let shared = ThreeDSecureSFSafariViewControllerDriver()
    
    public func openWebBrowser(host: UIViewController, url: URL, delegate: SFSafariViewControllerDelegate) {
        let safariVc = SFSafariViewController(url: url)
        if #available(iOS 11.0, *) {
            safariVc.dismissButtonStyle = .close
        }
        safariVc.delegate = delegate
        host.present(safariVc, animated: true, completion: nil)
    }
    
    public func closeWebBrowser(host: UIViewController?, completion: (() -> Void)?) -> Bool {
        if host is SFSafariViewController {
            host?.dismiss(animated: true) {
                completion?()
            }
            return true
        }
        return false
    }
}
