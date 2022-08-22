//
//  TestAutoFill.swift
//
//
//  Created by Denis Angell on 7/31/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/client/autofill.ts

import Foundation

import XCTest
@testable import XRPLSwift

final class TestAutoFill: XCTestCase {

    private static let fee: String = "10"
    private static let sequence: Int = 1432
    private static let lastLedgerSequence: Int = 2908734

    private var client: XrplClient!

    override func setUp() async throws {
        try await super.setUp()
    }

    func testNoOverright() async {
        //        let tx: Transaction = {
        //          TransactionType: "DepositPreauth",
        //          Account: "rGWrZyQqhTp9Xu7G5Pkayo7bXjH4k4QYpf",
        //          Authorize: "rpZc4mVfWUif9CRoHRKKcmhu1nx2xktxBo",
        //          Fee,
        //          Sequence,
        //          LastLedgerSequence,
        //        }
        let tx: DepositPreauth = DepositPreauth(authorize: "rpZc4mVfWUif9CRoHRKKcmhu1nx2xktxBo")
        tx.account = "rGWrZyQqhTp9Xu7G5Pkayo7bXjH4k4QYpf"
        tx.fee = TestAutoFill.fee
        tx.sequence = TestAutoFill.sequence
        tx.lastLedgerSequence = TestAutoFill.lastLedgerSequence
        let baseTx: Transaction = Transaction.depositPreauth(tx)
        let txResult = try! await AutoFillSugar().autofill(client: self.client, transaction: tx, signersCount: 0)
        print(baseTx)
        let newTx = try! txResult.wait()
        print(newTx)
        print("FINISHED")
        //        assert.strictEqual(txResult.Fee, Fee)
        //        assert.strictEqual(txResult.Sequence, Sequence)
        //        assert.strictEqual(txResult.LastLedgerSequence, LastLedgerSequence)
    }

    func testAutoFillConvertXAddress() async {
        let json: [String: AnyObject] = [
            "TransactionType": "Payment",
            "Account": "XVLhHMPHU98es4dbozjVtdWzVrDjtV18pX8yuPT7y4xaEHi",
            "Amount": "1234",
            "Destination": "X7AcgcsBL6XDcUb289X4mJ8djcdyKaB5hJDWMArnXr61cqZ"
        ] as [String: AnyObject]
        let tx: Payment = try! Payment(json: json)
//        self.mockRippled.addResponse("account_info", rippled.account_info.normal)
//        self.mockRippled.addResponse("server_info", rippled.server_info.normal)
//        self.mockRippled.addResponse("ledger", rippled.ledger.normal)
//
//        let txResult = await self.client.autofill(tx)

//        assert.strictEqual(txResult.Account, "rGWrZyQqhTp9Xu7G5Pkayo7bXjH4k4QYpf")
//        assert.strictEqual(
//          txResult.Destination,
//          "r9cZA1mLK5R5Am25ArfXFmqgNwjZgnfk59",
//        )
    }
}
