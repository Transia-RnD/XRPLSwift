//
//  TestLedgerClosed.swift
//
//
//  Created by Denis Angell on 8/20/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/integration/requests/ledgerClosed.ts

import XCTest
@testable import XRPLSwift

final class TestILedgerClosed: RippledITestCase {

    let TIMEOUT: Double = 20
    var expected: [String: AnyObject] = [:]

    override func setUp() async throws {
        try await super.setUp()
        expected = [
            "id": 0,
            "result": [
                "ledger_hash": "string",
                "ledger_index": 1
            ],
            "type": "response"
        ] as [String: AnyObject]
    }

    override func tearDown() async throws {
        try await super.tearDown()
    }

    func testJson() async {
        // create the expectation
        let exp = expectation(description: "base")

        let json = [
            "command": "ledger_closed"
        ] as [String: AnyObject]
        let request: LedgerClosedRequest = try! LedgerClosedRequest(json)
        let response: BaseResponse = try! await self.client.request(r: request).wait() as! BaseResponse<LedgerClosedResponse>
        XCTAssertEqual(response.type, expected["type"] as! String)
        XCTAssert(response.result?.ledgerHash is String)
        XCTAssert(response.result?.ledgerIndex is Int)
        exp.fulfill()
        await waitForExpectations(timeout: TIMEOUT)
    }

    func testModel() async {
        // create the expectation
        let exp = expectation(description: "base")
        let request: LedgerClosedRequest = LedgerClosedRequest()
        let response: BaseResponse = try! await self.client.request(r: request).wait() as! BaseResponse<LedgerClosedResponse>
        XCTAssertEqual(response.type, expected["type"] as! String)
        XCTAssert(response.result?.ledgerHash is String)
        XCTAssert(response.result?.ledgerIndex is Int)
        exp.fulfill()
        await waitForExpectations(timeout: TIMEOUT)
    }
}
