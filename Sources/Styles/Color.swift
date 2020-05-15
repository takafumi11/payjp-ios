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

        static var label: UIColor {
            if #available(iOS 13.0, *) {
                return .label
            } else {
                return .init(hex: "030300")
            }
        }
        static var placeholderText: UIColor {
            if #available(iOS 13.0, *) {
                return .placeholderText
            } else {
                return .systemGray
            }
        }
        static var groupedBackground: UIColor {
            if #available(iOS 13.0, *) {
                return .secondarySystemGroupedBackground
            } else {
                return .white
            }
        }
        static var gray: UIColor {
            if #available(iOS 13.0, *) {
                return .systemGray3
            } else {
                return .init(hex: "d8d8dc")
            }
        }
        static var separator: UIColor {
            if #available(iOS 13.0, *) {
                return .separator
            } else {
                return .init(hex: "c7c7cc")
            }
        }
        static var blue: UIColor {
            return .systemBlue
        }
        static var red: UIColor {
            return .systemRed
        }

        // CardDisplay
        static var displayLabel: UIColor {
            return .systemGray
        }
        static var displayCvcLabel: UIColor {
            return .init(hex: "030300")
        }
    }
}
