//
//  TestNoRippleCheck.swift
//
//
//  Created by Denis Angell on 8/20/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/integration/requests/noRippleCheck.ts

import XCTest
@testable import XRPLSwift

final class TestINoRippleCheck: RippledITestCase {
    
    let TIMEOUT: Double = 20
    var expected: [String: AnyObject] = [:]
    
    override func setUp() async throws {
        try await super.setUp()
        expected = [
            "id": 0,
            "result": [
                "ledger_current_index": 2535,
                "problems": ["You should immediately set your default ripple flag"],
                "transactions": [
                    [
                        "Account": self.wallet.classicAddress,
                        "Fee": 10,
                        "Sequence": 1268,
                        "SetFlag": 8,
                        "TransactionType": "AccountSet",
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
            "command": "noripple_check",
            "account": self.wallet.classicAddress,
            "role": "gateway",
            "ledger_index": "current",
            "transactions": true,
        ] as [String: AnyObject]
        let request: NoRippleCheckRequest = try! NoRippleCheckRequest(json)
        let response: BaseResponse = try! await self.client.request(r: request).wait() as! BaseResponse<NoRippleCheckResponse>
        XCTAssertEqual(response.type, expected["type"] as! String)
//        XCTAssert(response.result?.ledgerHash is String)
//        XCTAssert(response.result?.ledgerIndex is Int)
//        XCTAssert(response.result?.marker is Any)
        
        //        assert.equal(response.type, expected.type)
        //            assert.equal(typeof response.result.transactions[0].Fee, "number")
        //            assert.equal(typeof response.result.transactions[0].Sequence, "number")
        //            assert.equal(typeof response.result.problems, "object")
        //            assert.equal(typeof response.result.problems[0], "string")
        
        exp.fulfill()
        await waitForExpectations(timeout: TIMEOUT)
    }
    
    func testModel() async {
        // create the expectation
        let exp = expectation(description: "base")
        let request: NoRippleCheckRequest = NoRippleCheckRequest(
            account: self.wallet.classicAddress,
            role: "gateway",
            transactions: true,
            ledgerIndex: .string("current")
        )
        let response: BaseResponse = try! await self.client.request(r: request).wait() as! BaseResponse<NoRippleCheckResponse>
        XCTAssertEqual(response.type, expected["type"] as! String)
//        XCTAssert(response.result?.ledgerHash is String)
//        XCTAssert(response.result?.ledgerIndex is Int)
//        XCTAssert(response.result?.marker is Any)
        exp.fulfill()
        await waitForExpectations(timeout: TIMEOUT)
    }
}
