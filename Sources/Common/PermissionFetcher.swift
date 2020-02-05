//
//  PermissionFetcher.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2020/02/04.
//  Copyright © 2020 PAY, Inc. All rights reserved.
//

import Foundation
import AVFoundation

/// Request camera permission
protocol PermissionFetcherType {
    /// Check permission authorization status
    func checkCamera() -> AVAuthorizationStatus
    /// Request permission
    func requestCamera(completion: @escaping () -> Void)
}

class PermissionFetcher: PermissionFetcherType {

    static let shared = PermissionFetcher()

    func checkCamera() -> AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: .video)
    }

    func requestCamera(completion: @escaping () -> Void) {
        AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (shouldAccess) in
            if shouldAccess {
                completion()
            }
        })
    }
}
