//
//  TokenOperationStatus.swift
//  PAYJP
//
//  Created by 北川達也 on 2020/09/11.
//  Copyright © 2020 PAY, Inc. All rights reserved.
//

import Foundation

@objc(PAYTokenOperationStatus) public enum TokenOperationStatus: Int {
    case acceptable
    case running
    case throttled
}
