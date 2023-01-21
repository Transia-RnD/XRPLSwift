//
//  TestCheckCreate.swift
//
//
//  Created by Denis Angell on 8/7/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/models/checkCreate.test.ts

import XCTest
@testable import XRPLSwift

final class TestCheckCreate: XCTestCase {

    func testA() {
        let baseTx = [
            "TransactionType": "CheckCreate",
            "Account": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
            "Destination": "rfkE1aSy9G8Upk4JssnwBxhEv5p4mn2KTy",
            "DestinationTag": 1,
            "SendMax": "100000000",
            "Expiration": 570113521,
            "InvoiceID": "6F1DFD1D0FE8A32E40E1F2C05CF1C15545BAB56B617F9C6C2D63A6B704BEF59B",
            "Fee": "12"
        ] as! [String: AnyObject]
        let tx = try! CheckCreate(json: baseTx)
        do {
            try validateCheckCreate(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    func testInvalidDestination() {
        let baseTx = [
            "TransactionType": "CheckCreate",
            "Account": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
            "Destination": 7896214789632154,
            "DestinationTag": 1,
            "SendMax": "100000000",
            "Expiration": 570113521,
            "InvoiceID": "6F1DFD1D0FE8A32E40E1F2C05CF1C15545BAB56B617F9C6C2D63A6B704BEF59B",
            "Fee": "12"
        ] as! [String: AnyObject]
        XCTAssertThrowsError(try CheckCreate(json: baseTx))
    }

    func testInvalidSendMax() {
        let baseTx = [
            "TransactionType": "CheckCreate",
            "Account": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
            "Destination": "rfkE1aSy9G8Upk4JssnwBxhEv5p4mn2KTy",
            "DestinationTag": 1,
            "SendMax": 100000000,
            "Expiration": 570113521,
            "InvoiceID": "6F1DFD1D0FE8A32E40E1F2C05CF1C15545BAB56B617F9C6C2D63A6B704BEF59B",
            "Fee": "12"
        ] as! [String: AnyObject]
        XCTAssertThrowsError(try CheckCreate(json: baseTx))
    }

    func testInvalidDestinationTag() {
        let baseTx = [
            "TransactionType": "CheckCreate",
            "Account": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
            "Destination": "rfkE1aSy9G8Upk4JssnwBxhEv5p4mn2KTy",
            "DestinationTag": "1",
            "SendMax": "100000000",
            "Expiration": 570113521,
            "InvoiceID": "6F1DFD1D0FE8A32E40E1F2C05CF1C15545BAB56B617F9C6C2D63A6B704BEF59B",
            "Fee": "12"
        ] as! [String: AnyObject]
        // MARK: Required Fields are validated on init Optional validated on validated
        //        let tx = try! CheckCreate(json: baseTx)
        XCTAssertThrowsError(try CheckCreate(json: baseTx))
        //        XCTAssertThrowsError(try validateCheckCancel(tx: tx.toJson()))
    }

    func testInvalidExpiration() {
        let baseTx = [
            "TransactionType": "CheckCreate",
            "Account": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
            "Destination": "rfkE1aSy9G8Upk4JssnwBxhEv5p4mn2KTy",
            "DestinationTag": 1,
            "SendMax": "100000000",
            "Expiration": "570113521",
            "InvoiceID": "6F1DFD1D0FE8A32E40E1F2C05CF1C15545BAB56B617F9C6C2D63A6B704BEF59B",
            "Fee": "12"
        ] as! [String: AnyObject]
        // MARK: Required Fields are validated on init Optional validated on validated
        //        let tx = try! CheckCreate(json: baseTx)
        XCTAssertThrowsError(try CheckCreate(json: baseTx))
        //        XCTAssertThrowsError(try validateCheckCancel(tx: tx.toJson()))
    }

    func testInvalidInvoiceID() {
        let baseTx = [
            "TransactionType": "CheckCreate",
            "Account": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
            "Destination": "rfkE1aSy9G8Upk4JssnwBxhEv5p4mn2KTy",
            "DestinationTag": 1,
            "SendMax": "100000000",
            "Expiration": 570113521,
            "InvoiceID": 789656963258531,
            "Fee": "12"
        ] as! [String: AnyObject]
        // MARK: Required Fields are validated on init Optional validated on validated
        let tx = try! CheckCreate(json: baseTx)
        //        XCTAssertThrowsError(try CheckCreate(json: baseTx))
        XCTAssertThrowsError(try validateCheckCancel(tx: tx.toJson()))
    }
}
