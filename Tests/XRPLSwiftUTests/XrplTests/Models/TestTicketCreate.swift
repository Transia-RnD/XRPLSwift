//
//  TestTicketCreate.swift
//  
//
//  Created by Denis Angell on 8/13/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/models/ticketCreate.ts

import Foundation

import XCTest
@testable import XRPLSwift

final class TestUTicketCreate: XCTestCase {

    public static var baseTx: [String: AnyObject] = [:]

    override class func setUp() {
        baseTx = [
            "TransactionType": "TicketCreate",
            "Account": "rUn84CUYbNjRoTQ6mSW7BVJPSVJNLb1QLo",
            "TicketCount": 150
        ] as! [String: AnyObject]
    }

    func testA() {
        TestUTicketCreate.setUp()
        let tx = try! TicketCreate(json: TestUTicketCreate.baseTx)
        do {
            try validateTicketCreate(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    func testInvalidTicketCountNil() {
        TestUTicketCreate.setUp()
        TestUTicketCreate.baseTx["TicketCount"] = nil
        XCTAssertThrowsError(try TicketCreate(json: TestUTicketCreate.baseTx))
    }

    func testInvalidTicketCountTypeInt() {
        TestUTicketCreate.setUp()
        TestUTicketCreate.baseTx["TicketCount"] = "100" as AnyObject
        XCTAssertThrowsError(try TicketCreate(json: TestUTicketCreate.baseTx))
    }

    func testInvalidTicketCountTypeDouble() {
        TestUTicketCreate.setUp()
        TestUTicketCreate.baseTx["TicketCount"] = "12.5" as AnyObject
        XCTAssertThrowsError(try TicketCreate(json: TestUTicketCreate.baseTx))
    }

    func testInvalidTicketCountLess() {
        TestUTicketCreate.setUp()
        TestUTicketCreate.baseTx["TicketCount"] = 0 as AnyObject
        XCTAssertThrowsError(try TicketCreate(json: TestUTicketCreate.baseTx))
    }

    func testInvalidTicketCountGreater() {
        TestUTicketCreate.setUp()
        TestUTicketCreate.baseTx["TicketCount"] = 251 as AnyObject
        XCTAssertThrowsError(try TicketCreate(json: TestUTicketCreate.baseTx))
    }
}
