//
//  TestDepositPreauth.swift
//
//
//  Created by Denis Angell on 8/7/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/models/depositPreauth.ts

import XCTest
@testable import XRPLSwift

final class TestUDepositPreauth: XCTestCase {

    public static var baseTx: [String: AnyObject] = [:]

    override func setUp() async throws {
        TestUDepositPreauth.baseTx = [
            "TransactionType": "DepositPreauth",
            "Account": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn"
        ] as! [String: AnyObject]
    }

    func testA() {
        TestUDepositPreauth.baseTx["Authorize"] = "rsA2LpzuawewSBQXkiju3YQTMzW13pAAdW" as AnyObject
        let tx = try! DepositPreauth(json: TestUDepositPreauth.baseTx)
        do {
            try validateDepositPreauth(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    func testB() {
        TestUDepositPreauth.baseTx["Unauthorize"] = "raKEEVSGnKSD9Zyvxu4z6Pqpm4ABH8FS6n" as AnyObject
        let tx = try! DepositPreauth(json: TestUDepositPreauth.baseTx)
        do {
            try validateDepositPreauth(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    func testInvalidBoth() {
        TestUDepositPreauth.baseTx["Authorize"] = "rsA2LpzuawewSBQXkiju3YQTMzW13pAAdW" as AnyObject
        TestUDepositPreauth.baseTx["Unauthorize"] = "raKEEVSGnKSD9Zyvxu4z6Pqpm4ABH8FS6n" as AnyObject
        let tx = try! DepositPreauth(json: TestUDepositPreauth.baseTx)
        XCTAssertThrowsError(try validateCheckCancel(tx: tx.toJson()))
    }

    func testInvalidNeither() {
        let tx = try! DepositPreauth(json: TestUDepositPreauth.baseTx)
        XCTAssertThrowsError(try validateCheckCancel(tx: tx.toJson()))
    }

    func testInvalidAuthorize() {
        TestUDepositPreauth.baseTx["Authorize"] = 1234 as AnyObject
//        let tx = try! DepositPreauth(json: TestDepositPreauth.baseTx)
        XCTAssertThrowsError(try DepositPreauth(json: TestUDepositPreauth.baseTx))
//        XCTAssertThrowsError(try validateCheckCancel(tx: tx.toJson()))
    }

    func testInvalidAuthorizeOwn() {
        TestUDepositPreauth.baseTx["Authorize"] = "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn" as AnyObject
        let tx = try! DepositPreauth(json: TestUDepositPreauth.baseTx)
        XCTAssertThrowsError(try validateCheckCancel(tx: tx.toJson()))
    }

    func testInvalidUnauthorize() {
        TestUDepositPreauth.baseTx["Unauthorize"] = 1234 as AnyObject
//        let tx = try! DepositPreauth(json: TestDepositPreauth.baseTx)
        XCTAssertThrowsError(try DepositPreauth(json: TestUDepositPreauth.baseTx))
//        XCTAssertThrowsError(try validateCheckCancel(tx: tx.toJson()))
    }

    func testInvalidUnauthorizeOwn() {
        TestUDepositPreauth.baseTx["Unauthorize"] = "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn" as AnyObject
        let tx = try! DepositPreauth(json: TestUDepositPreauth.baseTx)
        XCTAssertThrowsError(try validateCheckCancel(tx: tx.toJson()))
    }
}
