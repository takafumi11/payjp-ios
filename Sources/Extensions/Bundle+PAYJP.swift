//
//  Bundle+PAYJP.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2020/01/20.
//

import Foundation

extension Bundle {
    static let resourceBundle: Bundle = {
        guard let path = payjpBundle.path(forResource: "Resource", ofType: "bundle"),
            let bundle = Bundle(path: path) else {
                fatalError("Resource bundle cannot be found, please try to reinstall PAYJP SDK.")
        }
        return bundle
    }()
    
    #if PAYJPCocoaPods
    static let payjpBundle: Bundle = {
        guard let path = frameworkBundle.path(forResource: "PAYJP", ofType: "bundle"),
            let bundle = Bundle(path: path) else {
                fatalError("PAYJP bundle cannot be found, please try to reinstall PAYJP SDK.")
        }
        return bundle
    }()
    #else
    static let payjpBundle: Bundle = .frameworkBundle
    #endif
    
    private static let frameworkBundle: Bundle = {
        return Bundle(for: PAYJPSDK.self)
    }()
}
