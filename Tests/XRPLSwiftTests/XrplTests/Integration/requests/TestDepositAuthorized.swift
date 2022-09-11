//
//  TestDepositAuthorized.swift
//
//
//  Created by Denis Angell on 8/20/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/integration/requests/depositAuthorized.ts

import XCTest
@testable import XRPLSwift

final class TestIDepositAuthorized: RippledITestCase {

    let TIMEOUT: Double = 20
    var expected: [String: AnyObject] = [:]
    var wallet2: Wallet!

    override func setUp() async throws {
        try await super.setUp()
        expected = [
            "id": 0,
            "type": "response",
            "result": [
                "destination_account": "rnBALxSk5mxLSVmepqh2k7bxq8RpsWNNmu",
                "ledger_current_index": 161,
                "deposit_authorized": 1,
                "validated": 0,
                "source_account": "rBfoZmA95RX7Ax1txZ3SzGnr3SkJB7zc75"
            ]
        ] as [String: AnyObject]
        wallet2 = await generateFundedWallet(client: self.client)
    }

    override func tearDown() async throws {
        try await super.tearDown()
    }

    func testJson() async {
        // create the expectation
        let exp = expectation(description: "base")

        let json = [
            "command": "deposit_authorized",
            "source_account": self.wallet.classicAddress,
            "destination_account": wallet2.classicAddress
        ] as [String: AnyObject]
        let request: DepositAuthorizedRequest = try! DepositAuthorizedRequest(json)
        let response: BaseResponse = try! await self.client.request(r: request).wait() as! BaseResponse<DepositAuthorizedResponse>
        XCTAssertEqual(response.type, expected["type"] as! String)

        let responseJson: [String: AnyObject] = try! response.result!.toJson()
        var expectedJson: [String: AnyObject] = expected["result"] as! [String: AnyObject]
        expectedJson["deposit_authorized"] = true as AnyObject
        expectedJson["destination_account"] = responseJson["destination_account"]
        expectedJson["ledger_current_index"] = responseJson["ledger_current_index"]
        expectedJson["source_account"] = responseJson["source_account"]
        expectedJson["validated"] = false as AnyObject
        XCTAssert(responseJson == expectedJson)
        exp.fulfill()
        await waitForExpectations(timeout: TIMEOUT)
    }

    func testModel() async {
        // create the expectation
        let exp = expectation(description: "base")
        let request: DepositAuthorizedRequest = DepositAuthorizedRequest(
            sourceAccount: self.wallet.classicAddress,
            destinationAccount: wallet2.classicAddress
        )
        let response: BaseResponse = try! await self.client.request(r: request).wait() as! BaseResponse<DepositAuthorizedResponse>
        XCTAssertEqual(response.type, expected["type"] as! String)

        let responseJson: [String: AnyObject] = try! response.result!.toJson()
        var expectedJson: [String: AnyObject] = expected["result"] as! [String: AnyObject]
        expectedJson["deposit_authorized"] = true as AnyObject
        expectedJson["destination_account"] = responseJson["destination_account"]
        expectedJson["ledger_current_index"] = responseJson["ledger_current_index"]
        expectedJson["source_account"] = responseJson["source_account"]
        expectedJson["validated"] = false as AnyObject
        XCTAssert(responseJson == expectedJson)
        exp.fulfill()
        await waitForExpectations(timeout: TIMEOUT)
    }
}
