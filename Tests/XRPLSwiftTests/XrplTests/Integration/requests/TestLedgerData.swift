//
//  TestLedgerData.swift
//
//
//  Created by Denis Angell on 8/20/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/integration/requests/ledgerData.ts

import XCTest
@testable import XRPLSwift

final class TestILedgerData: RippledITestCase {
    
    let TIMEOUT: Double = 20
    var expected: [String: AnyObject] = [:]
    
    override func setUp() async throws {
        try await super.setUp()
        expected = [
            "id": 0,
            "result": [
                "ledger_hash": "string",
                "ledger_index": 0,
                "marker": "string",
                "state": [
                    [
                        "data": "string",
                        "index": "string",
                    ],
                ],
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
            "command": "ledger_data",
            "limit": 5,
            "binary": true,
        ] as [String: AnyObject]
        let request: LedgerDataRequest = try! LedgerDataRequest(json)
        let response: BaseResponse = try! await self.client.request(r: request).wait() as! BaseResponse<LedgerDataResponse>
        XCTAssertEqual(response.type, expected["type"] as! String)
        XCTAssert(response.result?.ledgerHash is String)
        XCTAssert(response.result?.ledgerIndex is Int)
        XCTAssert(response.result?.marker is Any)
        exp.fulfill()
        await waitForExpectations(timeout: TIMEOUT)
    }
    
    func testModel() async {
        // create the expectation
        let exp = expectation(description: "base")
        let request: LedgerDataRequest = LedgerDataRequest(binary: true, limit: 5)
        let response: BaseResponse = try! await self.client.request(r: request).wait() as! BaseResponse<LedgerDataResponse>
        XCTAssertEqual(response.type, expected["type"] as! String)
        XCTAssert(response.result?.ledgerHash is String)
        XCTAssert(response.result?.ledgerIndex is Int)
        XCTAssert(response.result?.marker is Any)
        exp.fulfill()
        await waitForExpectations(timeout: TIMEOUT)
    }
}
