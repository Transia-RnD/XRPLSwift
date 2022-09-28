//
//  TestAccountSet.swift
//
//
//  Created by Denis Angell on 6/4/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/models/accountSet.ts

import XCTest
@testable import XRPLSwift

final class TestAccountSet: XCTestCase {

    public static var baseTx: [String: AnyObject] = [:]

    override class func setUp() {
        baseTx = [
            "TransactionType": "AccountSet",
            "Account": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
            "Fee": "12",
            "Sequence": 5,
            "Domain": "6578616D706C652E636F6D",
            "SetFlag": 5,
            "MessageKey": "03AB40A0490F9B7ED8DF29D246BF2D6269820A0EE7742ACDD457BEA7C7D0931EDB"
        ] as! [String: AnyObject]
    }

    func testA() {
        let tx = try! AccountSet(json: TestAccountSet.baseTx)
        do {
            try validateAccountSet(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    // TODO: You cannot currently set the Flags to anything other than the Flags allowed
    // The decoded response does not include the invalid SetFlag
    func testInvalidRange() {
        TestAccountSet.setUp()
        TestAccountSet.baseTx["SetFlag"] = 12 as AnyObject
        //        let tx = try! AccountSet(json: TestAccountSet.baseTx)
        XCTAssertThrowsError(try AccountSet(json: TestAccountSet.baseTx))
        //        XCTAssertThrowsError(try validateAccountSet(tx: tx.toJson()))
    }

    func testInvalidType() {
        TestAccountSet.setUp()
        TestAccountSet.baseTx["SetFlag"] = "abc" as AnyObject
        //        let tx = try! AccountSet(json: TestAccountSet.baseTx)
        XCTAssertThrowsError(try AccountSet(json: TestAccountSet.baseTx))
        //        XCTAssertThrowsError(try validateAccountSet(tx: tx.toJson()))
    }

    func testInvalidClearFlag() {
        TestAccountSet.setUp()
        TestAccountSet.baseTx["ClearFlag"] = 12 as AnyObject
        //        let tx = try! AccountSet(json: TestAccountSet.baseTx)
        XCTAssertThrowsError(try AccountSet(json: TestAccountSet.baseTx))
        //        XCTAssertThrowsError(try validateAccountSet(tx: tx.toJson()))
    }

    func testInvalidDomain() {
        TestAccountSet.setUp()
        TestAccountSet.baseTx["Domain"] = 6578616 as AnyObject
        //        let tx = try! AccountSet(json: TestAccountSet.baseTx)
        XCTAssertThrowsError(try AccountSet(json: TestAccountSet.baseTx))
        //        XCTAssertThrowsError(try validateAccountSet(tx: tx.toJson()))
    }

    func testInvalidEmailHash() {
        TestAccountSet.setUp()
        TestAccountSet.baseTx["Domain"] = 6578616 as AnyObject
        //        let tx = try! AccountSet(json: TestAccountSet.baseTx)
        XCTAssertThrowsError(try AccountSet(json: TestAccountSet.baseTx))
        //        XCTAssertThrowsError(try validateAccountSet(tx: tx.toJson()))
    }

    func testInvalidMessageKey() {
        TestAccountSet.setUp()
        TestAccountSet.baseTx["Domain"] = 6578656789876543 as AnyObject
        //        let tx = try! AccountSet(json: TestAccountSet.baseTx)
        XCTAssertThrowsError(try AccountSet(json: TestAccountSet.baseTx))
        //        XCTAssertThrowsError(try validateAccountSet(tx: tx.toJson()))
    }

    func testInvalidTransferRate() {
        TestAccountSet.setUp()
        TestAccountSet.baseTx["TransferRate"] = "1000000001" as AnyObject
        //        let tx = try! AccountSet(json: TestAccountSet.baseTx)
        XCTAssertThrowsError(try AccountSet(json: TestAccountSet.baseTx))
        //        XCTAssertThrowsError(try validateAccountSet(tx: tx.toJson()))
    }

    func testInvalidTicksize() {
        TestAccountSet.setUp()
        TestAccountSet.baseTx["TickSize"] = 20 as AnyObject
        let tx = try! AccountSet(json: TestAccountSet.baseTx)
        //        XCTAssertThrowsError(try AccountSet(json: TestAccountSet.baseTx))
        XCTAssertThrowsError(try validateAccountSet(tx: tx.toJson()))
    }
}
