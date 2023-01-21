//
//  TestBookOffers.swift
//
//
//  Created by Denis Angell on 8/20/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/integration/requests/bookOffers.test.ts

import XCTest
@testable import XRPLSwift

final class TestIBookOffers: RippledITestCase {

    let TIMEOUT: Double = 20
    var expected: [String: AnyObject] = [:]

    override func setUp() async throws {
        try await super.setUp()
        expected = [
            "id": 0,
            "result": [
                "ledger_current_index": 123,
                "offers": [],
                "validated": false
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
            "command": "book_offers",
            "taker_gets": [
                "currency": "XRP"
            ],
            "taker_pays": [
                "currency": "USD",
                "issuer": self.wallet.classicAddress
            ]
        ] as [String: AnyObject]
        let request: BookOffersRequest = try! BookOffersRequest(json)
        let response: BaseResponse = try! await self.client.request(r: request).wait() as! BaseResponse<BookOffersResponse>
        XCTAssertEqual(response.type, expected["type"] as! String)

        let responseJson: [String: AnyObject] = try! response.result!.toJson()
        var expectedJson: [String: AnyObject] = expected["result"] as! [String: AnyObject]
        expectedJson["ledger_current_index"] = responseJson["ledger_current_index"]
        expectedJson["offers"] = responseJson["offers"]
        XCTAssert(responseJson == expectedJson)
        exp.fulfill()
        await waitForExpectations(timeout: TIMEOUT)
    }

    func testModel() async {
        // create the expectation
        let exp = expectation(description: "base")
        let request: BookOffersRequest = BookOffersRequest(
            takerGets: TakerAmount(currency: "XRP", issuer: nil),
            takerPays: TakerAmount(currency: "USD", issuer: self.wallet.classicAddress)
        )
        let response: BaseResponse = try! await self.client.request(r: request).wait() as! BaseResponse<BookOffersResponse>
        XCTAssertEqual(response.type, expected["type"] as! String)

        let responseJson: [String: AnyObject] = try! response.result!.toJson()
        var expectedJson: [String: AnyObject] = expected["result"] as! [String: AnyObject]
        expectedJson["ledger_current_index"] = responseJson["ledger_current_index"]
        expectedJson["offers"] = responseJson["offers"]
        XCTAssert(responseJson == expectedJson)
        exp.fulfill()
        await waitForExpectations(timeout: TIMEOUT)
    }
}
