//
//  File.swift
//  
//
//  Created by Denis Angell on 8/13/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/models/paymentChannelFund.ts

import Foundation

import XCTest
@testable import XRPLSwift

final class TestUPaymentChannelFund: XCTestCase {

    public static var baseTx: [String: AnyObject] = [:]

    override class func setUp() {
        baseTx = [
            "Account": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
            "TransactionType": "PaymentChannelFund",
            "Channel": "C1AE6DDDEEC05CF2978C0BAD6FE302948E9533691DC749DCDD3B9E5992CA6198",
            "Amount": "200000",
            "Expiration": 543171558
        ] as! [String: AnyObject]
    }

    func testA() {
        TestUPaymentChannelFund.setUp()
        let tx = try! PaymentChannelFund(json: TestUPaymentChannelFund.baseTx)
        do {
            try validatePaymentChannelFund(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    func testB() {
        TestUPaymentChannelFund.setUp()
        TestUPaymentChannelFund.baseTx["Expiration"] = nil
        let tx = try! PaymentChannelFund(json: TestUPaymentChannelFund.baseTx)
        do {
            try validatePaymentChannelFund(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    func testInvalidAmountNil() {
        TestUPaymentChannelFund.setUp()
        TestUPaymentChannelFund.baseTx["Amount"] = nil
        XCTAssertThrowsError(try PaymentChannelFund(json: TestUPaymentChannelFund.baseTx))
    }

    func testInvalidAmountType() {
        TestUPaymentChannelFund.setUp()
        TestUPaymentChannelFund.baseTx["Amount"] = 100 as AnyObject
        XCTAssertThrowsError(try PaymentChannelFund(json: TestUPaymentChannelFund.baseTx))
    }

    func testInvalidChannelNil() {
        TestUPaymentChannelFund.setUp()
        TestUPaymentChannelFund.baseTx["Channel"] = nil
        XCTAssertThrowsError(try PaymentChannelFund(json: TestUPaymentChannelFund.baseTx))
    }

    func testInvalidChannelType() {
        TestUPaymentChannelFund.setUp()
        TestUPaymentChannelFund.baseTx["Channel"] = 100 as AnyObject
        XCTAssertThrowsError(try PaymentChannelFund(json: TestUPaymentChannelFund.baseTx))
    }

    func testInvalidExpirationNil() {
        TestUPaymentChannelFund.setUp()
        TestUPaymentChannelFund.baseTx["Expiration"] = nil
        XCTAssertThrowsError(try PaymentChannelFund(json: TestUPaymentChannelFund.baseTx))
    }

    func testInvalidExpirationType() {
        TestUPaymentChannelFund.setUp()
        TestUPaymentChannelFund.baseTx["Expiration"] = 100 as AnyObject
        XCTAssertThrowsError(try PaymentChannelFund(json: TestUPaymentChannelFund.baseTx))
    }
}
