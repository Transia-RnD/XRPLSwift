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
        let txResult = try! await AutoFillSugar().autofill(self.client, try tx.toJson(), 0)
        let newTx = try! txResult.wait()
        XCTAssertEqual(newTx["Fee"] as! String, TestAutoFill.fee)
        XCTAssertEqual(newTx["Sequence"] as! Int, TestAutoFill.sequence)
        XCTAssertEqual(newTx["LastLedgerSequence"] as! Int, TestAutoFill.lastLedgerSequence)
    }

    func testAutoFillConvertXAddress() async {
        let exp = expectation(description: "base")
        let json: [String: AnyObject] = [
            "TransactionType": "Payment",
            "Account": "XVLhHMPHU98es4dbozjVtdWzVrDjtV18pX8yuPT7y4xaEHi",
            "Amount": "1234",
            "Destination": "X7AcgcsBL6XDcUb289X4mJ8djcdyKaB5hJDWMArnXr61cqZ"
        ] as [String: AnyObject]
        try! self.mockRippled.addResponse(command: "account_info", response: RippledFixtures.accountInfo())
        try! self.mockRippled.addResponse(command: "server_info", response: RippledFixtures.serverInfo())
        try! self.mockRippled.addResponse(command: "ledger", response: RippledFixtures.ledger())
        let txResult = try! await self.client.autofill(transaction: Transaction(json)!).wait() as [String: AnyObject]
        XCTAssertEqual(txResult["Account"] as! String, "rGWrZyQqhTp9Xu7G5Pkayo7bXjH4k4QYpf")
        XCTAssertEqual(txResult["Destination"] as! String, "r9cZA1mLK5R5Am25ArfXFmqgNwjZgnfk59")
        exp.fulfill()
        await waitForExpectations(timeout: 5)
    }

    func testShouldAutofillSequence() async {
        let exp = expectation(description: "base")
        let json: [String: AnyObject] = [
            "TransactionType": "DepositPreauth",
            "Account": "rGWrZyQqhTp9Xu7G5Pkayo7bXjH4k4QYpf",
            "Authorize": "rpZc4mVfWUif9CRoHRKKcmhu1nx2xktxBo",
            "Fee": TestAutoFill.fee,
            "LastLedgerSequence": TestAutoFill.lastLedgerSequence
        ] as [String: AnyObject]
        try! self.mockRippled.addResponse(command: "account_info", response: RippledFixtures.accountInfo())
        let txResult = try! await self.client.autofill(transaction: Transaction(json)!).wait() as [String: AnyObject]
        XCTAssertEqual(txResult["Sequence"] as! Int, 23)
        exp.fulfill()
        await waitForExpectations(timeout: 5)
    }

    //    func testShouldThrowAccountDelete() async {
    //        let exp = expectation(description: "base")
    //        let json: [String: AnyObject] = [
    //            "TransactionType": "AccountDelete",
    //            "Account": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
    //            "Destination": "X7AcgcsBL6XDcUb289X4mJ8djcdyKaB5hJDWMArnXr61cqZ",
    //            "Fee": TestAutoFill.fee,
    //            "Sequence": TestAutoFill.sequence,
    //            "LastLedgerSequence": TestAutoFill.lastLedgerSequence
    //        ] as [String: AnyObject]
    //        try! self.mockRippled.addResponse(command: "account_info", response: RippledFixtures.accountInfo())
    //        try! self.mockRippled.addResponse(command: "server_info", response: RippledFixtures.serverInfo())
    //        try! self.mockRippled.addResponse(command: "ledger", response: RippledFixtures.ledger())
    //        try! self.mockRippled.addResponse(command: "account_objects", response: RippledFixtures.accountObjects())
    //        do {
    //            try await self.client.autofill(transaction: Transaction(json)!).wait() as [String: AnyObject]
    //            XCTFail()
    //        } catch {
    //            exp.fulfill()
    //        }
    //        await waitForExpectations(timeout: 5)
    //    }

    func testShouldAutofillFee() async {
        let exp = expectation(description: "base")
        let json: [String: AnyObject] = [
            "TransactionType": "DepositPreauth",
            "Account": "rGWrZyQqhTp9Xu7G5Pkayo7bXjH4k4QYpf",
            "Authorize": "rpZc4mVfWUif9CRoHRKKcmhu1nx2xktxBo",
            "Sequence": TestAutoFill.sequence,
            "LastLedgerSequence": TestAutoFill.lastLedgerSequence
        ] as [String: AnyObject]
        try! self.mockRippled.addResponse(command: "server_info", response: RippledFixtures.serverInfo())
        let txResult = try! await self.client.autofill(transaction: Transaction(json)!).wait() as [String: AnyObject]
        XCTAssertEqual(txResult["Fee"] as! String, "12")
        exp.fulfill()
        await waitForExpectations(timeout: 5)
    }

    func testShouldAutofillFeeEscrowFinish() async {
        let exp = expectation(description: "base")
        let json: [String: AnyObject] = [
            "Account": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
            "TransactionType": "EscrowFinish",
            "Owner": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
            "OfferSequence": 7,
            "Condition":
                "A0258020E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855810100",
            "Fulfillment": "A0028000"
        ] as [String: AnyObject]
        try! self.mockRippled.addResponse(command: "account_info", response: RippledFixtures.accountInfo())
        try! self.mockRippled.addResponse(command: "server_info", response: RippledFixtures.serverInfo())
        try! self.mockRippled.addResponse(command: "ledger", response: RippledFixtures.ledger())
        let txResult = try! await self.client.autofill(transaction: Transaction(json)!, signersCount: 4).wait() as [String: AnyObject]
        XCTAssertEqual(txResult["Fee"] as! String, "456")
        //        XCTAssertEqual(txResult["Fee"] as! String, "459")
        // TODO: See above calc difference
        exp.fulfill()
        await waitForExpectations(timeout: 5)
    }

    func testShouldAutofillFeeLastLedgerSequence() async {
        let exp = expectation(description: "base")
        let json: [String: AnyObject] = [
            "Account": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
            "TransactionType": "EscrowFinish",
            "Owner": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
            "OfferSequence": 7,
            "Condition":
                "A0258020E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855810100",
            "Fulfillment": "A0028000"
        ] as [String: AnyObject]
        try! self.mockRippled.addResponse(command: "account_info", response: RippledFixtures.accountInfo())
        try! self.mockRippled.addResponse(command: "server_info", response: RippledFixtures.serverInfo())
        try! self.mockRippled.addResponse(command: "ledger", response: RippledFixtures.ledger())
        let txResult = try! await self.client.autofill(transaction: Transaction(json)!, signersCount: 4).wait() as [String: AnyObject]
        XCTAssertEqual(txResult["Fee"] as! String, "456")
        //        XCTAssertEqual(txResult["Fee"] as! String, "459")
        // TODO: See above calc difference
        exp.fulfill()
        await waitForExpectations(timeout: 5)
    }
}
