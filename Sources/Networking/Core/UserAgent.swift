//
//  UserAgent.swift
//  PAYJP
//
//  Created by Li-Hsuan Chen on 2019/07/11.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import UIKit

struct UserAgent {
    static var `default`: String {
        let device = UIDevice.current
        let version = Bundle(for: APIClient.self).infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let osVersion = device.systemVersion
        let deviceName = self.device
        return "jp.pay.ios/\(version); iOS/\(osVersion); apple; \(deviceName)"
    }

    private static var device: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
}
