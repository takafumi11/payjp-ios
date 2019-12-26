//
//  CardVerificationViewController.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/12/24.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import UIKit
import WebKit

public class CardVerificationViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!

    private var webView: WKWebView!
    private var expectedReturnURLPatterns: [URLComponents] = []
    private var tokenId: String?
    private var verifyCompleted: Bool = false

    private weak var delegate: CardVerificationViewControllerDelegate?

    // TODO: 消す debug用
    @IBAction func debugDoneTapped(_ sender: Any) {
        delegate?.cardVarificationViewController(self, didVerified: tokenId)
    }

    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else {return}
            self.delegate?.cardVarificationViewControllerDidCancel(self)
        }
    }

    public static func createCardVerificationViewController(tokenId: String,
                                                            delegate: CardVerificationViewControllerDelegate) -> CardVerificationViewController {
        let stotyboard = UIStoryboard(name: "CardVerification", bundle: Bundle(for: PAYJPSDK.self))
        let naviVc = stotyboard.instantiateInitialViewController() as? UINavigationController
        guard
            let verifyVc = naviVc?.topViewController as? CardVerificationViewController
            else { fatalError("Couldn't instantiate CardVerificationViewController") }
        verifyVc.tokenId = tokenId
        verifyVc.delegate = delegate
        return verifyVc
    }

    // MARK: Lifecycle

    override public func loadView() {
        super.loadView()

        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: CGRect(x: 0,
                                          y: 0,
                                          width: self.view.frame.width,
                                          height: self.view.frame.height),
                            configuration: webConfiguration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(webView)
        NSLayoutConstraint.activate([webView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                                     webView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                                     webView.topAnchor.constraint(equalTo: containerView.topAnchor),
                                     webView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)])
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self
        guard let url = URL(string: "https://www.apple.com") else { fatalError() }
        let request = URLRequest(url: url)
        webView.load(request)
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if isMovingFromParent && !verifyCompleted {
            delegate?.cardVarificationViewControllerDidCancel(self)
        }
    }

    // MARK: Private

    private func checkVerificationURL(_ url: URL) -> Bool {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return false
        }

        return expectedReturnURLPatterns.contains(where: { expectedURLComponents -> Bool in
            return expectedURLComponents.scheme == components.scheme &&
                expectedURLComponents.host == components.host &&
                components.path.hasPrefix(expectedURLComponents.path)
        })
    }
}

// MARK: WKNavigationDelegate
extension CardVerificationViewController: WKNavigationDelegate {

    public func webView(_ webView: WKWebView,
                        decidePolicyFor navigationAction: WKNavigationAction,
                        decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {

        print(debug: "request url => \(navigationAction.request.url)")

        if let url = navigationAction.request.url, checkVerificationURL(url) {
            decisionHandler(.cancel)
            verifyCompleted = true
            delegate?.cardVarificationViewController(self, didVerified: tokenId)
        } else {
            decisionHandler(.allow)
            verifyCompleted = false
        }
    }
}

// MARK: UIAdaptivePresentationControllerDelegate
extension CardVerificationViewController: UIAdaptivePresentationControllerDelegate {

    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        delegate?.cardVarificationViewControllerDidCancel(self)
    }
}
