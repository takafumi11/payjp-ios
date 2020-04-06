//
//  Mock.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2020/04/06.
//  Copyright © 2020 PAY, Inc. All rights reserved.
//

import SafariServices

class MockViewController: UIViewController {
    var tdsStatus: ThreeDSecureProcessStatus?
    var presentedVC: UIViewController?
    
    override func present(_ viewControllerToPresent: UIViewController,
                          animated flag: Bool,
                          completion: (() -> Void)? = nil) {
        presentedVC = viewControllerToPresent
    }
}

extension MockViewController: ThreeDSecureProcessHandlerDelegate {
    func threeDSecureProcessHandlerDidFinish(_ handler: ThreeDSecureProcessHandler,
                                             status: ThreeDSecureProcessStatus) {
        tdsStatus = status
    }
}

class MockSafariViewController: SFSafariViewController {
    var dismissCalled: Bool = false
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        dismissCalled = true
        completion?()
    }
}

class MockSafariDelegateImpl: NSObject, SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {}
}

class MockWebDriver: ThreeDSecureWebDriver {
    var openWebBrowserUrl: URL?
    var isSafariVC: Bool = false
    
    init(isSafariVC: Bool = false) {
        self.isSafariVC = isSafariVC
    }
    
    func openWebBrowser(host: UIViewController, url: URL, delegate: SFSafariViewControllerDelegate) {
        openWebBrowserUrl = url
    }
    
    func closeWebBrowser(host: UIViewController?, completion: (() -> Void)?) -> Bool {
        if isSafariVC {
            completion?()
            return true
        }
        return false
    }
}
