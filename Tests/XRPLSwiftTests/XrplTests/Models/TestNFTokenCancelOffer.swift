//
//  TestNFTokenCancelOffer.swift
//
//
//  Created by Denis Angell on 8/13/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/models/NFTokenCancelOffer.ts

import Foundation

import XCTest
@testable import XRPLSwift

final class TestUNFTokenCancelOffer: XCTestCase {

    public static var baseTx: [String: AnyObject] = [:]

    override class func setUp() {
        baseTx = [
            "TransactionType": "NFTokenCancelOffer",
            "NFTokenOffers": ["AED08CC1F50DD5F23A1948AF86153A3F3B7593E5EC77D65A02BB1B29E05AB6AF"],
            "Account": "rWYkbWkCeg8dP6rXALnjgZSjjLyih5NXm",
            "Fee": "5000000",
            "Sequence": 2470665,
            "Flags": 2147483648
        ] as! [String: AnyObject]
    }

    func testA() {
        let tx = try! NFTokenCancelOffer(json: TestUNFTokenCancelOffer.baseTx)
        do {
            try validateNFTokenCancelOffer(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    func testInvalidLimitAmountNil() {
        TestUNFTokenCancelOffer.baseTx["NFTokenOffers"] = nil
        XCTAssertThrowsError(try NFTokenCancelOffer(json: TestUNFTokenCancelOffer.baseTx))
    }

    func testInvalidLimitAmountEmpty() {
        TestUNFTokenCancelOffer.baseTx["NFTokenOffers"] = [] as AnyObject
        XCTAssertThrowsError(try NFTokenCancelOffer(json: TestUNFTokenCancelOffer.baseTx))
    }
}
