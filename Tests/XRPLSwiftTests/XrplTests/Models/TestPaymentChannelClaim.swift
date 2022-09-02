//
//  TestPaymentChannelClaim.swift
//  
//
//  Created by Denis Angell on 8/12/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/models/paymentChannelClaim.ts

import Foundation

import XCTest
@testable import XRPLSwift

final class TestUPaymentChannelClaim: XCTestCase {

    public static var baseTx: [String: AnyObject] = [:]

    override class func setUp() {
        baseTx = [
            "Account": "rB5Ux4Lv2nRx6eeoAAsZmtctnBQ2LiACnk",
            "TransactionType": "PaymentChannelClaim",
            "Channel": "C1AE6DDDEEC05CF2978C0BAD6FE302948E9533691DC749DCDD3B9E5992CA6198",
            "Balance": "1000000",
            "Amount": "1000000",
            "Signature": "30440220718D264EF05CAED7C781FF6DE298DCAC68D002562C9BF3A07C1E721B420C0DAB02203A5A4779EF4D2CCC7BC3EF886676D803A9981B928D3B8ACA483B80ECA3CD7B9B",
            "PublicKey": "32D2471DB72B27E3310F355BB33E339BF26F8392D5A93D3BC0FC3B566612DA0F0A"
        ] as! [String: AnyObject]
    }

    func testA() {
        TestUPaymentChannelClaim.setUp()
        let tx = try! PaymentChannelClaim(json: TestUPaymentChannelClaim.baseTx)
        do {
            try validatePaymentChannelClaim(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    func testB() {
        TestUPaymentChannelClaim.setUp()
        TestUPaymentChannelClaim.baseTx["Balance"] = nil
        TestUPaymentChannelClaim.baseTx["Amount"] = nil
        TestUPaymentChannelClaim.baseTx["Signature"] = nil
        TestUPaymentChannelClaim.baseTx["PublicKey"] = nil
        let tx = try! PaymentChannelClaim(json: TestUPaymentChannelClaim.baseTx)
        do {
            try validatePaymentChannelClaim(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    func testInvalidChannelNil() {
        TestUPaymentChannelClaim.setUp()
        TestUPaymentChannelClaim.baseTx["Channel"] = nil
        XCTAssertThrowsError(try PaymentChannelClaim(json: TestUPaymentChannelClaim.baseTx))
    }

    func testInvalidChannelType() {
        TestUPaymentChannelClaim.setUp()
        TestUPaymentChannelClaim.baseTx["Channel"] = 100 as AnyObject
        XCTAssertThrowsError(try PaymentChannelClaim(json: TestUPaymentChannelClaim.baseTx))
    }

    func testInvalidBalanceType() {
        TestUPaymentChannelClaim.setUp()
        TestUPaymentChannelClaim.baseTx["Balance"] = 100 as AnyObject
        XCTAssertThrowsError(try PaymentChannelClaim(json: TestUPaymentChannelClaim.baseTx))
    }

    func testInvalidAmountType() {
        TestUPaymentChannelClaim.setUp()
        TestUPaymentChannelClaim.baseTx["Amount"] = 1000 as AnyObject
        XCTAssertThrowsError(try PaymentChannelClaim(json: TestUPaymentChannelClaim.baseTx))
    }

    func testInvalidSignatureType() {
        TestUPaymentChannelClaim.setUp()
        TestUPaymentChannelClaim.baseTx["Signature"] = 1000 as AnyObject
        XCTAssertThrowsError(try PaymentChannelClaim(json: TestUPaymentChannelClaim.baseTx))
    }

    func testInvalidPublicKeyType() {
        TestUPaymentChannelClaim.setUp()
        TestUPaymentChannelClaim.baseTx["PublicKey"] = ["100"] as AnyObject
        XCTAssertThrowsError(try PaymentChannelClaim(json: TestUPaymentChannelClaim.baseTx))
    }
}
