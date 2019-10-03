//
//  NSErrorConverter.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/10/03.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

class NSErrorConverter {

    var value: NSError?

    init(error: Error) {
        if let error = error as? NSErrorSerializable {
            value = error.nsErrorValue()
        } else {
            value = NSError(domain: PAYErrorDomain,
                            code: PAYErrorSystemError,
                            userInfo: [NSLocalizedDescriptionKey: error.localizedDescription])
        }
    }
}
