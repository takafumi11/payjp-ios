//
//  CallbackQueue.swift
//  PAYJP
//
//  Created by Li-Hsuan Chen on 2019/07/24.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

enum CallbackQueue {
    case main
    case current
    case operation(OperationQueue)
    case dispatch(DispatchQueue)

    public func execute(handler: @escaping () -> Void) {
        switch self {
        case .main:
            DispatchQueue.main.async {
                handler()
            }

        case .current:
            handler()

        case .operation(let operationQueue):
            operationQueue.addOperation {
                handler()
            }

        case .dispatch(let dispatchQueue):
            dispatchQueue.async {
                handler()
            }
        }
    }
}
