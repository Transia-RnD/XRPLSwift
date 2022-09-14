//
//  TestUEscrowFinish.swift
//  
//
//  Created by Denis Angell on 8/7/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/models/escrowFinish.ts

import XCTest
@testable import XRPLSwift

final class TestUEscrowFinish: XCTestCase {

    public static var baseTx: [String: AnyObject] = [:]

    override func setUp() async throws {
        TestUEscrowFinish.baseTx = [
            "Account": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
            "TransactionType": "EscrowFinish",
            "Owner": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
            "OfferSequence": 7,
            "Condition":
                "A0258020E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855810100",
            "Fulfillment": "A0028000"
        ] as! [String: AnyObject]
    }

    func testA() {
        print(TestUEscrowFinish.baseTx)
        let tx = try! EscrowFinish(json: TestUEscrowFinish.baseTx)
        do {
            try validateEscrowFinish(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    func testInvalidWOOption() {
        TestUEscrowFinish.baseTx["Condition"] = nil
        TestUEscrowFinish.baseTx["Fulfillment"] = nil
        let tx = try! EscrowFinish(json: TestUEscrowFinish.baseTx)
        do {
            try validateEscrowFinish(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    func testInvalidOwnerNil() {
        TestUEscrowFinish.baseTx["Owner"] = 0x15415253 as AnyObject
        XCTAssertThrowsError(try EscrowFinish(json: TestUEscrowFinish.baseTx))
    }

    func testInvalidOfferSequenceNil() {
        TestUEscrowFinish.baseTx["OfferSequence"] = "10" as AnyObject
        XCTAssertThrowsError(try EscrowFinish(json: TestUEscrowFinish.baseTx))
    }

    func testInvalidConditionNil() {
        TestUEscrowFinish.baseTx["Condition"] = 10 as AnyObject
        XCTAssertThrowsError(try EscrowFinish(json: TestUEscrowFinish.baseTx))
    }

    func testInvalidFulfillmentNil() {
        TestUEscrowFinish.baseTx["Fulfillment"] = 0x142341 as AnyObject
        XCTAssertThrowsError(try EscrowFinish(json: TestUEscrowFinish.baseTx))
    }
}
