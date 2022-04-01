//
//  TestPaymentChannelCreate.swift
//
//
//  Created by Denis Angell on 3/20/22.
//

import XCTest
@testable import XRPLSwift

final class TestPaymentChannelCreate: XCTestCase {

    var xrpLedger: XRPLedger = XRPLedger(endpoint: .xrpl_rpc_Testnet)

    func testBasicFunctionality() {
        // create the expectation
        let exp = expectation(description: "testBasicFunctionality")

        // call my asynchronous method
        let amount = try! XRPAmount(drops: 1000000) // 1.0 XRP
        let paymentChannel = PaymentChannelCreate(
            from: ReusableValues.wallet,
            to: ReusableValues.destination,
            amount: amount,
            settleDelay: 60
        )
        paymentChannel.ledger.url = .xrpl_rpc_Testnet
        _ = paymentChannel.send().always { response in
            switch response {
            case .success(let result):
                exp.fulfill()
            case .failure(let err):
                XCTFail(err.localizedDescription)
            }
        }
        // wait three seconds for all outstanding expectations to be fulfilled
        waitForExpectations(timeout: 10)
    }
}
