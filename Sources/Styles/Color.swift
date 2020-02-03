//
//  Color.swift
//  PAYJP
//
//  Created by Tadashi Wakayanagi on 2019/09/24.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import Foundation

extension Style {
    final class Color {

        static var text: UIColor {
            if #available(iOS 13.0, *) {
                return .label
            } else {
                return .init(hex: "030300")
            }
        }
        static var background: UIColor {
            if #available(iOS 13.0, *) {
                return .secondarySystemGroupedBackground
            } else {
                return .white
            }
        }
        static var gray: UIColor {
            if #available(iOS 13.0, *) {
                return .placeholderText
            } else {
                return .systemGray
            }
        }
        static var lightGray: UIColor {
            if #available(iOS 13.0, *) {
                return .systemGray3
            } else {
                return .init(hex: "d8d8dc")
            }
        }
        static var blue: UIColor {
            return .systemBlue
        }
        static var red: UIColor {
            return .systemRed
        }
    }
}
