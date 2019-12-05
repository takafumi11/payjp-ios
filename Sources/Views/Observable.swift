//
//  Observable.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/12/05.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

class Observable<T: Equatable> {
    private let thread: DispatchQueue

    var value: T? {
        willSet(newValue) {
            if let newValue = newValue, value != newValue {
                thread.async {
                    self.observe?(newValue)
                }
            }
        }
    }

    var observe: ((T) -> Void)?

    init(_ value: T? = nil, thread dispatcherThread: DispatchQueue = DispatchQueue.main) {
        self.thread = dispatcherThread
        self.value = value
    }
}
