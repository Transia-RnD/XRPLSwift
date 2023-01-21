//
//  TestAccountInfo.swift
//
//
//  Created by Denis Angell on 8/20/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/integration/requests/accountInfo.test.ts

import XCTest
@testable import XRPLSwift

final class TestIAccountInfo: RippledITestCase {

    let TIMEOUT: Double = 20
    var expected: [String: AnyObject] = [:]

    override func setUp() async throws {
        try await super.setUp()
        expected = [
            "id": 0,
            "result": [
                "account_data": [
                    "Account": self.wallet.classicAddress,
                    "Balance": "400000000",
                    "Flags": 0,
                    "LedgerEntryType": "AccountRoot",
                    "OwnerCount": 0,
                    "PreviousTxnID": "19A8211695785A3A02C1C287D93C2B049E83A9CD609825E721052D63FF4F0EC8",
                    "PreviousTxnLgrSeq": 582,
                    "Sequence": 283,
                    "index": "BD4815E6EB304136E6044F778FB68D4E464CC8DFC59B8F6CC93D90A3709AE194"
                ],
                "ledger_hash": "F0DEEC46A7185BBB535517EE38CF2025973022D5B0532B36407F492521FDB0C6",
                "ledger_index": 582,
                "validated": true
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
            "command": "account_info",
            "account": self.wallet.classicAddress,
            "strict": true,
            "ledger_index": "validated"
        ] as [String: AnyObject]
        let request: AccountInfoRequest = try! AccountInfoRequest(json)
        let response: BaseResponse = try! await self.client.request(r: request).wait() as! BaseResponse<AccountInfoResponse>
        XCTAssertEqual(response.type, expected["type"] as! String)
        XCTAssertEqual(response.result?.validated, (expected["result"] as! [String: AnyObject])["validated"] as? Bool)
        XCTAssert(response.result?.ledgerHash is String)
        XCTAssert(response.result?.ledgerIndex is Int)

        var responseJson: [String: AnyObject] = try! response.result!.accountData.toJson()
        responseJson["PreviousTxnID"] = nil
        responseJson["PreviousTxnLgrSeq"] = nil
        responseJson["Sequence"] = nil
        responseJson["index"] = nil
        var expectedJson: [String: AnyObject] = (expected["result"] as! [String: AnyObject])["account_data"] as! [String: AnyObject]
        expectedJson["PreviousTxnID"] = nil
        expectedJson["PreviousTxnLgrSeq"] = nil
        expectedJson["Sequence"] = nil
        expectedJson["index"] = nil
        XCTAssert(responseJson == expectedJson)
        exp.fulfill()
        await waitForExpectations(timeout: TIMEOUT)
    }

    func testModel() async {
        // create the expectation
        let exp = expectation(description: "base")
        let request: AccountInfoRequest = AccountInfoRequest(
            account: self.wallet.classicAddress,
            ledgerIndex: .string("validated"),
            strict: true
        )
        let response: BaseResponse = try! await self.client.request(r: request).wait() as! BaseResponse<AccountInfoResponse>
        XCTAssertEqual(response.type, expected["type"] as! String)
        XCTAssertEqual(response.result?.validated, (expected["result"] as! [String: AnyObject])["validated"] as? Bool)
        XCTAssert(response.result?.ledgerHash is String)
        XCTAssert(response.result?.ledgerIndex is Int)

        var responseJson: [String: AnyObject] = try! response.result!.accountData.toJson()
        responseJson["PreviousTxnID"] = nil
        responseJson["PreviousTxnLgrSeq"] = nil
        responseJson["Sequence"] = nil
        responseJson["index"] = nil
        var expectedJson: [String: AnyObject] = (expected["result"] as! [String: AnyObject])["account_data"] as! [String: AnyObject]
        expectedJson["PreviousTxnID"] = nil
        expectedJson["PreviousTxnLgrSeq"] = nil
        expectedJson["Sequence"] = nil
        expectedJson["index"] = nil
        XCTAssert(responseJson == expectedJson)
        exp.fulfill()
        await waitForExpectations(timeout: TIMEOUT)
    }
}
