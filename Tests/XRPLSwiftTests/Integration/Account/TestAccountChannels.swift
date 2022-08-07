////
////  TestAccountChannels.swift
////
////
////  Created by Denis Angell on 3/20/22.
////
//
//import XCTest
//@testable import XRPLSwift
//
//final class TestAccounChannels: XCTestCase {
//
//    var xrpLedger: Ledger = Ledger(endpoint: .xrpl_rpc_Testnet)
//    
//    func testBasicFunctionality() {
//        // create the expectation
//        let exp = expectation(description: "testBasicFunctionality")
//
//        xrpLedger.url = .xrpl_rpc_Testnet
//        let data = try! xrpLedger.getAccountChannels(
//            account: "rnzBNWMQ32kVJgPPACQEKd4zeSmwMLhW1X",
//            destination: "rpBE9db55fF1eCN8ab6t8GDy9BT1v2AVi5"
//        ).wait()
//        print(data)
//        exp.fulfill()
//        // wait three seconds for all outstanding expectations to be fulfilled
//        waitForExpectations(timeout: 10)
//    }
//}
