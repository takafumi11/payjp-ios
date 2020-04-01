//
//  AppDelegate.swift
//  example-swift
//
//  Created by Tatsuya Kitagawa on 2017/12/08.
//  Copyright © 2017年 PAY, Inc. All rights reserved.
//

import UIKit
import PAYJP

let PAYJPPublicKey = "pk_test_0383a1b8f91e8a6e3ea0e2a9"
let App3DSRedirectURL = "exampleswift://tds/complete"
let App3DSRedirectURLKey = "swift-app"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {

        PAYJPSDK.publicKey = PAYJPPublicKey
        PAYJPSDK.locale = Locale.current
        PAYJPSDK.threeDSecureURLConfiguration =
            ThreeDSecureURLConfiguration(redirectURL: URL(string: App3DSRedirectURL)!,
                                         redirectURLKey: App3DSRedirectURLKey)

        return true
    }

    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

        return ThreeDSecureURLHandler.shared.completeThreeDSecureProcess(url: url)
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

}
