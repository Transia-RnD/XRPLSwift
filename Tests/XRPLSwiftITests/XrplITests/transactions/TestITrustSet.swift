//
//  TestITrustSet.swift
//
//
//  Created by Denis Angell on 8/26/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/integration/transactions/trustSet.ts

import XCTest
@testable import XRPLSwift

final class TestITrustSet: RippledITestCase {

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
            "TransactionType": "TrustSet",
            "Account": self.wallet.classicAddress,
            "LimitAmount": [
                "currency": "USD",
                "issuer": wallet2.classicAddress,
                "value": "100"
            ]
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

    func testQualityGreater1() async {
        // create the expectation
        let exp = expectation(description: "base")

        let wallet2: Wallet = await generateFundedWallet(client: self.client)
        let json = [
            "TransactionType": "TrustSet",
            "Account": self.wallet.classicAddress,
            "QualityIn": try! percentToQuality(percent: "99%"),
            "QualityOut": try! percentToQuality(percent: "99%"),
            "LimitAmount": [
                "currency": "USD",
                "issuer": wallet2.classicAddress,
                "value": "100"
            ]
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

    func testQualityLess1() async {
        // create the expectation
        let exp = expectation(description: "base")

        let wallet2: Wallet = await generateFundedWallet(client: self.client)
        let json = [
            "TransactionType": "TrustSet",
            "Account": self.wallet.classicAddress,
            "QualityIn": try! percentToQuality(percent: "101%"),
            "QualityOut": try! percentToQuality(percent: "101%"),
            "LimitAmount": [
                "currency": "USD",
                "issuer": wallet2.classicAddress,
                "value": "100"
            ]
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
}
