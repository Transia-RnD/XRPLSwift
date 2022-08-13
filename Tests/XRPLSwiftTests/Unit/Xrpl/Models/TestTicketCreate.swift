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

final class TestTicketCreate: XCTestCase {
    
    public static var baseTx: [String: AnyObject] = [:]
    
    override class func setUp() {
        baseTx = [
            "TransactionType": "TicketCreate",
            "Account": "rUn84CUYbNjRoTQ6mSW7BVJPSVJNLb1QLo",
            "TicketCount": 150,
        ] as! [String: AnyObject]
    }
    
    func testValid() {
        let tx = try! TicketCreate(json: TestTicketCreate.baseTx)
        do {
            try validateTicketCreate(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }
    
    func testInvalidTicketCountNil() {
        TestTicketCreate.baseTx["TicketCount"] = nil
        XCTAssertThrowsError(try TicketCreate(json: TestTicketCreate.baseTx))
    }
    
    func testInvalidTicketCountTypeInt() {
        TestTicketCreate.baseTx["TicketCount"] = "100" as AnyObject
        XCTAssertThrowsError(try TicketCreate(json: TestTicketCreate.baseTx))
    }
    
    func testInvalidTicketCountTypeDouble() {
        TestTicketCreate.baseTx["TicketCount"] = "12.5" as AnyObject
        XCTAssertThrowsError(try TicketCreate(json: TestTicketCreate.baseTx))
    }
    
    func testInvalidTicketCountLess() {
        TestTicketCreate.baseTx["TicketCount"] = 0 as AnyObject
        XCTAssertThrowsError(try TicketCreate(json: TestTicketCreate.baseTx))
    }
    
    func testInvalidTicketCountGreater() {
        TestTicketCreate.baseTx["TicketCount"] = 251 as AnyObject
        XCTAssertThrowsError(try TicketCreate(json: TestTicketCreate.baseTx))
    }
}

