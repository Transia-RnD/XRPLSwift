//
//  TestNFTokenCreateOffer.swift
//
//
//  Created by Denis Angell on 8/13/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/models/NFTokenCreateOffer.ts

import Foundation

import XCTest
@testable import XRPLSwift

final class TestNFTokenCreateOffer: XCTestCase {

    func testA() {
        let baseTx = [
            "TransactionType": "NFTokenCreateOffer",
            "NFTokenID": "00090032B5F762798A53D543A014CAF8B297CFF8F2F937E844B17C9E00000003",
            "Amount": "1",
            "Owner": "r9LqNeG6qHxjeUocjvVki2XR35weJ9mZgQ",
            "Expiration": 1000,
            "Account": "rWYkbWkCeg8dP6rXALnjgZSjjLyih5NXm",
            "Destination": "r9LqNeG6qHxjeUocjvVki2XR35weJ9mZgQ",
            "Fee": "5000000",
            "Sequence": 2470665
        ] as! [String: AnyObject]
        let tx = try! NFTokenCreateOffer(json: baseTx)
        do {
            try validateNFTokenCreateOffer(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    func testB() {
        let baseTx = [
            "TransactionType": "NFTokenCreateOffer",
            "NFTokenID": "00090032B5F762798A53D543A014CAF8B297CFF8F2F937E844B17C9E00000003",
            "Amount": "1",
            "Flags": NFTokenCreateOfferFlags.tfSellNFToken.rawValue,
            "Expiration": 1000,
            "Destination": "r9LqNeG6qHxjeUocjvVki2XR35weJ9mZgQ",
            "Account": "rWYkbWkCeg8dP6rXALnjgZSjjLyih5NXm",
            "Fee": "5000000",
            "Sequence": 2470665
        ] as! [String: AnyObject]
        let tx = try! NFTokenCreateOffer(json: baseTx)
        do {
            try validateNFTokenCreateOffer(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    func testC() {
        let baseTx = [
            "TransactionType": "NFTokenCreateOffer",
            "NFTokenID": "00090032B5F762798A53D543A014CAF8B297CFF8F2F937E844B17C9E00000003",
            "Amount": "0",
            "Flags": NFTokenCreateOfferFlags.tfSellNFToken.rawValue,
            "Expiration": 1000,
            "Destination": "r9LqNeG6qHxjeUocjvVki2XR35weJ9mZgQ",
            "Account": "rWYkbWkCeg8dP6rXALnjgZSjjLyih5NXm",
            "Fee": "5000000",
            "Sequence": 2470665
        ] as! [String: AnyObject]
        let tx = try! NFTokenCreateOffer(json: baseTx)
        do {
            try validateNFTokenCreateOffer(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    func testInvalidAccountEqualOwner() {
        let baseTx = [
            "TransactionType": "NFTokenCreateOffer",
            "NFTokenID": "00090032B5F762798A53D543A014CAF8B297CFF8F2F937E844B17C9E00000003",
            "Amount": "1",
            "Owner": "rWYkbWkCeg8dP6rXALnjgZSjjLyih5NXm",
            "Expiration": 1000,
            "Account": "rWYkbWkCeg8dP6rXALnjgZSjjLyih5NXm",
            "Fee": "5000000",
            "Sequence": 2470665
        ] as! [String: AnyObject]
        let tx = try! NFTokenCreateOffer(json: baseTx)
        XCTAssertThrowsError(try validateNFTokenCreateOffer(tx: tx.toJson()))
    }

    func testInvalidAccountEqualDest() {
        let baseTx = [
            "TransactionType": "NFTokenCreateOffer",
            "NFTokenID": "00090032B5F762798A53D543A014CAF8B297CFF8F2F937E844B17C9E00000003",
            "Amount": "1",
            "Destination": "rWYkbWkCeg8dP6rXALnjgZSjjLyih5NXm",
            "Expiration": 1000,
            "Account": "rWYkbWkCeg8dP6rXALnjgZSjjLyih5NXm",
            "Fee": "5000000",
            "Sequence": 2470665
        ] as! [String: AnyObject]
        let tx = try! NFTokenCreateOffer(json: baseTx)
        XCTAssertThrowsError(try validateNFTokenCreateOffer(tx: tx.toJson()))
    }

    func testInvalidNFTokenIDNil() {
        let baseTx = [
            "TransactionType": "NFTokenCreateOffer",
            "NFTokenID": nil,
            "Amount": "1",
            "Destination": "rWYkbWkCeg8dP6rXALnjgZSjjLyih5NXm",
            "Expiration": 1000,
            "Account": "rWYkbWkCeg8dP6rXALnjgZSjjLyih5NXm",
            "Fee": "5000000",
            "Sequence": 2470665
        ] as! [String: AnyObject]
        XCTAssertThrowsError(try NFTokenCreateOffer(json: baseTx))
    }

    func testInvalidAmountType() {
        let baseTx = [
            "TransactionType": "NFTokenCreateOffer",
            "NFTokenID": "00090032B5F762798A53D543A014CAF8B297CFF8F2F937E844B17C9E00000003",
            "Amount": 1,
            "Destination": "rWYkbWkCeg8dP6rXALnjgZSjjLyih5NXm",
            "Expiration": 1000,
            "Account": "rWYkbWkCeg8dP6rXALnjgZSjjLyih5NXm",
            "Fee": "5000000",
            "Sequence": 2470665
        ] as! [String: AnyObject]
        XCTAssertThrowsError(try NFTokenCreateOffer(json: baseTx))
    }

    func testInvalidAmountNil() {
        let baseTx = [
            "TransactionType": "NFTokenCreateOffer",
            "NFTokenID": "00090032B5F762798A53D543A014CAF8B297CFF8F2F937E844B17C9E00000003",
            "Amount": nil,
            "Destination": "rWYkbWkCeg8dP6rXALnjgZSjjLyih5NXm",
            "Expiration": 1000,
            "Account": "rWYkbWkCeg8dP6rXALnjgZSjjLyih5NXm",
            "Fee": "5000000",
            "Sequence": 2470665
        ] as! [String: AnyObject]
        XCTAssertThrowsError(try NFTokenCreateOffer(json: baseTx))
    }

    func testInvalidOwnerWithSell() {
        let baseTx = [
            "TransactionType": "NFTokenCreateOffer",
            "NFTokenID": "00090032B5F762798A53D543A014CAF8B297CFF8F2F937E844B17C9E00000003",
            "Flags": NFTokenCreateOfferFlags.tfSellNFToken.rawValue,
            "Amount": "1",
            "Owner": "r9LqNeG6qHxjeUocjvVki2XR35weJ9mZgQ",
            "Expiration": 1000,
            "Account": "rWYkbWkCeg8dP6rXALnjgZSjjLyih5NXm",
            "Fee": "5000000",
            "Sequence": 2470665
        ] as! [String: AnyObject]
        let tx = try! NFTokenCreateOffer(json: baseTx)
        XCTAssertThrowsError(try validateNFTokenCreateOffer(tx: tx.toJson()))
    }

    func testInvalidNoOwnerWithBuy() {
        let baseTx = [
            "TransactionType": "NFTokenCreateOffer",
            "NFTokenID": "00090032B5F762798A53D543A014CAF8B297CFF8F2F937E844B17C9E00000003",
            "Amount": "1",
            "Expiration": 1000,
            "Account": "rWYkbWkCeg8dP6rXALnjgZSjjLyih5NXm",
            "Fee": "5000000",
            "Sequence": 2470665
        ] as! [String: AnyObject]
        let tx = try! NFTokenCreateOffer(json: baseTx)
        XCTAssertThrowsError(try validateNFTokenCreateOffer(tx: tx.toJson()))
    }

    func testInvalidBuyZeroAmount() {
        let baseTx = [
            "TransactionType": "NFTokenCreateOffer",
            "NFTokenID": "00090032B5F762798A53D543A014CAF8B297CFF8F2F937E844B17C9E00000003",
            "Amount": "0",
            "Expiration": 1000,
            "Account": "rWYkbWkCeg8dP6rXALnjgZSjjLyih5NXm",
            "Owner": "r9LqNeG6qHxjeUocjvVki2XR35weJ9mZgQ",
            "Fee": "5000000",
            "Sequence": 2470665
        ] as! [String: AnyObject]
        let tx = try! NFTokenCreateOffer(json: baseTx)
        XCTAssertThrowsError(try validateNFTokenCreateOffer(tx: tx.toJson()))
    }
}
