//
//  TestAccountDelete.swift
//
//
//  Created by Denis Angell on 6/4/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/models/accountDelete.ts

import XCTest
@testable import XRPLSwift

final class TestAccountDelete: XCTestCase {

    func testA() {
        let txJson: [String: AnyObject] = [
            "TransactionType": "AccountDelete",
            "Account": "rWYkbWkCeg8dP6rXALnjgZSjjLyih5NXm",
            "Destination": "rPT1Sjq2YGrBMTttX4GZHjKu9dyfzbpAYe",
            "DestinationTag": 13,
            "Fee": "5000000",
            "Sequence": 2470665,
            "Flags": 2147483648
        ] as! [String: AnyObject]
        print(txJson)
        let tx = try! AccountDelete(json: txJson)
        do {
            print(try! tx.toJson())
            try validateAccountDelete(tx: tx.toJson())
        } catch {
            print(error.localizedDescription)
        }
    }

    // TODO: Review By XRPLF
    // If Destination is NOT included, the error is thrown at Transaction () not at validation
    func testInvalidAccount() {
        let txJson: [String: AnyObject] = [
            "TransactionType": "AccountDelete",
            "Account": "rWYkbWkCeg8dP6rXALnjgZSjjLyih5NXm",
            "Fee": "5000000",
            "Sequence": 2470665,
            "Flags": 2147483648
        ] as! [String: AnyObject]
        print(txJson)
        do {
            _ = try AccountDelete(json: txJson)
        } catch {
            XCTAssertEqual(error.localizedDescription, "The data couldn’t be read because it is missing.")
        }
    }

    func testInvalidDestination() {
        let txJson: [String: AnyObject] = [
            "TransactionType": "AccountDelete",
            "Account": "rWYkbWkCeg8dP6rXALnjgZSjjLyih5NXm",
            "Destination": "65478965",
            "Fee": "5000000",
            "Sequence": 2470665,
            "Flags": 2147483648
        ] as! [String: AnyObject]
        let tx = try! AccountDelete(json: txJson)
        XCTAssertThrowsError(try validateAccountDelete(tx: tx.toJson()))
    }

    func testInvalidDestinationTag() {
        let txJson: [String: AnyObject] = [
            "TransactionType": "AccountDelete",
            "Account": "rWYkbWkCeg8dP6rXALnjgZSjjLyih5NXm",
            "Destination": "rPT1Sjq2YGrBMTttX4GZHjKu9dyfzbpAYe",
            "DestinationTag": "gvftyujnbv",
            "Fee": "5000000",
            "Sequence": 2470665,
            "Flags": 2147483648
        ] as! [String: AnyObject]
        // TODO: Review
        // The second (validation) is not reached because types are checked at decode, and validation is checked later
        XCTAssertThrowsError(try AccountDelete(json: txJson))
//        XCTAssertThrowsError(try validateAccountDelete(tx: tx.toJson()))
    }
}
