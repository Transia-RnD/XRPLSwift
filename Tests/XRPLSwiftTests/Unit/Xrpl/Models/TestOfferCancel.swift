//
//  TestOfferCancel.swift
//  
//
//  Created by Denis Angell on 8/7/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/models/offerCancel.ts

import XCTest
@testable import XRPLSwift

final class TestOfferCancel: XCTestCase {

    public static var baseTx: [String: AnyObject] = [:]

    override func setUp() async throws {
        TestOfferCancel.baseTx = [
            "Account": "rnKiczmiQkZFiDES8THYyLA2pQohC5C6EF",
            "Fee": "10",
            "LastLedgerSequence": 65477334,
            "OfferSequence": 60797528,
            "Sequence": 60797535,
            "Flags": 2147483648,
            "SigningPubKey":
                "0369C9BC4D18FAE741898828A1F48E53E53F6F3DB3191441CC85A14D4FC140E031",
            "TransactionType": "OfferCancel",
            "TxnSignature":
                "304402203EC848BD6AB42DC8509285245804B15E1652092CC0B189D369E12E563771D049022046DF40C16EA05DC99D01E553EA2E218FCA1C5B38927889A2BDF064D1F44D60F0"
        ] as! [String: AnyObject]
    }

    func testA() {
        let tx = try! OfferCancel(json: TestOfferCancel.baseTx)
        do {
            try validateOfferCancel(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    func testValidOfferCancelFlags() {
        TestOfferCancel.baseTx["Flags"] = 2147483648 as AnyObject
        let tx = try! OfferCancel(json: TestOfferCancel.baseTx)
        do {
            try validateOfferCancel(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    func testInvalidOfferSequenceType() {
        TestOfferCancel.baseTx["OfferSequence"] = "10" as AnyObject
        XCTAssertThrowsError(try OfferCancel(json: TestOfferCancel.baseTx))
    }

    func testInvalidOfferSequenceNil() {
        TestOfferCancel.baseTx["OfferSequence"] = nil
        XCTAssertThrowsError(try OfferCancel(json: TestOfferCancel.baseTx))
    }
}
