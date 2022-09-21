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

final class TestAutoFill: RippledMockTester {

    private static let fee: String = "10"
    private static let sequence: Int = 1432
    private static let lastLedgerSequence: Int = 2908734

    override func setUp() async throws {
        try await super.setUp()
    }

    func testNoOverright() async {
        let tx: DepositPreauth = DepositPreauth(authorize: "rpZc4mVfWUif9CRoHRKKcmhu1nx2xktxBo")
        tx.account = "rGWrZyQqhTp9Xu7G5Pkayo7bXjH4k4QYpf"
        tx.fee = TestAutoFill.fee
        tx.sequence = TestAutoFill.sequence
        tx.lastLedgerSequence = TestAutoFill.lastLedgerSequence
        let txResult = try! await AutoFillSugar().autofill(client: self.client, transaction: try tx.toJson(), signersCount: 0)
        let newTx = try! txResult.wait()
        XCTAssertEqual(newTx["Fee"] as! String, TestAutoFill.fee)
        XCTAssertEqual(newTx["Sequence"] as! Int, TestAutoFill.sequence)
        XCTAssertEqual(newTx["LastLedgerSequence"] as! Int, TestAutoFill.lastLedgerSequence)
    }

    func testAutoFillConvertXAddress() async {
        let json: [String: AnyObject] = [
            "TransactionType": "Payment",
            "Account": "XVLhHMPHU98es4dbozjVtdWzVrDjtV18pX8yuPT7y4xaEHi",
            "Amount": "1234",
            "Destination": "X7AcgcsBL6XDcUb289X4mJ8djcdyKaB5hJDWMArnXr61cqZ"
        ] as [String: AnyObject]
        let tx: Payment = try! Payment(json: json)
        try! self.mockRippled.addResponse(command: "account_info", response: RippledFixtures.accountInfo())
        try! self.mockRippled.addResponse(command: "server_info", response: RippledFixtures.serverInfo())
        try! self.mockRippled.addResponse(command: "ledger", response: RippledFixtures.ledger())

        let txResult = try! await self.client.autofill(transaction: Transaction(json)!)
        print(txResult)
//        assert.strictEqual(txResult.Account, "rGWrZyQqhTp9Xu7G5Pkayo7bXjH4k4QYpf")
//        assert.strictEqual(
//          txResult.Destination,
//          "r9cZA1mLK5R5Am25ArfXFmqgNwjZgnfk59",
//        )
    }
}
