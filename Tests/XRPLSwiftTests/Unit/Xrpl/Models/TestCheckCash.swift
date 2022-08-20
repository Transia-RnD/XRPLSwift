//
//  TestCheckCash.swift
//  
//
//  Created by Denis Angell on 8/7/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/models/checkCancel.ts

import XCTest
@testable import XRPLSwift

final class TestCheckCash: XCTestCase {

    func testValidCheckCash() {
        let baseTx = [
            "TransactionType": "CheckCash",
            "Account": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
            "Amount": "100000000",
            "CheckID": "838766BA2B995C00744175F69A1B11E32C3DBC40E64801A4056FCBD657F57334",
            "Fee": "12"
        ] as! [String: AnyObject]
        let tx = try! CheckCash(json: baseTx)
        do {
            try validateCheckCash(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    func testInvalidCheckID() {
        let baseTx = [
            "TransactionType": "CheckCash",
            "Account": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
            "Amount": "100000000",
            "CheckID": 83876645678567890
        ] as! [String: AnyObject]
        XCTAssertThrowsError(try CheckCash(json: baseTx))
        // MARK: This is because the fields are validated on init
//        let tx = try! CheckCancel(json: baseTx)
//        XCTAssertThrowsError(try validateCheckCancel(tx: tx.toJson()))
    }

    func testInvalidAmount() {
        let baseTx = [
            "TransactionType": "CheckCash",
            "Account": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
            "Amount": 100000000,
            "CheckID": "838766BA2B995C00744175F69A1B11E32C3DBC40E64801A4056FCBD657F57334"
        ] as! [String: AnyObject]
        XCTAssertThrowsError(try CheckCash(json: baseTx))
        // MARK: This is because the fields are validated on init
//        let tx = try! CheckCancel(json: baseTx)
//        XCTAssertThrowsError(try validateCheckCancel(tx: tx.toJson()))
    }

    func testInvalidAmountAndDeliverMin() {
        let baseTx = [
            "TransactionType": "CheckCash",
            "Account": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
            "Amount": "100000000",
            "DeliverMin": 852156963,
            "CheckID": "838766BA2B995C00744175F69A1B11E32C3DBC40E64801A4056FCBD657F57334"
        ] as! [String: AnyObject]
        XCTAssertThrowsError(try CheckCash(json: baseTx))
        // MARK: This is because the fields are validated on init
//        let tx = try! CheckCancel(json: baseTx)
//        XCTAssertThrowsError(try validateCheckCancel(tx: tx.toJson()))
    }

    func testInvalidDeliverMin() {
        let baseTx = [
            "TransactionType": "CheckCash",
            "Account": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
            "DeliverMin": 852156963,
            "CheckID": "838766BA2B995C00744175F69A1B11E32C3DBC40E64801A4056FCBD657F57334"
        ] as! [String: AnyObject]
        XCTAssertThrowsError(try CheckCash(json: baseTx))
        // MARK: This is because the fields are validated on init
//        let tx = try! CheckCancel(json: baseTx)
//        XCTAssertThrowsError(try validateCheckCancel(tx: tx.toJson()))
    }
}
