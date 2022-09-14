//
//  TestUTrustSet.swift
//
//
//  Created by Denis Angell on 8/13/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/models/trustSet.ts

import Foundation

import XCTest
@testable import XRPLSwift

final class TestUTrustSet: XCTestCase {

    public static var baseTx: [String: AnyObject] = [:]

    override class func setUp() {
        baseTx = [
            "TransactionType": "TrustSet",
            "Account": "rUn84CUYbNjRoTQ6mSW7BVJPSVJNLb1QLo",
            "LimitAmount": [
                "currency": "XRP",
                "issuer": "rcXY84C4g14iFp6taFXjjQGVeHqSCh9RX",
                "value": "4329.23"
            ],
            "QualityIn": 1234,
            "QualityOut": 4321
        ] as! [String: AnyObject]
    }

    func testA() {
        TestUTrustSet.setUp()
        let tx = try! TrustSet(json: TestUTrustSet.baseTx)
        do {
            try validateTrustSet(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    func testInvalidLimitAmountNil() {
        TestUTrustSet.setUp()
        TestUTrustSet.baseTx["LimitAmount"] = nil
        XCTAssertThrowsError(try TrustSet(json: TestUTrustSet.baseTx))
    }

    func testInvalidLimitAmountType() {
        TestUTrustSet.setUp()
        TestUTrustSet.baseTx["LimitAmount"] = 1234 as AnyObject
        XCTAssertThrowsError(try TrustSet(json: TestUTrustSet.baseTx))
    }

    func testInvalidQualityInType() {
        TestUTrustSet.setUp()
        TestUTrustSet.baseTx["QualityIn"] = "1234" as AnyObject
        XCTAssertThrowsError(try TrustSet(json: TestUTrustSet.baseTx))
    }
    func testInvalidQualityOutType() {
        TestUTrustSet.setUp()
        TestUTrustSet.baseTx["QualityOut"] = "4321" as AnyObject
        XCTAssertThrowsError(try TrustSet(json: TestUTrustSet.baseTx))
    }
}
