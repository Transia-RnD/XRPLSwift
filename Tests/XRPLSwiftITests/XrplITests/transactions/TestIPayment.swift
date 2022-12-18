//
//  TestIPayment.swift
//
//
//  Created by Denis Angell on 8/26/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/integration/transactions/payment.ts

import XCTest
@testable import XRPLSwift

final class TestIPayment: RippledITestCase {

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
        let json = [
            "TransactionType": "Payment",
            "Account": self.wallet.classicAddress,
            "Destination": wallet2.classicAddress,
            "Amount": "1000"
        ] as [String: AnyObject]
        let tx: Transaction = try! Transaction(json)!
        await testTransaction(
            client: self.client,
            transaction: tx,
            wallet: self.wallet
        )
        exp.fulfill()
        await waitForExpectations(timeout: TIMEOUT)
    }

    func testModel() async {
        // create the expectation
        let exp = expectation(description: "base")

        let wallet2: Wallet = await generateFundedWallet(client: self.client)
        let json = [
            "TransactionType": "Payment",
            "Account": self.wallet.classicAddress,
            "Destination": wallet2.classicAddress,
            "Amount": "1000"
        ] as [String: AnyObject]
        let tx: Payment = try! Payment(json: json)
        await testTransaction(
            client: self.client,
            transaction: tx.asTx,
            wallet: self.wallet
        )
        exp.fulfill()
        await waitForExpectations(timeout: TIMEOUT)
    }
}
