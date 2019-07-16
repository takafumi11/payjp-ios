//
//  CardBrandValidatorTests.swift
//  PAYJPTests
//
//  Created by Tadashi Wakayanagi on 2019/07/16.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import XCTest
@testable import PAYJP

class CardBrandValidatorTests: XCTestCase {

    private func testCardBrandType(numbers: [String], type: CardBrandType) {
        let validator = CardBrandValidator.shared
        for number in numbers {
            let brandType = validator.validate(number: number)
            XCTAssertEqual(brandType, type)
        }
    }

    func testVisaType() {
        let numbers = [
            "4",
            "42",
            "4211",
            "4242111122223333"
        ]
        testCardBrandType(numbers: numbers, type: CardBrandType.Visa)
    }

    func testMastercardType() {
        let numbers = [
            "51",
            "52",
            "53",
            "54",
            "55",
            "5151",
            "2221",
            "2230",
            "2300",
            "2537",
            "2720",
            "5151222233334444",
            "2221222233334444",
        ]
        testCardBrandType(numbers: numbers, type: CardBrandType.Mastercard)
    }

    func testJCBType() {
        let numbers = [
            "2131",
            "1800",
            "21312222",
            "213122223333444",
            "35",
            "3511",
            "3511222233334444"
        ]
        testCardBrandType(numbers: numbers, type: CardBrandType.JCB)
    }

    func testAmexType() {
        let numbers = [
            "34",
            "37",
            "340",
            "3718",
            "341122223333444"
        ]
        testCardBrandType(numbers: numbers, type: CardBrandType.Amex)
    }

    func testDinersType() {
        let numbers = [
            "300",
            "301",
            "302",
            "303",
            "304",
            "305",
            "36",
            "38",
            "3001",
            "3052",
            "363",
            "384",
            "30012222333344",
            "38012222333344"
        ]
        testCardBrandType(numbers: numbers, type: CardBrandType.Diners)
    }

    func testDiscoverType() {
        let numbers = [
            "6011",
            "65",
            "60112",
            "650",
            "6011222233334444",
            "6511222233334444"
        ]
        testCardBrandType(numbers: numbers, type: CardBrandType.Discover)
    }

    func testUnknownType() {
        let numbers = [
            "0",
            "9999",
            "77",
            "1234",
            "111122223333444455556666",
            "99999999999999999999999999999999999999999999999999"
        ]
        testCardBrandType(numbers: numbers, type: CardBrandType.Unknown)
    }
}
