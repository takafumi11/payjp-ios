//
//  Bundle+PAYJP.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2020/01/20.
//

import Foundation

extension Bundle {
    static let payjpBundle: Bundle = {
        let baseBundle = Bundle(for: PAYJPSDK.self)
        guard let path = baseBundle.path(forResource: "PAYJP", ofType: "bundle"),
            let bundle = Bundle(path: path) else { return baseBundle }
        return bundle
    }()
}
