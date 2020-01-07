//
//  WebViewObserver.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2020/01/07.
//  Copyright © 2020 PAY, Inc. All rights reserved.
//

import UIKit
import WebKit

protocol WebViewObserverType {
    func setup()
    func remove()
}

class WebViewObserver: WebViewObserverType {
    
    private let webView: WKWebView
    private let progressView: UIProgressView
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    init(webView: WKWebView, progressView: UIProgressView) {
        self.webView = webView
        self.progressView = progressView
    }
    
    func setup() {
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
    
    func remove() {
        estimatedProgressObservation = nil
    }
}
