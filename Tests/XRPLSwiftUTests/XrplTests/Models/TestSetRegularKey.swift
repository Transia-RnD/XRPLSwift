//
//  TestSetRegularKey.swift
//
//
//  Created by Denis Angell on 8/13/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/models/setRegularKey.ts

import Foundation

import XCTest
@testable import XRPLSwift

final class TestUSetRegularKey: XCTestCase {

    public static var baseTx: [String: AnyObject] = [:]

    override class func setUp() {
        baseTx = [
            "TransactionType": "SetRegularKey",
            "Account": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
            "Fee": "12",
            "Flags": 0,
            "RegularKey": "rAR8rR8sUkBoCZFawhkWzY4Y5YoyuznwD"
        ] as! [String: AnyObject]
    }

    func testA() {
        TestUSetRegularKey.setUp()
        let tx = try! SetRegularKey(json: TestUSetRegularKey.baseTx)
        do {
            try validateSetRegularKey(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    func testB() {
        TestUSetRegularKey.setUp()
        TestUSetRegularKey.baseTx["RegularKey"] = nil
        let tx = try! SetRegularKey(json: TestUSetRegularKey.baseTx)
        do {
            try validateSetRegularKey(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    func testInvalidRegularKeyType() {
        TestUSetRegularKey.setUp()
        TestUSetRegularKey.baseTx["RegularKey"] = 12369846963 as AnyObject
        XCTAssertThrowsError(try SetRegularKey(json: TestUSetRegularKey.baseTx))
    }
}
