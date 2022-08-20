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

final class TestPaymentChannelFund: XCTestCase {

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

    func testValid() {
        let tx = try! PaymentChannelFund(json: TestPaymentChannelFund.baseTx)
        do {
            try validatePaymentChannelFund(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    func testValidNoOptional() {
        TestPaymentChannelFund.baseTx["Expiration"] = nil
        let tx = try! PaymentChannelFund(json: TestPaymentChannelFund.baseTx)
        do {
            try validatePaymentChannelFund(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    func testInvalidAmountNil() {
        TestPaymentChannelFund.baseTx["Amount"] = nil
        XCTAssertThrowsError(try PaymentChannelFund(json: TestPaymentChannelFund.baseTx))
    }

    func testInvalidAmountType() {
        TestPaymentChannelFund.baseTx["Amount"] = 100 as AnyObject
        XCTAssertThrowsError(try PaymentChannelFund(json: TestPaymentChannelFund.baseTx))
    }

    func testInvalidChannelNil() {
        TestPaymentChannelFund.baseTx["Channel"] = nil
        XCTAssertThrowsError(try PaymentChannelFund(json: TestPaymentChannelFund.baseTx))
    }

    func testInvalidChannelType() {
        TestPaymentChannelFund.baseTx["Channel"] = 100 as AnyObject
        XCTAssertThrowsError(try PaymentChannelFund(json: TestPaymentChannelFund.baseTx))
    }

    func testInvalidExpirationNil() {
        TestPaymentChannelFund.baseTx["Expiration"] = nil
        XCTAssertThrowsError(try PaymentChannelFund(json: TestPaymentChannelFund.baseTx))
    }

    func testInvalidExpirationType() {
        TestPaymentChannelFund.baseTx["Expiration"] = 100 as AnyObject
        XCTAssertThrowsError(try PaymentChannelFund(json: TestPaymentChannelFund.baseTx))
    }
}
