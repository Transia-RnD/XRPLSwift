//
//  TestUPaymentChannelCreate.swift
//
//
//  Created by Denis Angell on 8/12/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/models/paymentChannelCreate.ts

import Foundation

import XCTest
@testable import XRPLSwift

final class TestUPaymentChannelCreate: XCTestCase {

    public static var baseTx: [String: AnyObject] = [:]

    override class func setUp() {
        baseTx = [
            "Account": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
            "TransactionType": "PaymentChannelCreate",
            "Amount": "10000",
            "Destination": "rsA2LpzuawewSBQXkiju3YQTMzW13pAAdW",
            "SettleDelay": 86400,
            "PublicKey": "32D2471DB72B27E3310F355BB33E339BF26F8392D5A93D3BC0FC3B566612DA0F0A",
            "CancelAfter": 533171558,
            "DestinationTag": 23480,
            "SourceTag": 11747
        ] as! [String: AnyObject]
    }

    func testA() {
        TestUPaymentChannelCreate.setUp()
        let tx = try! PaymentChannelCreate(json: TestUPaymentChannelCreate.baseTx)
        do {
            try validatePaymentChannelCreate(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    func testB() {
        TestUPaymentChannelCreate.setUp()
        TestUPaymentChannelCreate.baseTx["CancelAfter"] = nil
        TestUPaymentChannelCreate.baseTx["DestinationTag"] = nil
        TestUPaymentChannelCreate.baseTx["SourceTag"] = nil
        let tx = try! PaymentChannelCreate(json: TestUPaymentChannelCreate.baseTx)
        do {
            try validatePaymentChannelCreate(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    func testInvalidAmountNil() {
        TestUPaymentChannelCreate.setUp()
        TestUPaymentChannelCreate.baseTx["Amount"] = nil
        XCTAssertThrowsError(try PaymentChannelCreate(json: TestUPaymentChannelCreate.baseTx))
    }

    func testInvalidAmountType() {
        TestUPaymentChannelCreate.setUp()
        TestUPaymentChannelCreate.baseTx["Amount"] = 1000 as AnyObject
        XCTAssertThrowsError(try PaymentChannelCreate(json: TestUPaymentChannelCreate.baseTx))
    }

    func testInvalidDestinationNil() {
        TestUPaymentChannelCreate.setUp()
        TestUPaymentChannelCreate.baseTx["Destination"] = nil
        XCTAssertThrowsError(try PaymentChannelCreate(json: TestUPaymentChannelCreate.baseTx))
    }

    func testInvalidDestinationType() {
        TestUPaymentChannelCreate.setUp()
        TestUPaymentChannelCreate.baseTx["Destination"] = 10 as AnyObject
        XCTAssertThrowsError(try PaymentChannelCreate(json: TestUPaymentChannelCreate.baseTx))
    }

    func testInvalidSettleDelayNil() {
        TestUPaymentChannelCreate.setUp()
        TestUPaymentChannelCreate.baseTx["SettleDelay"] = nil
        XCTAssertThrowsError(try PaymentChannelCreate(json: TestUPaymentChannelCreate.baseTx))
    }

    func testInvalidSettleDelayType() {
        TestUPaymentChannelCreate.setUp()
        TestUPaymentChannelCreate.baseTx["SettleDelay"] = "10" as AnyObject
        XCTAssertThrowsError(try PaymentChannelCreate(json: TestUPaymentChannelCreate.baseTx))
    }

    func testInvalidPublicKeyNil() {
        TestUPaymentChannelCreate.setUp()
        TestUPaymentChannelCreate.baseTx["PublicKey"] = nil
        XCTAssertThrowsError(try PaymentChannelCreate(json: TestUPaymentChannelCreate.baseTx))
    }

    func testInvalidPublicKeyType() {
        TestUPaymentChannelCreate.setUp()
        TestUPaymentChannelCreate.baseTx["PublicKey"] = 10 as AnyObject
        XCTAssertThrowsError(try PaymentChannelCreate(json: TestUPaymentChannelCreate.baseTx))
    }
}
