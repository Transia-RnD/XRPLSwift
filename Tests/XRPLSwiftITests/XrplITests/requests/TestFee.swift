//
//  TestFee.swift
//
//
//  Created by Denis Angell on 8/20/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/integration/requests/fee.test.ts

import XCTest
@testable import XRPLSwift

final class TestIFee: RippledITestCase {

    let TIMEOUT: Double = 20
    var expected: [String: AnyObject] = [:]
    var wallet2: Wallet!

    override func setUp() async throws {
        try await super.setUp()
        expected = [
            "id": 0,
            "type": "response",
            "result": [
                "current_ledger_size": "0",
                "current_queue_size": "0",
                "drops": [
                    "base_fee": "10",
                    "median_fee": "5000",
                    "minimum_fee": "10",
                    "open_ledger_fee": "10"
                ],
                "expected_ledger_size": "1000",
                "ledger_current_index": 2925,
                "levels": [
                    "median_level": "128000",
                    "minimum_level": "256",
                    "open_ledger_level": "256",
                    "reference_level": "256"
                ],
                "max_queue_size": "20000"
            ]
        ] as [String: AnyObject]
        wallet2 = await generateFundedWallet(client: self.client)
    }

    override func tearDown() async throws {
        try await super.tearDown()
    }

    func testJson() async {
        // create the expectation
        let exp = expectation(description: "base")

        let json = [
            "command": "fee"
        ] as [String: AnyObject]
        let request: FeeRequest = try! FeeRequest(json)
        let response: BaseResponse = try! await self.client.request(r: request).wait() as! BaseResponse<FeeResponse>
        XCTAssertEqual(response.type, expected["type"] as! String)

        var responseJson: [String: AnyObject] = try! response.result!.toJson()
        responseJson["ledger_current_index"] = nil
        var expectedJson: [String: AnyObject] = expected["result"] as! [String: AnyObject]
        expectedJson["ledger_current_index"] = nil
        XCTAssert(responseJson == expectedJson)
        exp.fulfill()
        await waitForExpectations(timeout: TIMEOUT)
    }

    func testModel() async {
        // create the expectation
        let exp = expectation(description: "base")
        let request: FeeRequest = FeeRequest()
        let response: BaseResponse = try! await self.client.request(r: request).wait() as! BaseResponse<FeeResponse>
        XCTAssertEqual(response.type, expected["type"] as! String)

        var responseJson: [String: AnyObject] = try! response.result!.toJson()
        responseJson["ledger_current_index"] = nil
        var expectedJson: [String: AnyObject] = expected["result"] as! [String: AnyObject]
        expectedJson["ledger_current_index"] = nil
        XCTAssert(responseJson == expectedJson)
        exp.fulfill()
        await waitForExpectations(timeout: TIMEOUT)
    }
}
