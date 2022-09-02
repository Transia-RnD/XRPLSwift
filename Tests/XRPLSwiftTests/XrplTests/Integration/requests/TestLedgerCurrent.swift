//
//  TestLedgerCurrent.swift
//
//
//  Created by Denis Angell on 8/20/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/integration/requests/ledgerCurrent.ts

import XCTest
@testable import XRPLSwift

final class TestILedgerCurrent: RippledITestCase {
    
    let TIMEOUT: Double = 20
    var expected: [String: AnyObject] = [:]
    
    override func setUp() async throws {
        try await super.setUp()
        expected = [
            "id": 0,
            "result": [
                "ledger_hash": "string",
                "ledger_index": 1,
            ],
            "type": "response",
        ] as [String: AnyObject]
    }
    
    override func tearDown() async throws {
        try await super.tearDown()
    }
    
    func testJson() async {
        // create the expectation
        let exp = expectation(description: "base")
        
        let json = [
            "command": "ledger_current"
        ] as [String: AnyObject]
        let request: LedgerCurrentRequest = try! LedgerCurrentRequest(json)
        let response: BaseResponse = try! await self.client.request(r: request).wait() as! BaseResponse<LedgerCurrentResponse>
        XCTAssertEqual(response.type, expected["type"] as! String)
        XCTAssert(response.result?.ledgerCurrentIndex is Int)
        exp.fulfill()
        await waitForExpectations(timeout: TIMEOUT)
    }
    
    func testModel() async {
        // create the expectation
        let exp = expectation(description: "base")
        let request: LedgerCurrentRequest = LedgerCurrentRequest()
        let response: BaseResponse = try! await self.client.request(r: request).wait() as! BaseResponse<LedgerCurrentResponse>
        XCTAssertEqual(response.type, expected["type"] as! String)
        XCTAssert(response.result?.ledgerCurrentIndex is Int)
        exp.fulfill()
        await waitForExpectations(timeout: TIMEOUT)
    }
}
