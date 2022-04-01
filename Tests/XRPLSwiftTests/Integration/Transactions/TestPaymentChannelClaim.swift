//
//  TestPaymentChannelClaim.swift
//
//
//  Created by Denis Angell on 3/20/22.
//

import XCTest
@testable import XRPLSwift

final class TestPaymentChannelClaim: XCTestCase {

    var xrpLedger: XRPLedger = XRPLedger(endpoint: .xrpl_rpc_Testnet)

    func testBasicFunctionality() {
        // create the expectation
        let exp = expectation(description: "testBasicFunctionality")

        // call my asynchronous method
        let paymentChannel = PaymentChannelClaim(
            from: ReusableValues.destWallet,
            channel: ReusableValues.channelHex,
            balance: ReusableValues.amount,
            amount: ReusableValues.amount,
            signature: ReusableValues.channelSig,
            publicKey: ReusableValues.channelPubkey
        )
        paymentChannel.ledger.url = .xrpl_rpc_Testnet
        _ = paymentChannel.send().always { response in
            switch response {
            case .success(let result):
                guard let result_status = result["engine_result"] as? String else {
                    XCTFail("Invalid Engine Result")
                    return
                }
                guard result_status == "tesSUCCESS" else {
                    XCTFail("FAILED TX: \(result_status)")
                    return
                }
                exp.fulfill()
            case .failure(let err):
                XCTFail(err.localizedDescription)
            }
        }
        // wait three seconds for all outstanding expectations to be fulfilled
        waitForExpectations(timeout: 10)
    }
}
