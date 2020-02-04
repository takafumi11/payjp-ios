//
//  PermissionFetcher.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2020/02/04.
//  Copyright © 2020 PAY, Inc. All rights reserved.
//

import Foundation
import AVFoundation

enum PermissionAuthorizationStatus {
    /// 初回起動時、まだ許可していない時に呼ばれる
    case notDetermined
    /// 端末の機能制限時。カメラが使えない、そもそもついてない、とかの場合？
    case restricted
    /// 許可リクエストを拒否された時に呼ばれる。この後はrequestAccessを呼んでも返って来なくなる
    case denied
    /// パーミッションが許可 された or されている
    case authorized
}

/// Request camera permission
protocol PermissionFetcherType {
    /// Return the authorization status without request for permission
    func checkCamera() -> PermissionAuthorizationStatus
    /// Return `Bool` that should granted permission.
    func requestCamera(completion: @escaping () -> Void) -> PermissionAuthorizationStatus
}

class PermissionFetcher: PermissionFetcherType {

    static let shared = PermissionFetcher()

    func checkCamera() -> PermissionAuthorizationStatus {
        return requestAVMedia(for: .video, shouldRequestPermission: false)
    }

    /// using AVCaptureDevice AVMediaType.video
    func requestCamera(completion: @escaping () -> Void) -> PermissionAuthorizationStatus {
        return requestAVMedia(for: .video, completion: completion)
    }

    /// using AVCaptureDevice
    private func requestAVMedia(for accessType: AVMediaType,
                                shouldRequestPermission: Bool = true,
                                completion: (() -> Void)? = nil) -> PermissionAuthorizationStatus {

        let status = PermissionAuthorizationStatus(
            avAuthorizationStatus: AVCaptureDevice.authorizationStatus(for: accessType)
        )

        if shouldRequestPermission && status == .notDetermined {
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (shouldAccess) in
                if shouldAccess {
                    completion?()
                }
            })
        }

        return status
    }
}

private extension PermissionAuthorizationStatus {

    init(avAuthorizationStatus: AVAuthorizationStatus) {
        switch avAuthorizationStatus {
        case .notDetermined:
            self = .notDetermined
        case .restricted:
            self = .restricted
        case .denied:
            self = .denied
        case .authorized:
            self = .authorized
        @unknown default:
            fatalError("Unknown AVAuthorizationStatus => \(avAuthorizationStatus)")
        }
    }
}
