//
//  TestEscrowFinish.swift
//  
//
//  Created by Denis Angell on 8/7/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/models/escrowFinish.ts

import XCTest
@testable import XRPLSwift

final class TestEscrowFinish: XCTestCase {

    public static var baseTx: [String: AnyObject] = [:]

    override func setUp() async throws {
        TestEscrowFinish.baseTx = [
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
        let tx = try! EscrowFinish(json: TestEscrowFinish.baseTx)
        do {
            try validateEscrowFinish(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    func testInvalidWOOption() {
        TestEscrowFinish.setUp()
        TestEscrowFinish.baseTx["Condition"] = nil
        TestEscrowFinish.baseTx["Fulfillment"] = nil
        let tx = try! EscrowFinish(json: TestEscrowFinish.baseTx)
        do {
            try validateEscrowFinish(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    func testInvalidOwnerNil() {
        TestEscrowFinish.setUp()
        TestEscrowFinish.baseTx["Owner"] = 0x15415253 as AnyObject
        XCTAssertThrowsError(try EscrowFinish(json: TestEscrowFinish.baseTx))
    }

    func testInvalidOfferSequenceNil() {
        TestEscrowFinish.setUp()
        TestEscrowFinish.baseTx["OfferSequence"] = "10" as AnyObject
        XCTAssertThrowsError(try EscrowFinish(json: TestEscrowFinish.baseTx))
    }

    func testInvalidConditionNil() {
        TestEscrowFinish.setUp()
        TestEscrowFinish.baseTx["Condition"] = 10 as AnyObject
        XCTAssertThrowsError(try EscrowFinish(json: TestEscrowFinish.baseTx))
    }

    func testInvalidFulfillmentNil() {
        TestEscrowFinish.setUp()
        TestEscrowFinish.baseTx["Fulfillment"] = 0x142341 as AnyObject
        XCTAssertThrowsError(try EscrowFinish(json: TestEscrowFinish.baseTx))
    }
}
