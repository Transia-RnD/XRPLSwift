//
//  TestCheckCancel.swift
//
//
//  Created by Denis Angell on 6/4/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/models/checkCancel.ts

import XCTest
@testable import XRPLSwift

final class TestCheckCancel: XCTestCase {

    func testA() {
        let baseTx = [
            "TransactionType": "CheckCancel",
            "Account": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
            "CheckID": "49647F0D748DC3FE26BDACBC57F251AADEFFF391403EC9BF87C97F67E9977FB0"
        ] as! [String: AnyObject]
        let tx = try! CheckCancel(json: baseTx)
        do {
            try validateCheckCancel(tx: tx.toJson())
        } catch {
            XCTAssertNil(error)
        }
    }

    func testInvalidCheckCancel() {
        let baseTx = [
            "TransactionType": "CheckCancel",
            "Account": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
            "CheckID": 4964734566545678
        ] as! [String: AnyObject]
        XCTAssertThrowsError(try CheckCancel(json: baseTx))
        // MARK: This is because the fields are validated on init
        //        let tx = try! CheckCancel(json: baseTx)
        //        XCTAssertThrowsError(try validateCheckCancel(tx: tx.toJson()))
    }
}
