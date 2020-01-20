//
//  Bundle+PAYJP.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2020/01/20.
//

import Foundation

extension Bundle {
    static let sdkBundle: Bundle = {
        guard let path = frameworkBundle.path(forResource: "PAYJP", ofType: "bundle"),
            let bundle = Bundle(path: path) else { return .frameworkBundle }
        return bundle
    }()

    static let frameworkBundle: Bundle = {
        return Bundle(for: PAYJPSDK.self)
    }()
}
