//
//  PAYJPSDK.swift
//  PAYJP
//
//  Created by Li-Hsuan Chen on 2019/07/24.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

protocol PAYJPSDKType: class {
    static var publicKey: String? { set get }
    static var locale: Locale? { set get }
}

@objc(PAYJPSDK) @objcMembers
public final class PAYJPSDK: NSObject, PAYJPSDKType {
    
    private override init() {}
    
    // MARK: - PAYJPSDKType
    
    public static var publicKey: String?
    public static var locale: Locale?
}
