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
        do {
            client = try XrplClient(server: ReusableValues.testServer)
            _ = try! await client.connect()
            print(client.url())
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func testClientConstructor() async {
//        let tx: Transaction = {
//          TransactionType: 'DepositPreauth',
//          Account: 'rGWrZyQqhTp9Xu7G5Pkayo7bXjH4k4QYpf',
//          Authorize: 'rpZc4mVfWUif9CRoHRKKcmhu1nx2xktxBo',
//          Fee,
//          Sequence,
//          LastLedgerSequence,
//        }
        let tx: DepositPreauth = DepositPreauth(authorize: "rpZc4mVfWUif9CRoHRKKcmhu1nx2xktxBo")
        tx.account = "rGWrZyQqhTp9Xu7G5Pkayo7bXjH4k4QYpf"
        tx.fee = TestAutoFill.fee
//        tx.sequence = TestAutoFill.sequence
        tx.lastLedgerSequence = TestAutoFill.lastLedgerSequence
        let baseTx: rTransaction = rTransaction.DepositPreauth(tx)
        let txResult = await AutoFill().autofill(client: self.client, transaction: tx, signersCount: 0)
        print(baseTx)
        let newTx = try! txResult.wait()
        print(newTx)
        print("FINISHED")
//        assert.strictEqual(txResult.Fee, Fee)
//        assert.strictEqual(txResult.Sequence, Sequence)
//        assert.strictEqual(txResult.LastLedgerSequence, LastLedgerSequence)
    }
}
