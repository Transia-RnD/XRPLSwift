//
//  TestNFTokenAcceptOffer.swift
//
//
//  Created by Denis Angell on 8/13/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/models/NFTokenAcceptOffer.ts

import Foundation

import XCTest
@testable import XRPLSwift

final class TestNFTokenAcceptOffer: XCTestCase {
    
    public static var baseTx: [String: AnyObject] = [:]
    
    override class func setUp() {
        baseTx = [
            "TransactionType": "NFTokenAcceptOffer",
            "NFTokenBuyOffer": "AED08CC1F50DD5F23A1948AF86153A3F3B7593E5EC77D65A02BB1B29E05AB6AF",
            "Account": "rWYkbWkCeg8dP6rXALnjgZSjjLyih5NXm",
            "Fee": "5000000",
            "Sequence": 2470665,
            "Flags": 2147483648,
        ] as! [String: AnyObject]
    }
    
    func testValidBuyOffer() {
        let tx = try! NFTokenAcceptOffer(json: TestNFTokenAcceptOffer.baseTx)
        do {
            try validateNFTokenAcceptOffer(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }
    
    func testValidSellOffer() {
        TestNFTokenAcceptOffer.baseTx["NFTokenBuyOffer"] = nil
        TestNFTokenAcceptOffer.baseTx["NFTokenSellOffer"] = "AED08CC1F50DD5F23A1948AF86153A3F3B7593E5EC77D65A02BB1B29E05AB6AE" as AnyObject
        let tx = try! NFTokenAcceptOffer(json: TestNFTokenAcceptOffer.baseTx)
        do {
            try validateNFTokenAcceptOffer(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }
    
    func testInvalidBuyAndSellNil() {
        TestNFTokenAcceptOffer.baseTx["NFTokenBuyOffer"] = nil
        TestNFTokenAcceptOffer.baseTx["NFTokenSellOffer"] = nil
        XCTAssertThrowsError(try NFTokenAcceptOffer(json: TestNFTokenAcceptOffer.baseTx))
    }
    
    func testInvalidSellAndBrokerNil() {
        TestNFTokenAcceptOffer.baseTx["NFTokenBuyOffer"] = nil
        TestNFTokenAcceptOffer.baseTx["NFTokenSellOffer"] = nil
        XCTAssertThrowsError(try NFTokenAcceptOffer(json: TestNFTokenAcceptOffer.baseTx))
    }
    
    func testInvalidBuyAndBrokerNil() {
        TestNFTokenAcceptOffer.baseTx["NFTokenBuyOffer"] = nil
        TestNFTokenAcceptOffer.baseTx["NFTokenSellOffer"] = nil
        XCTAssertThrowsError(try NFTokenAcceptOffer(json: TestNFTokenAcceptOffer.baseTx))
    }
    
    func testValidBuyAndSellOfferNoBroker() {
        TestNFTokenAcceptOffer.baseTx["NFTokenBuyOffer"] = "AED08CC1F50DD5F23A1948AF86153A3F3B7593E5EC77D65A02BB1B29E05AB6AF" as AnyObject
        TestNFTokenAcceptOffer.baseTx["NFTokenSellOffer"] = "AED08CC1F50DD5F23A1948AF86153A3F3B7593E5EC77D65A02BB1B29E05AB6AE" as AnyObject
        let tx = try! NFTokenAcceptOffer(json: TestNFTokenAcceptOffer.baseTx)
        do {
            try validateNFTokenAcceptOffer(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }
    
    func testValidBuyAndSellOffer() {
        TestNFTokenAcceptOffer.baseTx["NFTokenBuyOffer"] = "AED08CC1F50DD5F23A1948AF86153A3F3B7593E5EC77D65A02BB1B29E05AB6AF" as AnyObject
        TestNFTokenAcceptOffer.baseTx["NFTokenSellOffer"] = "AED08CC1F50DD5F23A1948AF86153A3F3B7593E5EC77D65A02BB1B29E05AB6AE" as AnyObject
        TestNFTokenAcceptOffer.baseTx["NFTokenBrokerFee"] = "1" as AnyObject
        let tx = try! NFTokenAcceptOffer(json: TestNFTokenAcceptOffer.baseTx)
        do {
            try validateNFTokenAcceptOffer(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }
    
    func testInvalidBrokerZero() {
        TestNFTokenAcceptOffer.baseTx["NFTokenBuyOffer"] = "AED08CC1F50DD5F23A1948AF86153A3F3B7593E5EC77D65A02BB1B29E05AB6AF" as AnyObject
        TestNFTokenAcceptOffer.baseTx["NFTokenSellOffer"] = "AED08CC1F50DD5F23A1948AF86153A3F3B7593E5EC77D65A02BB1B29E05AB6AE" as AnyObject
        TestNFTokenAcceptOffer.baseTx["NFTokenBrokerFee"] = "0" as AnyObject
        XCTAssertThrowsError(try NFTokenAcceptOffer(json: TestNFTokenAcceptOffer.baseTx))
    }
    
    func testInvalidBrokerLessZero() {
        TestNFTokenAcceptOffer.baseTx["NFTokenBuyOffer"] = "AED08CC1F50DD5F23A1948AF86153A3F3B7593E5EC77D65A02BB1B29E05AB6AF" as AnyObject
        TestNFTokenAcceptOffer.baseTx["NFTokenSellOffer"] = "AED08CC1F50DD5F23A1948AF86153A3F3B7593E5EC77D65A02BB1B29E05AB6AE" as AnyObject
        TestNFTokenAcceptOffer.baseTx["NFTokenBrokerFee"] = "-1" as AnyObject
        XCTAssertThrowsError(try NFTokenAcceptOffer(json: TestNFTokenAcceptOffer.baseTx))
    }
    
    func testInvalidBrokerType() {
        TestNFTokenAcceptOffer.baseTx["NFTokenBuyOffer"] = "AED08CC1F50DD5F23A1948AF86153A3F3B7593E5EC77D65A02BB1B29E05AB6AF" as AnyObject
        TestNFTokenAcceptOffer.baseTx["NFTokenSellOffer"] = "AED08CC1F50DD5F23A1948AF86153A3F3B7593E5EC77D65A02BB1B29E05AB6AE" as AnyObject
        TestNFTokenAcceptOffer.baseTx["NFTokenBrokerFee"] = 1 as AnyObject
        XCTAssertThrowsError(try NFTokenAcceptOffer(json: TestNFTokenAcceptOffer.baseTx))
    }
}

