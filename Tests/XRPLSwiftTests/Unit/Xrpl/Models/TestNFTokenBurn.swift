//
//  TestNFTokenBurn.swift
//
//
//  Created by Denis Angell on 8/13/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/models/NFTokenBurn.ts

import Foundation

import XCTest
@testable import XRPLSwift

final class TestNFTokenBurn: XCTestCase {

    public static var baseTx: [String: AnyObject] = [:]

    override class func setUp() {
        baseTx = [
            "TransactionType": "NFTokenBurn",
            "NFTokenID": "00090032B5F762798A53D543A014CAF8B297CFF8F2F937E844B17C9E00000003",
            "Account": "rWYkbWkCeg8dP6rXALnjgZSjjLyih5NXm",
            "Fee": "5000000",
            "Sequence": 2470665,
            "Flags": 2147483648
        ] as! [String: AnyObject]
    }

    func testValid() {
        let tx = try! NFTokenBurn(json: TestNFTokenBurn.baseTx)
        do {
            try validateNFTokenBurn(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    func testInvalidLimitAmountNil() {
        TestNFTokenBurn.baseTx["NFTokenID"] = nil
        XCTAssertThrowsError(try TrustSet(json: TestNFTokenBurn.baseTx))
    }
}
