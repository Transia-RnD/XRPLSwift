//
//  TestEscrowCancel.swift
//  
//
//  Created by Denis Angell on 8/7/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/models/escrowCancel.ts

import XCTest
@testable import XRPLSwift

final class TestEscrowCancel: XCTestCase {

    public static var baseTx: [String: AnyObject] = [:]

    override func setUp() async throws {
        TestEscrowCancel.baseTx = [
            "TransactionType": "EscrowCancel",
            "Account": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
            "Owner": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
            "OfferSequence": 7
        ] as! [String: AnyObject]
    }

    func testA() {
        print(TestEscrowCancel.baseTx)
        let tx = try! EscrowCancel(json: TestEscrowCancel.baseTx)
        do {
            try validateEscrowCancel(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    func testInvalidOwnerNil() {
        TestEscrowCancel.baseTx["Owner"] = nil
        XCTAssertThrowsError(try CheckCancel(json: TestEscrowCancel.baseTx))
    }

    func testInvalidOwnerType() {
        TestEscrowCancel.baseTx["Owner"] = 10 as AnyObject
        XCTAssertThrowsError(try CheckCancel(json: TestEscrowCancel.baseTx))
    }

    func testInvalidOfferSequenceType() {
        TestEscrowCancel.baseTx["OfferSequence"] = "10" as AnyObject
        XCTAssertThrowsError(try CheckCancel(json: TestEscrowCancel.baseTx))
    }
}
