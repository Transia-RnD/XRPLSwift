//
//  TestAccountNFTs.swift
//
//
//  Created by Denis Angell on 8/20/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/integration/requests/accountNFTs.ts

import XCTest
@testable import XRPLSwift

final class TestAccounNFTs: RippledITestCase {
    
    let TIMEOUT: Double = 20
    var expected: [String: AnyObject] = [:]
    
    override func setUp() async throws {
        try await super.setUp()
        expected = [
            "id": 0,
            "result": [
                "account": self.wallet.classicAddress,
                "account_nfts": [],
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
            "command": "account_nfts",
            "account": self.wallet.classicAddress,
            "ledger_index": "validated",
        ] as [String: AnyObject]
        let request: AccountNFTsRequest = try! AccountNFTsRequest(json)
        let response: BaseResponse = try! await self.client.request(r: request).wait() as! BaseResponse<AccountNFTsResponse>
        XCTAssertEqual(response.type, expected["type"] as! String)
//        XCTAssert(response.result?.ledgerHash is String)
//        XCTAssert(response.result?.ledgerIndex is Int)
        
        var responseJson: [String: AnyObject] = try! response.result!.toJson()
//        responseJson["ledger_hash"] = nil
//        responseJson["ledger_index"] = nil
        var expectedJson: [String: AnyObject] = expected["result"] as! [String : AnyObject]
//        expectedJson["ledger_hash"] = nil
//        expectedJson["ledger_index"] = nil
        XCTAssert(responseJson == expectedJson)
        exp.fulfill()
        await waitForExpectations(timeout: TIMEOUT)
    }
    
    func _testModel() async {
        // create the expectation
        let exp = expectation(description: "base")
        let request: AccountNFTsRequest = AccountNFTsRequest(
            account: self.wallet.classicAddress
        )
        let response: BaseResponse = try! await self.client.request(r: request).wait() as! BaseResponse<AccountNFTsResponse>
        XCTAssertEqual(response.type, expected["type"] as! String)
//        XCTAssert(response.result?.ledgerHash is String)
//        XCTAssert(response.result?.ledgerIndex is Int)
        
        var responseJson: [String: AnyObject] = try! response.result!.toJson()
//        responseJson["ledger_hash"] = nil
//        responseJson["ledger_index"] = nil
        var expectedJson: [String: AnyObject] = expected["result"] as! [String : AnyObject]
//        expectedJson["ledger_hash"] = nil
//        expectedJson["ledger_index"] = nil
        XCTAssert(responseJson == expectedJson)
        exp.fulfill()
        await waitForExpectations(timeout: TIMEOUT)
    }
}
