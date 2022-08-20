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

final class TestSetRegularKey: XCTestCase {

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

    func testValid() {
        let tx = try! SetRegularKey(json: TestSetRegularKey.baseTx)
        do {
            try validateSetRegularKey(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    func testValidNoOptional() {
        TestSetRegularKey.baseTx["RegularKey"] = nil
        let tx = try! SetRegularKey(json: TestSetRegularKey.baseTx)
        do {
            try validateSetRegularKey(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    func testInvalidRegularKeyType() {
        TestSetRegularKey.baseTx["RegularKey"] = 12369846963 as AnyObject
        XCTAssertThrowsError(try SetRegularKey(json: TestSetRegularKey.baseTx))
    }
}
