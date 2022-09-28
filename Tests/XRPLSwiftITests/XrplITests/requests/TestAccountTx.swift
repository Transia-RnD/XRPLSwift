//
//  TestAccountTx.swift
//
//
//  Created by Denis Angell on 8/20/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/integration/requests/accountTx.ts

import XCTest
@testable import XRPLSwift

final class TestIAccounTx: RippledITestCase {

    let TIMEOUT: Double = 20
    var expected: [String: AnyObject] = [:]

    override func setUp() async throws {
        try await super.setUp()
        expected = [
            "id": 0,
            "result": [
                "account": self.wallet.classicAddress,
                "limit": 400,
                "transactions": [
                    [
                        "tx": [
                            "Account": "rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh",
                            "Amount": "400000000",
                            "Destination": self.wallet.classicAddress,
                            "Fee": "100",
                            "Flags": 0,
                            "LastLedgerSequence": 1753,
                            "Sequence": 843,
                            "SigningPubKey":
                                "0330E7FC9D56BB25D6893BA3F317AE5BCF33B3291BD63DB32654A313222F7FD020",
                            "TransactionType": "Payment",
                            "TxnSignature":
                                "30440220693D244BC13967E3DA67BDC974096784ED03DD4ACE6F36645E5176988452AFCF02200F8AB172432913899F27EC5523829AEDAD00CC2445690400E294EDF652A85945",
                            "date": 685747005,
                            "hash": "2E68BC15813B4A836FAC4D80E42E6FDA6410E99AB973937DEA5E6C2E9A116BAB",
                            "inLedger": 1734,
                            "ledger_index": 1734
                        ]
                    ]
                ]
            ],
            "type": "response"
        ] as [String: AnyObject]
    }

    override func tearDown() async throws {
        try await super.tearDown()
    }

    func testJson() async {
        // create the expectation
        let exp = expectation(description: "base")

        let json = [
            "command": "account_tx",
            "account": self.wallet.classicAddress,
            "ledger_index": "validated"
        ] as [String: AnyObject]
        let request: AccountTxRequest = try! AccountTxRequest(json)
        let response: BaseResponse = try! await self.client.request(r: request).wait() as! BaseResponse<AccountTxResponse>
        XCTAssertEqual(response.type, expected["type"] as! String)
        //        XCTAssert(response.result?.ledgerHash is String)
        //        XCTAssert(response.result?.ledgerIndex is Int)

        var responseJson: [String: AnyObject] = try! response.result!.transactions[0].tx!.toJson()
        responseJson["Flags"] = nil
        responseJson["LastLedgerSequence"] = nil
        responseJson["date"] = nil
        responseJson["hash"] = nil
        responseJson["inLedger"] = nil
        responseJson["ledger_index"] = nil
        responseJson["TxnSignature"] = nil
        responseJson["Sequence"] = nil
        let expectedResult = expected["result"] as! [String: AnyObject]
        let expectedTxs = expectedResult["transactions"] as! [[String: AnyObject]]
        var expectedJson = expectedTxs[0] as [String: AnyObject]
        expectedJson = expectedJson["tx"] as! [String: AnyObject]
        expectedJson["Flags"] = nil
        expectedJson["LastLedgerSequence"] = nil
        expectedJson["date"] = nil
        expectedJson["hash"] = nil
        expectedJson["inLedger"] = nil
        expectedJson["ledger_index"] = nil
        expectedJson["TxnSignature"] = nil
        expectedJson["Sequence"] = nil
        XCTAssert(responseJson == expectedJson)
        exp.fulfill()
        await waitForExpectations(timeout: TIMEOUT)
    }

    // TODO: Finish this function copy above
    //    func testModel() async {}
}
