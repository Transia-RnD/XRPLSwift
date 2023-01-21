//
//  TestDepositPreauth.swift
//
//
//  Created by Denis Angell on 8/7/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/models/depositPreauth.test.ts

import XCTest
@testable import XRPLSwift

final class TestDepositPreauth: XCTestCase {

    public static var baseTx: [String: AnyObject] = [:]

    override func setUp() async throws {
        TestDepositPreauth.baseTx = [
            "TransactionType": "DepositPreauth",
            "Account": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn"
        ] as! [String: AnyObject]
    }

    func testA() {
        TestDepositPreauth.baseTx["Authorize"] = "rsA2LpzuawewSBQXkiju3YQTMzW13pAAdW" as AnyObject
        let tx = try! DepositPreauth(json: TestDepositPreauth.baseTx)
        do {
            try validateDepositPreauth(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    func testB() {
        TestDepositPreauth.setUp()
        TestDepositPreauth.baseTx["Unauthorize"] = "raKEEVSGnKSD9Zyvxu4z6Pqpm4ABH8FS6n" as AnyObject
        let tx = try! DepositPreauth(json: TestDepositPreauth.baseTx)
        do {
            try validateDepositPreauth(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    func testInvalidBoth() {
        TestDepositPreauth.setUp()
        TestDepositPreauth.baseTx["Authorize"] = "rsA2LpzuawewSBQXkiju3YQTMzW13pAAdW" as AnyObject
        TestDepositPreauth.baseTx["Unauthorize"] = "raKEEVSGnKSD9Zyvxu4z6Pqpm4ABH8FS6n" as AnyObject
        let tx = try! DepositPreauth(json: TestDepositPreauth.baseTx)
        XCTAssertThrowsError(try validateCheckCancel(tx: tx.toJson()))
    }

    func testInvalidNeither() {
        TestDepositPreauth.setUp()
        let tx = try! DepositPreauth(json: TestDepositPreauth.baseTx)
        XCTAssertThrowsError(try validateCheckCancel(tx: tx.toJson()))
    }

    func testInvalidAuthorize() {
        TestDepositPreauth.setUp()
        TestDepositPreauth.baseTx["Authorize"] = 1234 as AnyObject
        //        let tx = try! DepositPreauth(json: TestDepositPreauth.baseTx)
        XCTAssertThrowsError(try DepositPreauth(json: TestDepositPreauth.baseTx))
        //        XCTAssertThrowsError(try validateCheckCancel(tx: tx.toJson()))
    }

    func testInvalidAuthorizeOwn() {
        TestDepositPreauth.setUp()
        TestDepositPreauth.baseTx["Authorize"] = "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn" as AnyObject
        let tx = try! DepositPreauth(json: TestDepositPreauth.baseTx)
        XCTAssertThrowsError(try validateCheckCancel(tx: tx.toJson()))
    }

    func testInvalidUnauthorize() {
        TestDepositPreauth.setUp()
        TestDepositPreauth.baseTx["Unauthorize"] = 1234 as AnyObject
        //        let tx = try! DepositPreauth(json: TestDepositPreauth.baseTx)
        XCTAssertThrowsError(try DepositPreauth(json: TestDepositPreauth.baseTx))
        //        XCTAssertThrowsError(try validateCheckCancel(tx: tx.toJson()))
    }

    func testInvalidUnauthorizeOwn() {
        TestDepositPreauth.setUp()
        TestDepositPreauth.baseTx["Unauthorize"] = "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn" as AnyObject
        let tx = try! DepositPreauth(json: TestDepositPreauth.baseTx)
        XCTAssertThrowsError(try validateCheckCancel(tx: tx.toJson()))
    }
}
