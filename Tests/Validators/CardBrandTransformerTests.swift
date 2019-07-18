//
//  CardBrandTransformerTests.swift
//  PAYJPTests
//
//  Created by Tadashi Wakayanagi on 2019/07/16.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

import XCTest
@testable import PAYJP

class CardBrandTransformerTests: XCTestCase {

    let transformer = CardBrandTransformer()

    private func testCardBrandType(numbers: [String], brand: CardBrand) {
        for number in numbers {
            let brandType = transformer.transform(from: number)
            XCTAssertEqual(brandType, brand)
        }
    }

    func testVisaType() {
        let numbers = [
            "4",
            "42",
            "4211",
            "4242111122223333",
            "42421111222233334444",
        ]
        testCardBrandType(numbers: numbers, brand: .visa)
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
            "22212222333344445555"
        ]
        testCardBrandType(numbers: numbers, brand: .mastercard)
    }

    func testJCBType() {
        let numbers = [
            "35",
            "3511",
            "3511222233334444",
            "35112222333344445555"
        ]
        testCardBrandType(numbers: numbers, brand: .jcb)
    }

    func testAmexType() {
        let numbers = [
            "34",
            "37",
            "340",
            "3718",
            "341122223333444",
            "34112222333344445555"
        ]
        testCardBrandType(numbers: numbers, brand: .americanExpress)
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
            "38012222333344",
            "38012222333344445555"
        ]
        testCardBrandType(numbers: numbers, brand: .dinersClub)
    }

    func testDiscoverType() {
        let numbers = [
            "6011",
            "65",
            "60112",
            "650",
            "6011222233334444",
            "6511222233334444",
            "65112222333344445555"
        ]
        testCardBrandType(numbers: numbers, brand: .discover)
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
        testCardBrandType(numbers: numbers, brand: .unknown)
    }
}
