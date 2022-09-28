//
//  TestIOfferCancel.swift
//
//
//  Created by Denis Angell on 8/26/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/integration/transactions/offerCancel.ts

import XCTest
@testable import XRPLSwift

final class TestIOfferCancel: RippledITestCase {

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

        // set up an offer
        let setupTx = [
            "TransactionType": "OfferCreate",
            "Account": self.wallet.classicAddress,
            "TakerGets": "13100000",
            "TakerPays": [
                "currency": "USD",
                "issuer": self.wallet.classicAddress,
                "value": "10"
            ]
        ] as [String: AnyObject]
        let tx: Transaction = try! Transaction(setupTx)!
        await testTransaction(
            client: self.client,
            transaction: tx,
            wallet: self.wallet
        )

        // confirm that the offer exists
        let result1 = [
            "command": "account_offers",
            "account": self.wallet.classicAddress,
            "type": "offer"
        ] as [String: AnyObject]
        let response1 = try! await self.client.request(AccountOffersRequest(result1)).wait() as! BaseResponse<AccountOffersResponse>
        XCTAssertEqual(response1.result?.offers?.count, 1)

        guard let offers = response1.result?.offers else {
            XCTFail()
            return
        }

        // actually test OfferCancel
        let txJson = [
            "TransactionType": "CheckCancel",
            "Account": self.wallet.classicAddress,
            "OfferSequence": offers[0].seq
        ] as [String: AnyObject]
        let tx2: Transaction = try! Transaction(txJson)!
        await testTransaction(
            client: self.client,
            transaction: tx2,
            wallet: self.wallet
        )

        // confirm that the offer exists
        let result2 = [
            "command": "account_offers",
            "account": self.wallet.classicAddress,
            "type": "offer"
        ] as [String: AnyObject]
        let response2 = try! await self.client.request(AccountOffersRequest(result2)).wait() as! BaseResponse<AccountOffersResponse>
        XCTAssertEqual(response2.result?.offers?.count, 0)

        exp.fulfill()
        await waitForExpectations(timeout: TIMEOUT)
    }
}
