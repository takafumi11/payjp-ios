//
//  ThreeDSecureProcessHandler.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2020/03/30.
//  Copyright © 2020 PAY, Inc. All rights reserved.
//

import Foundation
import SafariServices

/// 3DSecure process status.
@objc public enum ThreeDSecureProcessStatus: Int {
    /// when 3DSecure process is completed.
    case completed
    /// when 3DSecure process is cancel.
    case cancel
}

/// 3DSecure handler delegate.
public protocol ThreeDSecureProcessHandlerDelegate: class {

    /// Tells the delegate that 3DSecure process is finished.
    /// - Parameters:
    ///   - handler: ThreeDSecureProcessHandler
    ///   - status: ThreeDSecureProcessStatus
    func threeDSecureProcessHandlerDidFinish(_ handler: ThreeDSecureProcessHandler,
                                             status: ThreeDSecureProcessStatus)
}

/// Handler for 3DSecure process.
public protocol ThreeDSecureProcessHandlerType {

    /// Start 3DSecure process.
    /// - Parameters:
    ///   - viewController: the viewController which will present SFSafariViewController.
    ///   - delegate: ThreeDSecureProcessHandlerDelegate
    ///   - token: ThreeDSecureToken
    func startThreeDSecureProcess(viewController: UIViewController,
                                  delegate: ThreeDSecureProcessHandlerDelegate,
                                  token: ThreeDSecureToken)
    /// Complete 3DSecure process.
    /// - Parameters:
    ///   - url: redirect URL
    ///   - completion: completion for dismiss SFSafariViewController
    func completeThreeDSecureProcess(url: URL, completion: (() -> Void)?) -> Bool
}

/// see ThreeDSecureProcessHandlerType.
@objc(PAYJPThreeDSecureProcessHandler) @objcMembers
public class ThreeDSecureProcessHandler: NSObject, ThreeDSecureProcessHandlerType {

    /// Shared instance.
    @objc(sharedHandler)
    public static let shared = ThreeDSecureProcessHandler()

    private weak var delegate: ThreeDSecureProcessHandlerDelegate?

    // MARK: ThreeDSecureProcessHandlerType

    public func startThreeDSecureProcess(viewController: UIViewController,
                                         delegate: ThreeDSecureProcessHandlerDelegate,
                                         token: ThreeDSecureToken) {

        let safariVc = SFSafariViewController(url: token.tdsEntryUrl)
        if #available(iOS 11.0, *) {
            safariVc.dismissButtonStyle = .close
        }
        safariVc.delegate = self
        viewController.present(safariVc, animated: true, completion: nil)
        self.delegate = delegate
    }

    public func completeThreeDSecureProcess(url: URL, completion: (() -> Void)? = nil) -> Bool {
        print(debug: "tds redirect url => \(url)")

        if let redirectUrl = PAYJPSDK.threeDSecureURLConfiguration?.redirectURL {
            if url.absoluteString.starts(with: redirectUrl.absoluteString) {
                let topViewController = UIApplication.topViewController()
                if topViewController is SFSafariViewController {
                    topViewController?.dismiss(animated: true) { [weak self] in
                        guard let self = self else { return }
                        self.delegate?.threeDSecureProcessHandlerDidFinish(self, status: .completed)
                        self.delegate = nil
                        completion?()
                    }
                    return true
                }
            }
        }
        return false
    }
}

// MARK: SFSafariViewControllerDelegate
extension ThreeDSecureProcessHandler: SFSafariViewControllerDelegate {

    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        delegate?.threeDSecureProcessHandlerDidFinish(self, status: .cancel)
    }
}
