//
//  TestNFTokenMint.swift
//
//
//  Created by Denis Angell on 8/13/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/models/NFTokenMint.ts

import Foundation

import XCTest
@testable import XRPLSwift

final class TestUNFTokenMint: XCTestCase {

    func testA() {
        let baseTx = [
            "TransactionType": "NFTokenMint",
            "Account": "rWYkbWkCeg8dP6rXALnjgZSjjLyih5NXm",
            "Fee": "5000000",
            "Sequence": 2470665,
            "Flags": NFTokenMintFlags.tfTransferable.rawValue,
            "NFTokenTaxon": 0,
            "Issuer": "r9LqNeG6qHxjeUocjvVki2XR35weJ9mZgQ",
            "TransferFee": 1,
            "URI": "http://xrpl.org".bytes.toHex
        ] as! [String: AnyObject]
        let tx = try! NFTokenMint(json: baseTx)
        do {
            try validateNFTokenMint(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    func testInvalidNoTokenTaxon() {
        let baseTx = [
            "TransactionType": "NFTokenMint",
            "Account": "rWYkbWkCeg8dP6rXALnjgZSjjLyih5NXm",
            "Fee": "5000000",
            "Sequence": 2470665,
            "Flags": NFTokenMintFlags.tfTransferable.rawValue,
//            "NFTokenTaxon": 0,
            "Issuer": "rWYkbWkCeg8dP6rXALnjgZSjjLyih5NXm",
            "TransferFee": 1,
            "URI": "http://xrpl.org".bytes.toHex
        ] as! [String: AnyObject]
        XCTAssertThrowsError(try NFTokenMint(json: baseTx))
    }

    func testInvalidNoAccountEqualIssuer() {
        let baseTx = [
            "TransactionType": "NFTokenMint",
            "Account": "rWYkbWkCeg8dP6rXALnjgZSjjLyih5NXm",
            "Fee": "5000000",
            "Sequence": 2470665,
            "Flags": NFTokenMintFlags.tfTransferable.rawValue,
            "NFTokenTaxon": 0,
            "Issuer": "rWYkbWkCeg8dP6rXALnjgZSjjLyih5NXm",
            "TransferFee": 1,
            "URI": "http://xrpl.org".bytes.toHex
        ] as! [String: AnyObject]
        XCTAssertThrowsError(try NFTokenMint(json: baseTx))
    }

    func testInvalidURIType() {
        let baseTx = [
            "TransactionType": "NFTokenMint",
            "Account": "rWYkbWkCeg8dP6rXALnjgZSjjLyih5NXm",
            "Fee": "5000000",
            "Sequence": 2470665,
            "Flags": NFTokenMintFlags.tfTransferable.rawValue,
            "NFTokenTaxon": 0,
            "Issuer": "r9LqNeG6qHxjeUocjvVki2XR35weJ9mZgQ",
            "TransferFee": 1,
            "URI": "http://xrpl.org"
        ] as! [String: AnyObject]
        XCTAssertThrowsError(try NFTokenMint(json: baseTx))
    }
}
