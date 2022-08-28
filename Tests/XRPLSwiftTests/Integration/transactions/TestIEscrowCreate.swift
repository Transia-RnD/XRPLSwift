//
//  TestIEscrowCreate.swift
//  
//
//  Created by Denis Angell on 8/26/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/integration/transactions/escrowCreate.ts

import XCTest
@testable import XRPLSwift

final class TestIEscrowCreate: RippledITestCase {
    
    let TIMEOUT: Double = 20
    
    override func setUp() async throws {
        try await super.setUp()    }
    
    override func tearDown() async throws {
        try await super.tearDown()
    }
    
    func testJson() async {
        // create the expectation
        let exp = expectation(description: "base")
        
        // get the most recent close_time from the standalone container for cancel & finish after.
        let json = ["command": "ledger", "validated": true] as [String: AnyObject]
        let request: LedgerRequest = try! LedgerRequest(json)
        let response: BaseResponse = try! await self.client.request(r: request).wait() as! BaseResponse<LedgerResponse>
        let closed_time: Int = (response.result?.ledger.closeTime)!
        
        let wallet1: Wallet = await generateFundedWallet(client: self.client)
        let jsonTx = [
            "Account": self.wallet.classicAddress,
            "TransactionType": "EscrowCreate",
            "Amount": "10000",
            "Destination": wallet1.classicAddress,
            "CancelAfter": closed_time + 3,
            "FinishAfter": closed_time + 2,
        ] as [String: AnyObject]
        let tx: Transaction = try! Transaction(jsonTx)!
        await testTransaction(
            client: self.client,
            transaction: tx,
            wallet: self.wallet
        )
        
        // get object created
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
