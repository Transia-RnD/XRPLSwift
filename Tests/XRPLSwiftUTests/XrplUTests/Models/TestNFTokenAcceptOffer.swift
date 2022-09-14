//
//  TestUNFTokenAcceptOffer.swift
//
//
//  Created by Denis Angell on 8/13/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/models/NFTokenAcceptOffer.ts

import Foundation

import XCTest
@testable import XRPLSwift

final class TestUNFTokenAcceptOffer: XCTestCase {

    public static var baseTx: [String: AnyObject] = [:]

    override class func setUp() {
        baseTx = [
            "TransactionType": "NFTokenAcceptOffer",
            "NFTokenBuyOffer": "AED08CC1F50DD5F23A1948AF86153A3F3B7593E5EC77D65A02BB1B29E05AB6AF",
            "Account": "rWYkbWkCeg8dP6rXALnjgZSjjLyih5NXm",
            "Fee": "5000000",
            "Sequence": 2470665,
            "Flags": 2147483648
        ] as! [String: AnyObject]
    }

    func testA() {
        let tx = try! NFTokenAcceptOffer(json: TestUNFTokenAcceptOffer.baseTx)
        do {
            try validateNFTokenAcceptOffer(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    func testB() {
        TestUNFTokenAcceptOffer.baseTx["NFTokenBuyOffer"] = nil
        TestUNFTokenAcceptOffer.baseTx["NFTokenSellOffer"] = "AED08CC1F50DD5F23A1948AF86153A3F3B7593E5EC77D65A02BB1B29E05AB6AE" as AnyObject
        let tx = try! NFTokenAcceptOffer(json: TestUNFTokenAcceptOffer.baseTx)
        do {
            try validateNFTokenAcceptOffer(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    func testInvalidBuyAndSellNil() {
        TestUNFTokenAcceptOffer.baseTx["NFTokenBuyOffer"] = nil
        TestUNFTokenAcceptOffer.baseTx["NFTokenSellOffer"] = nil
        XCTAssertThrowsError(try NFTokenAcceptOffer(json: TestUNFTokenAcceptOffer.baseTx))
    }

    func testInvalidSellAndBrokerNil() {
        TestUNFTokenAcceptOffer.baseTx["NFTokenBuyOffer"] = nil
        TestUNFTokenAcceptOffer.baseTx["NFTokenSellOffer"] = nil
        XCTAssertThrowsError(try NFTokenAcceptOffer(json: TestUNFTokenAcceptOffer.baseTx))
    }

    func testInvalidBuyAndBrokerNil() {
        TestUNFTokenAcceptOffer.baseTx["NFTokenBuyOffer"] = nil
        TestUNFTokenAcceptOffer.baseTx["NFTokenSellOffer"] = nil
        XCTAssertThrowsError(try NFTokenAcceptOffer(json: TestUNFTokenAcceptOffer.baseTx))
    }

    func testValidBuyAndSellOfferNoBroker() {
        TestUNFTokenAcceptOffer.baseTx["NFTokenBuyOffer"] = "AED08CC1F50DD5F23A1948AF86153A3F3B7593E5EC77D65A02BB1B29E05AB6AF" as AnyObject
        TestUNFTokenAcceptOffer.baseTx["NFTokenSellOffer"] = "AED08CC1F50DD5F23A1948AF86153A3F3B7593E5EC77D65A02BB1B29E05AB6AE" as AnyObject
        let tx = try! NFTokenAcceptOffer(json: TestUNFTokenAcceptOffer.baseTx)
        do {
            try validateNFTokenAcceptOffer(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    func testValidBuyAndSellOffer() {
        TestUNFTokenAcceptOffer.baseTx["NFTokenBuyOffer"] = "AED08CC1F50DD5F23A1948AF86153A3F3B7593E5EC77D65A02BB1B29E05AB6AF" as AnyObject
        TestUNFTokenAcceptOffer.baseTx["NFTokenSellOffer"] = "AED08CC1F50DD5F23A1948AF86153A3F3B7593E5EC77D65A02BB1B29E05AB6AE" as AnyObject
        TestUNFTokenAcceptOffer.baseTx["NFTokenBrokerFee"] = "1" as AnyObject
        let tx = try! NFTokenAcceptOffer(json: TestUNFTokenAcceptOffer.baseTx)
        do {
            try validateNFTokenAcceptOffer(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    func testInvalidBrokerZero() {
        TestUNFTokenAcceptOffer.baseTx["NFTokenBuyOffer"] = "AED08CC1F50DD5F23A1948AF86153A3F3B7593E5EC77D65A02BB1B29E05AB6AF" as AnyObject
        TestUNFTokenAcceptOffer.baseTx["NFTokenSellOffer"] = "AED08CC1F50DD5F23A1948AF86153A3F3B7593E5EC77D65A02BB1B29E05AB6AE" as AnyObject
        TestUNFTokenAcceptOffer.baseTx["NFTokenBrokerFee"] = "0" as AnyObject
        XCTAssertThrowsError(try NFTokenAcceptOffer(json: TestUNFTokenAcceptOffer.baseTx))
    }

    func testInvalidBrokerLessZero() {
        TestUNFTokenAcceptOffer.baseTx["NFTokenBuyOffer"] = "AED08CC1F50DD5F23A1948AF86153A3F3B7593E5EC77D65A02BB1B29E05AB6AF" as AnyObject
        TestUNFTokenAcceptOffer.baseTx["NFTokenSellOffer"] = "AED08CC1F50DD5F23A1948AF86153A3F3B7593E5EC77D65A02BB1B29E05AB6AE" as AnyObject
        TestUNFTokenAcceptOffer.baseTx["NFTokenBrokerFee"] = "-1" as AnyObject
        XCTAssertThrowsError(try NFTokenAcceptOffer(json: TestUNFTokenAcceptOffer.baseTx))
    }

    func testInvalidBrokerType() {
        TestUNFTokenAcceptOffer.baseTx["NFTokenBuyOffer"] = "AED08CC1F50DD5F23A1948AF86153A3F3B7593E5EC77D65A02BB1B29E05AB6AF" as AnyObject
        TestUNFTokenAcceptOffer.baseTx["NFTokenSellOffer"] = "AED08CC1F50DD5F23A1948AF86153A3F3B7593E5EC77D65A02BB1B29E05AB6AE" as AnyObject
        TestUNFTokenAcceptOffer.baseTx["NFTokenBrokerFee"] = 1 as AnyObject
        XCTAssertThrowsError(try NFTokenAcceptOffer(json: TestUNFTokenAcceptOffer.baseTx))
    }
}
