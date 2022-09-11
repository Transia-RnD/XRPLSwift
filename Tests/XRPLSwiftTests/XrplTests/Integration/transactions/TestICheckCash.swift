//
//  TestICheckCash.swift
//
//
//  Created by Denis Angell on 8/26/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/integration/transactions/checkCash.ts

import XCTest
@testable import XRPLSwift

final class TestICheckCash: RippledITestCase {

    let TIMEOUT: Double = 20

    override func setUp() async throws {
        try await super.setUp()
    }

    override func tearDown() async throws {
        try await super.tearDown()
    }

    func _testJson() async {
        // create the expectation
        let exp = expectation(description: "base")

        let wallet2: Wallet = await generateFundedWallet(client: self.client)
        let amount: String = "500"
        let json = [
            "TransactionType": "CheckCreate",
            "Account": self.wallet.classicAddress,
            "Destination": wallet2.classicAddress,
            "SendMax": amount
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
            "type": "check"
        ] as [String: AnyObject]
        let response1 = try! await self.client.request(AccountObjectsRequest(result1)).wait() as! BaseResponse<AccountObjectsResponse>
        XCTAssertEqual(response1.result?.accountObjects.count, 1)
        guard let result1 = response1.result, let check = result1.accountObjects[0].toAny() as? Check else {
            XCTFail()
            return
        }

        // actual test - cancel the check
        print(check.index)
        let txJson = [
            "TransactionType": "CheckCash",
            "Account": self.wallet.classicAddress,
            "CheckID": check.index,
            "Amount": amount
        ] as [String: AnyObject]
        let tx2: Transaction = try! Transaction(txJson)!
        await testTransaction(
            client: self.client,
            transaction: tx2,
            wallet: self.wallet
        )

        // confirm that the check no longer exists
        let result2 = [
            "command": "account_objects",
            "account": self.wallet.classicAddress,
            "type": "check"
        ] as [String: AnyObject]
        let response2 = try! await self.client.request(AccountObjectsRequest(result2)).wait() as! BaseResponse<AccountObjectsResponse>
        XCTAssertEqual(response2.result?.accountObjects.count, 0)
        exp.fulfill()
        await waitForExpectations(timeout: TIMEOUT)
    }
}
