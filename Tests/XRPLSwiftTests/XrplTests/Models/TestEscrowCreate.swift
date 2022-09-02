//
//  TestUEscrowCreate.swift
//  
//
//  Created by Denis Angell on 8/7/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/models/escrowCreate.ts

import XCTest
@testable import XRPLSwift

final class TestUEscrowCreate: XCTestCase {

    public static var baseTx: [String: AnyObject] = [:]

    override func setUp() async throws {
        TestUEscrowCreate.baseTx = [
            "Account": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
            "TransactionType": "EscrowCreate",
            "Amount": "10000",
            "Destination": "rsA2LpzuawewSBQXkiju3YQTMzW13pAAdW",
            "CancelAfter": 533257958,
            "FinishAfter": 533171558,
            "Condition":
                "A0258020E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855810100",
            "DestinationTag": 23480,
            "SourceTag": 11747
        ] as! [String: AnyObject]
    }

    func testA() {
        print(TestUEscrowCreate.baseTx)
        let tx = try! EscrowCreate(json: TestUEscrowCreate.baseTx)
        do {
            try validateEscrowCreate(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    func testInvalidAmountNil() {
        TestUEscrowCreate.baseTx["Amount"] = nil
        XCTAssertThrowsError(try EscrowCreate(json: TestUEscrowCreate.baseTx))
    }

    func testInvalidDestinationNil() {
        TestUEscrowCreate.baseTx["Destination"] = nil
        XCTAssertThrowsError(try EscrowCreate(json: TestUEscrowCreate.baseTx))
    }

    func testInvalidDestinationType() {
        TestUEscrowCreate.baseTx["Destination"] = 10 as AnyObject
        XCTAssertThrowsError(try EscrowCreate(json: TestUEscrowCreate.baseTx))
    }

    func testInvalidAmountType() {
        TestUEscrowCreate.baseTx["Amount"] = 1000 as AnyObject
        XCTAssertThrowsError(try EscrowCreate(json: TestUEscrowCreate.baseTx))
    }

    func testInvalidCancelAfterType() {
        TestUEscrowCreate.baseTx["CancelAfter"] = "1000" as AnyObject
        XCTAssertThrowsError(try EscrowCreate(json: TestUEscrowCreate.baseTx))
    }

    func testInvalidFinishAfterType() {
        TestUEscrowCreate.baseTx["FinishAfter"] = "1000" as AnyObject
        XCTAssertThrowsError(try EscrowCreate(json: TestUEscrowCreate.baseTx))
    }

    func testInvalidConditionType() {
        TestUEscrowCreate.baseTx["Condition"] = 0x141243 as AnyObject
        XCTAssertThrowsError(try EscrowCreate(json: TestUEscrowCreate.baseTx))
    }

    func testInvalidDestinationTagType() {
        TestUEscrowCreate.baseTx["DestinationTag"] = "100" as AnyObject
        XCTAssertThrowsError(try EscrowCreate(json: TestUEscrowCreate.baseTx))
    }

    func testInvalidCancelAndFinish() {
        TestUEscrowCreate.baseTx["CancelAfter"] = nil
        TestUEscrowCreate.baseTx["FinishAfter"] = nil
        let tx = try! EscrowCreate(json: TestUEscrowCreate.baseTx)
        XCTAssertThrowsError(try validateEscrowCreate(tx: tx.toJson()))
    }

    func testInvalidConditionAndFinish() {
        TestUEscrowCreate.baseTx["Condition"] = nil
        TestUEscrowCreate.baseTx["FinishAfter"] = nil
        let tx = try! EscrowCreate(json: TestUEscrowCreate.baseTx)
        XCTAssertThrowsError(try validateEscrowCreate(tx: tx.toJson()))
    }
}
