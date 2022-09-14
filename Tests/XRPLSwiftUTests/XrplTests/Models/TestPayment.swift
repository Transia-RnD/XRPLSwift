//
//  File.swift
//  
//
//  Created by Denis Angell on 8/12/22.
//

import Foundation

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/models/payment.ts

import XCTest
@testable import XRPLSwift

final class TestUPayment: XCTestCase {

    public static var baseTx: [String: AnyObject] = [:]

    override class func setUp() {
        baseTx = [
            "TransactionType": "Payment",
            "Account": "rUn84CUYbNjRoTQ6mSW7BVJPSVJNLb1QLo",
            "Amount": "1234",
            "Destination": "rfkE1aSy9G8Upk4JssnwBxhEv5p4mn2KTy",
            "DestinationTag": 1,
            "Fee": "12",
            "Flags": 2147483648,
            "LastLedgerSequence": 65953073,
            "Sequence": 65923914,
            "SigningPubKey":
                "02F9E33F16DF9507705EC954E3F94EB5F10D1FC4A354606DBE6297DBB1096FE654",
            "TxnSignature":
                "3045022100E3FAE0EDEC3D6A8FF6D81BC9CF8288A61B7EEDE8071E90FF9314CB4621058D10022043545CF631706D700CEE65A1DB83EFDD185413808292D9D90F14D87D3DC2D8CB",
            "InvoiceID":
                "6F1DFD1D0FE8A32E40E1F2C05CF1C15545BAB56B617F9C6C2D63A6B704BEF59B",
            "Paths": [
                [[ "currency": "BTC", "issuer": "r9vbV3EHvXWjSkeQ6CAcYVPGeq7TuiXY2X" ]]
            ],
            "SendMax": "100000000"
        ] as! [String: AnyObject]
    }

    func testA() {
        let tx = try! Payment(json: TestUPayment.baseTx)
        do {
            try validatePayment(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

//    func testValidMemos() {
//        TestAccountSet.baseTx["SetFlag"] = "abc" as AnyObject
//        let tx = try! AccountSet(json: TestAccountSet.baseTx)
//        XCTAssertThrowsError(try validateAccountSet(tx: tx.toJson()))
//    }

    func testMissingAmount() {
        TestUPayment.setUp()
        TestUPayment.baseTx["Amount"] = nil
//        let tx = try! Payment(json: TestUPayment.baseTx)
        XCTAssertThrowsError(try Payment(json: TestUPayment.baseTx))
//        XCTAssertThrowsError(try validatePayment(tx: tx.toJson()))
    }

    func testInvalidAmount() {
        TestUPayment.setUp()
        TestUPayment.baseTx["Amount"] = 1234 as AnyObject
//        let tx = try! Payment(json: TestUPayment.baseTx)
        XCTAssertThrowsError(try Payment(json: TestUPayment.baseTx))
//        XCTAssertThrowsError(try validatePayment(tx: tx.toJson()))
    }

    func testMissingDestination() {
        TestUPayment.setUp()
        TestUPayment.baseTx["Destination"] = nil
//        let tx = try! Payment(json: TestUPayment.baseTx)
        XCTAssertThrowsError(try Payment(json: TestUPayment.baseTx))
//        XCTAssertThrowsError(try validatePayment(tx: tx.toJson()))
    }

    func testInvalidDestination() {
        TestUPayment.setUp()
        TestUPayment.baseTx["Destination"] = 7896214 as AnyObject
//        let tx = try! Payment(json: TestUPayment.baseTx)
        XCTAssertThrowsError(try Payment(json: TestUPayment.baseTx))
//        XCTAssertThrowsError(try validatePayment(tx: tx.toJson()))
    }

    func testInvalidDestinationTag() {
        TestUPayment.setUp()
        TestUPayment.baseTx["DestinationTag"] = "1" as AnyObject
//        let tx = try! Payment(json: TestUPayment.baseTx)
        XCTAssertThrowsError(try Payment(json: TestUPayment.baseTx))
//        XCTAssertThrowsError(try validatePayment(tx: tx.toJson()))
    }

    func testInvalidInvoiceID() {
        TestUPayment.setUp()
        TestUPayment.baseTx["InvoiceID"] = 19832 as AnyObject
//        let tx = try! Payment(json: TestUPayment.baseTx)
        XCTAssertThrowsError(try Payment(json: TestUPayment.baseTx))
//        XCTAssertThrowsError(try validatePayment(tx: tx.toJson()))
    }

    func testInvalidPaths() {
        TestUPayment.setUp()
        TestUPayment.baseTx["Paths"] = [[[ "account": 123 ]]] as AnyObject
//        let tx = try! Payment(json: TestUPayment.baseTx)
        XCTAssertThrowsError(try Payment(json: TestUPayment.baseTx))
//        XCTAssertThrowsError(try validatePayment(tx: tx.toJson()))
    }

    func testInvalidSendMax() {
        TestUPayment.setUp()
        print(TestUPayment.baseTx["SendMax"])
        TestUPayment.baseTx["SendMax"] = 100000001 as AnyObject
        print(TestUPayment.baseTx["SendMax"])
//        let tx = try! Payment(json: TestUPayment.baseTx)
        XCTAssertThrowsError(try Payment(json: TestUPayment.baseTx))
//        XCTAssertThrowsError(try validatePayment(tx: tx.toJson()))
    }

    func testValidDeliverMinFlagInt() {
        TestUPayment.setUp()
        TestUPayment.baseTx["DeliverMin"] = "100000000" as AnyObject
        TestUPayment.baseTx["Flags"] = PaymentFlags.tfPartialPayment.rawValue as AnyObject
        let tx = try! Payment(json: TestUPayment.baseTx)
        do {
            try validatePayment(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    // MARK: Cannot set flags to bool as of now
//    func testValidDeliverMinFlagBool() {
//        TestUPayment.baseTx["DeliverMin"] = 100000000 as AnyObject
//        TestUPayment.baseTx["Flags"] = PaymentFlags.tfPartialPayment.rawValue as AnyObject
//        let tx = try! Payment(json: TestUPayment.baseTx)
//        do {
//            try validatePayment(tx: tx.toJson())
//        } catch {
//            XCTAssertNil(error)
//        }
//    }
    func testInvalidDeliverMinNoFlag() {
        TestUPayment.setUp()
        TestUPayment.baseTx["DeliverMin"] = "10000" as AnyObject
        print(TestUPayment.baseTx)
        let tx = try! Payment(json: TestUPayment.baseTx)
        XCTAssertThrowsError(try validatePayment(tx: tx.toJson()))
    }
}
