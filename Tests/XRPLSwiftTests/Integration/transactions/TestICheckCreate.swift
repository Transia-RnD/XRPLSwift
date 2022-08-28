//
//  TestICheckCreate.swift
//  
//
//  Created by Denis Angell on 8/26/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/integration/transactions/checkCreate.ts

import XCTest
@testable import XRPLSwift

final class TestICheckCreate: RippledITestCase {
    
    let TIMEOUT: Double = 20
    
    override func setUp() async throws {
        try await super.setUp()
    }
    
    override func tearDown() async throws {
        try await super.tearDown()
    }
    
    func testJson() async {
        // create the expectation
        let exp = expectation(description: "base")
        
        let wallet2: Wallet = await generateFundedWallet(client: self.client)
        let amount: String = "500"
        let json = [
            "TransactionType": "CheckCreate",
            "Account": self.wallet.classicAddress,
            "Destination": wallet2.classicAddress,
            "SendMax": amount,
        ] as [String: AnyObject]
        let tx1: Transaction = try! Transaction(json)!
        await testTransaction(
            client: self.client,
            transaction: tx1,
            wallet: self.wallet
        )
        
        // get check ID
        let result1 = [
            "command": "account_objects",
            "account": self.wallet.classicAddress,
            "type": "check",
        ] as [String: AnyObject]
        let response1 = try! await self.client.request(AccountObjectsRequest(result1)).wait() as! BaseResponse<AccountObjectsResponse>
        XCTAssertEqual(response1.result?.accountObjects.count, 1)
        exp.fulfill()
        await waitForExpectations(timeout: TIMEOUT)
    }
}
