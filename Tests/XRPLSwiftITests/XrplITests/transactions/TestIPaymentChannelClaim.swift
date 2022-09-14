//
//  TestIPaymentChannelClaim.swift
//  
//
//  Created by Denis Angell on 8/26/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/integration/transactions/paymentChannelClaim.ts

import XCTest
@testable import XRPLSwift

final class TestIPaymentChannelClaim: RippledITestCase {

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
        let json = [
            "TransactionType": "PaymentChannelCreate",
            "Account": self.wallet.classicAddress,
            "Amount": "100",
            "Destination": wallet2.classicAddress,
            "SettleDelay": 86400,
            "PublicKey": self.wallet.publicKey
        ] as [String: AnyObject]
        let tx: Transaction = try! Transaction(json)!

        let opts = SubmitOptions(autofill: nil, failHard: nil, wallet: self.wallet)
        let paymentChannelResponse = try! await self.client.submit(transaction: tx, opts: opts).wait() as? BaseResponse<SubmitResponse>
        let transaction = try! paymentChannelResponse?.result?.txJson.toAny() as? PaymentChannelCreate

        await testTransaction(
            client: self.client,
            transaction: tx,
            wallet: self.wallet
        )

        let jsonTx2 = [
            "Account": self.wallet.classicAddress,
            "TransactionType": "PaymentChannelClaim",
            "Channel": hashPaymentChannel(
                address: self.wallet.classicAddress,
                dstAddress: wallet2.classicAddress,
                sequence: transaction?.sequence ?? 0
            ),
            "Amount": "100"
        ] as [String: AnyObject]
        let tx2: Transaction = try! Transaction(jsonTx2)!

        await testTransaction(
            client: self.client,
            transaction: tx2,
            wallet: self.wallet
        )

        exp.fulfill()
        await waitForExpectations(timeout: TIMEOUT)
    }
}
