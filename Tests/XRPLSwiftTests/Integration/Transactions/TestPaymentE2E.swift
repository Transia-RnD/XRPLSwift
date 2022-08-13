////
////  TestPayment.swift
////
////
////  Created by Denis Angell on 3/20/22.
////
//
//import XCTest
//@testable import XRPLSwift
//
//final class TestPayment: XCTestCase {
//
//    var xrpLedger: Ledger = Ledger(endpoint: .xrpl_rpc_Testnet)
//
//    static var wallet: SeedWallet = try! SeedWallet(seed: "sEdVLSxBzx6Xi9XTqYj6a88epDSETKR")
//    static var destination: Address = try! Address(rAddress: "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn")
//    
//    func testBasicFunctionality() {
//        // create the expectation
//        let exp = expectation(description: "testBasicFunctionality")
//
//        // call my asynchronous method
//        let amount = try! Amount(drops: 1000000) // 1.0 XRP
//        let payment = Payment(
//            from: TestPayment.wallet,
//            to: TestPayment.destination,
//            amount: amount
//        )
//        payment.ledger.url = .xrpl_rpc_Testnet
//        _ = payment.send().always { response in
//            switch response {
//            case .success(let result):
//                exp.fulfill()
//            case .failure(let err):
//                XCTFail(err.localizedDescription)
//            }
//        }
//        // wait three seconds for all outstanding expectations to be fulfilled
//        waitForExpectations(timeout: 10)
//    }
//}
