//
//  TestAccountCurrencies.swift
//
//
//  Created by Denis Angell on 8/20/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/integration/requests/accountCurrencies.ts

import XCTest
@testable import XRPLSwift

final class TestIAccountCurrencies: RippledITestCase {
    
    let TIMEOUT: Double = 20
    var expected: [String: AnyObject] = [:]
    
    override func setUp() async throws {
        try await super.setUp()
        expected = [
            "id": 0,
            "result": [
                "receive_currencies": NSArray(),
                "send_currencies": NSArray(),
                "ledger_hash": "C8BFA74A740AA22AD9BD724781589319052398B0C6C817B88D55628E07B7B4A1",
                "ledger_index": 150,
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
            "command": "account_currencies",
            "account": self.wallet.classicAddress,
            "strict": true,
            "ledger_index": "validated",
        ] as [String: AnyObject]
        let request: AccountCurrenciesRequest = try! AccountCurrenciesRequest(json)
        let response: BaseResponse = try! await self.client.request(r: request).wait() as! BaseResponse<AccountCurrenciesResponse>
        XCTAssertEqual(response.type, expected["type"] as! String)
        XCTAssert(response.result?.ledgerHash is String)
        XCTAssert(response.result?.ledgerIndex is Int)
        
        var responseJson: [String: AnyObject] = try! response.result!.toJson()
        responseJson["ledger_hash"] = nil
        responseJson["ledger_index"] = nil
        var expectedJson: [String: AnyObject] = expected["result"] as! [String : AnyObject]
        expectedJson["ledger_hash"] = nil
        expectedJson["ledger_index"] = nil
        print(responseJson)
        print(expectedJson)
        XCTAssert(responseJson == expectedJson)
        exp.fulfill()
        await waitForExpectations(timeout: TIMEOUT)
    }
    
    func testModel() async {
        // create the expectation
        let exp = expectation(description: "base")
        let request: AccountCurrenciesRequest = AccountCurrenciesRequest(
            account: self.wallet.classicAddress,
            ledgerIndex: .string("validated"),
            strict: true
        )
        let response: BaseResponse = try! await self.client.request(r: request).wait() as! BaseResponse<AccountCurrenciesResponse>
        XCTAssertEqual(response.type, expected["type"] as! String)
        XCTAssert(response.result?.ledgerHash is String)
        XCTAssert(response.result?.ledgerIndex is Int)
        
        var responseJson: [String: AnyObject] = try! response.result!.toJson()
        responseJson["ledger_hash"] = nil
        responseJson["ledger_index"] = nil
        var expectedJson: [String: AnyObject] = expected["result"] as! [String : AnyObject]
        expectedJson["ledger_hash"] = nil
        expectedJson["ledger_index"] = nil
        XCTAssert(responseJson == expectedJson)
        exp.fulfill()
        await waitForExpectations(timeout: TIMEOUT)
    }
}
