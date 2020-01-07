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
    @IBOutlet weak var errorView: ErrorView!

    private var webView: WKWebView!
    private var progressView: UIProgressView!
    private var token: Token?
    private var verifyCompleted: Bool = false
    private var estimatedProgressObservation: NSKeyValueObservation?
    private var originalEntryUrl: URL?

    private weak var delegate: CardVerificationViewControllerDelegate?

    // TODO: 消す debug用
    @IBAction func debugDoneTapped(_ sender: Any) {
        delegate?.cardVarificationViewController(self, didVerified: token?.identifer)
    }

    @IBAction func reloadTapped(_ sender: Any) {
        if webView.url != nil {
            webView.reload()
        } else {
            if let original = originalEntryUrl {
                webView.load(URLRequest(url: original))
            }
        }
    }

    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else {return}
            self.delegate?.cardVarificationViewControllerDidCancel(self)
        }
    }

    public static func createCardVerificationViewController(token: Token,
                                                            delegate: CardVerificationViewControllerDelegate)
        -> CardVerificationViewController {
            let stotyboard = UIStoryboard(name: "CardVerification", bundle: Bundle(for: PAYJPSDK.self))
            let naviVc = stotyboard.instantiateInitialViewController() as? UINavigationController
            guard
                let verifyVc = naviVc?.topViewController as? CardVerificationViewController
                else { fatalError("Couldn't instantiate CardVerificationViewController") }
            verifyVc.token = token
            verifyVc.delegate = delegate
            return verifyVc
    }

    // MARK: Lifecycle

    override public func loadView() {
        super.loadView()

        setupViews()
        setupWebViewObserver()
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "payjp_card_verification_title".localized
        webView.navigationDelegate = self

        if let card = token?.card, let entryUrl = card.tdsEntryUrl {
            originalEntryUrl = entryUrl
            var request = URLRequest(url: entryUrl)
            request.setValue(PAYJPSDK.authToken, forHTTPHeaderField: "Authorization")
            webView.load(request)
        }
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if isMovingFromParent && !verifyCompleted {
            delegate?.cardVarificationViewControllerDidCancel(self)
        }
    }

    // MARK: Private

    private func setupViews() {
        // WebView
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

        // ProgressView
        if let naviBarHeight = self.navigationController?.navigationBar.frame.size.height {
            progressView = UIProgressView(frame: CGRect(x: 0.0,
                                                        y: naviBarHeight - 3.0,
                                                        width: self.view.frame.size.width,
                                                        height: 3.0))
            progressView.progressViewStyle = .bar
            self.navigationController?.navigationBar.addSubview(progressView)
        }
    }

    private func setupWebViewObserver() {
        estimatedProgressObservation = webView.observe(\.estimatedProgress,
                                                       options: [.new],
                                                       changeHandler: { [weak self] (webView, change) in
                                                        guard let self = self else { return }
                                                        self.progressView.alpha = 1.0
                                                        self.progressView.setProgress(Float(change.newValue!),
                                                                                      animated: true)

                                                        if self.webView.estimatedProgress >= 1.0 {
                                                            UIView.animate(withDuration: 0.3,
                                                                           delay: 0.3,
                                                                           options: [.curveEaseOut],
                                                                           animations: { [weak self] in
                                                                            guard let self = self else { return }
                                                                            self.progressView.alpha = 0.0
                                                                }, completion: { [weak self] _ in
                                                                    guard let self = self else { return }
                                                                    self.progressView.setProgress(0.0, animated: false)
                                                            })
                                                        }
        })
    }

    private func checkVerificationFinished(url: URL?) -> Bool {
        if let loadUrl = url?.absoluteString, let expectedUrl = token?.card.tdsFinishUrl?.absoluteString {
            print(debugMessage: "loadedUrl \(loadUrl)")
            print(debugMessage: "expectedUrl \(expectedUrl)")
            return loadUrl == expectedUrl
        }
        return false
    }
}

// MARK: WKNavigationDelegate
extension CardVerificationViewController: WKNavigationDelegate {

    public func webView(_ webView: WKWebView,
                        decidePolicyFor navigationAction: WKNavigationAction,
                        decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        decisionHandler(.allow)
    }

    public func webView(_ webView: WKWebView,
                        decidePolicyFor navigationResponse: WKNavigationResponse,
                        decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        // 認証完了URLかどうかチェック
        if checkVerificationFinished(url: navigationResponse.response.url) {
            decisionHandler(.cancel)
            verifyCompleted = true
            delegate?.cardVarificationViewController(self, didVerified: token?.identifer)
        } else {
            decisionHandler(.allow)
            verifyCompleted = false
        }
    }

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        errorView.dismiss()
    }

    public func webView(_ webView: WKWebView,
                        didFailProvisionalNavigation navigation: WKNavigation!,
                        withError: Error) {
        errorView.show(message: "payjp_card_verification_error_message".localized, reloadButtonHidden: true)
    }
}

// MARK: UIAdaptivePresentationControllerDelegate
extension CardVerificationViewController: UIAdaptivePresentationControllerDelegate {

    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        delegate?.cardVarificationViewControllerDidCancel(self)
    }
}
