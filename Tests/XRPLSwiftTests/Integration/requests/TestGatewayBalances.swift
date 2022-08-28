//
//  TestGatewayBalances.swift
//
//
//  Created by Denis Angell on 8/20/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/integration/requests/accountLines.ts

import XCTest
@testable import XRPLSwift

final class TestGatewayBalances: RippledITestCase {
    
    let TIMEOUT: Double = 20
    var expected: [String: AnyObject] = [:]
    
    override func setUp() async throws {
        try await super.setUp()
        expected = [
            "id": 0,
            "result": [
                "account": self.wallet.classicAddress,
                "ledger_hash": "28D68B351ED58B9819502EF5FC05BA4412A048597E5159E1C226703BDF7C7897",
                "ledger_index": 1294,
                "validated": true,
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
            "command": "gateway_balances",
            "account": self.wallet.classicAddress,
            "ledger_index": "validated",
            "strict": true,
        ] as [String: AnyObject]
        let request: GatewayBalancesRequest = try! GatewayBalancesRequest(json)
        let response: BaseResponse = try! await self.client.request(r: request).wait() as! BaseResponse<GatewayBalancesResponse>
        XCTAssertEqual(response.type, expected["type"] as! String)
//        XCTAssert(response.result?.ledgerHash is String)
//        XCTAssert(response.result?.ledgerIndex is Int)
        
        var responseJson: [String: AnyObject] = try! response.result!.toJson()
        responseJson["ledger_hash"] = nil
        responseJson["ledger_index"] = nil
        var expectedJson: [String: AnyObject] = expected["result"] as! [String : AnyObject]
        expectedJson["ledger_hash"] = nil
        expectedJson["ledger_index"] = nil
        expectedJson["ledger_current_index"] = responseJson["ledger_current_index"]
        print(responseJson)
        print(expectedJson)
        XCTAssert(responseJson == expectedJson)
        exp.fulfill()
        await waitForExpectations(timeout: TIMEOUT)
    }
    
    func testModel() async {
        // create the expectation
        let exp = expectation(description: "base")
        let request: GatewayBalancesRequest = GatewayBalancesRequest(
            account: self.wallet.classicAddress,
            strict: true,
            ledgerIndex: .string("validated")
        )
        let response: BaseResponse = try! await self.client.request(r: request).wait() as! BaseResponse<GatewayBalancesResponse>
        XCTAssertEqual(response.type, expected["type"] as! String)
//        XCTAssert(response.result?.ledgerHash is String)
//        XCTAssert(response.result?.ledgerIndex is Int)
        
        var responseJson: [String: AnyObject] = try! response.result!.toJson()
        responseJson["ledger_hash"] = nil
        responseJson["ledger_index"] = nil
        var expectedJson: [String: AnyObject] = expected["result"] as! [String : AnyObject]
        expectedJson["ledger_hash"] = nil
        expectedJson["ledger_index"] = nil
        expectedJson["ledger_current_index"] = responseJson["ledger_current_index"]
        XCTAssert(responseJson == expectedJson)
        exp.fulfill()
        await waitForExpectations(timeout: TIMEOUT)
    }
}
