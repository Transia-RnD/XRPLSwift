//
//  TestUEscrowCancel.swift
//  
//
//  Created by Denis Angell on 8/7/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/models/escrowCancel.ts

import XCTest
@testable import XRPLSwift

final class TestUEscrowCancel: XCTestCase {

    public static var baseTx: [String: AnyObject] = [:]

    override func setUp() async throws {
        TestUEscrowCancel.baseTx = [
            "TransactionType": "EscrowCancel",
            "Account": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
            "Owner": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
            "OfferSequence": 7
        ] as! [String: AnyObject]
    }

    func testA() {
        print(TestUEscrowCancel.baseTx)
        let tx = try! EscrowCancel(json: TestUEscrowCancel.baseTx)
        do {
            try validateEscrowCancel(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    func testInvalidOwnerNil() {
        TestUEscrowCancel.baseTx["Owner"] = nil
        XCTAssertThrowsError(try CheckCancel(json: TestUEscrowCancel.baseTx))
    }

    func testInvalidOwnerType() {
        TestUEscrowCancel.baseTx["Owner"] = 10 as AnyObject
        XCTAssertThrowsError(try CheckCancel(json: TestUEscrowCancel.baseTx))
    }

    func testInvalidOfferSequenceType() {
        TestUEscrowCancel.baseTx["OfferSequence"] = "10" as AnyObject
        XCTAssertThrowsError(try CheckCancel(json: TestUEscrowCancel.baseTx))
    }
}
