//
//  TestLedger.swift
//
//
//  Created by Denis Angell on 8/20/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/integration/requests/ledger.ts

import XCTest
@testable import XRPLSwift

final class TestILedger: RippledITestCase {
    
    let TIMEOUT: Double = 20
    var expected: [String: AnyObject] = [:]
    
    override func setUp() async throws {
        try await super.setUp()
        expected = [
            "id": 0,
            "result": [
                "ledger": [
                    "accepted": true,
                    "account_hash": "string",
                    "close_flags": 0,
                    "close_time": 0,
                    "close_time_human": "string",
                ],
                "ledger_hash": "string",
                "ledger_index": 1,
                "validated": true,
            ],
            "type": "response",
        ] as [String: AnyObject]
    }
    
    override func tearDown() async throws {
        try await super.tearDown()
    }
    
    func _testJson() async {
        // create the expectation
        let exp = expectation(description: "base")
        
        let json = [
            "command": "ledger",
            "ledger_index": "validated",
        ] as [String: AnyObject]
        let request: LedgerRequest = try! LedgerRequest(json)
        let response: BaseResponse = try! await self.client.request(r: request).wait() as! BaseResponse<LedgerResponse>
        XCTAssertEqual(response.type, expected["type"] as! String)
        XCTAssert(response.result?.ledgerHash is String)
        XCTAssert(response.result?.ledger.accountHash is String)
        XCTAssert(response.result?.ledger.closeFlags is Int)
        XCTAssert(response.result?.ledger.closeTime is Int)
        XCTAssert(response.result?.ledger.closeTimeHuman is String)
        XCTAssert(response.result?.ledger.closed is Bool)
        XCTAssert(response.result?.ledger.ledgerHash is String)
        XCTAssert(response.result?.ledger.parentCloseTime is Int)
        XCTAssert(response.result?.ledger.parentHash is String)
        XCTAssert(response.result?.ledger.totalCoins is String)
        XCTAssert(response.result?.ledger.transactionHash is String)
        exp.fulfill()
        await waitForExpectations(timeout: TIMEOUT)
    }
    
    func _testModel() async {
        // create the expectation
        let exp = expectation(description: "base")
        let request: LedgerRequest = LedgerRequest(ledgerIndex: .string("validated"))
        let response: BaseResponse = try! await self.client.request(r: request).wait() as! BaseResponse<LedgerResponse>
        XCTAssertEqual(response.type, expected["type"] as! String)
        XCTAssert(response.result?.ledgerHash is String)
        XCTAssert(response.result?.ledger.accountHash is String)
        XCTAssert(response.result?.ledger.closeFlags is Int)
        XCTAssert(response.result?.ledger.closeTime is Int)
        XCTAssert(response.result?.ledger.closeTimeHuman is String)
        XCTAssert(response.result?.ledger.closed is Bool)
        XCTAssert(response.result?.ledger.ledgerHash is String)
        XCTAssert(response.result?.ledger.parentCloseTime is Int)
        XCTAssert(response.result?.ledger.parentHash is String)
        XCTAssert(response.result?.ledger.totalCoins is String)
        XCTAssert(response.result?.ledger.transactionHash is String)
        exp.fulfill()
        await waitForExpectations(timeout: TIMEOUT)
    }
}
