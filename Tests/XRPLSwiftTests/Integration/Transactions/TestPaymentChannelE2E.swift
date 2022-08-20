////
////  TestPaymentChannelE2E.swift
////
////
////  Created by Denis Angell on 6/2/22.
////
//
// import XCTest
// @testable import XRPLSwift
//
// final class TestPaymentChannelE2E: XCTestCase {
//
//    var xrpLedger: Ledger = Ledger(endpoint: .xrpl_rpc_Testnet)
//    var channelHex: String = ""
//    var signatureHex: String = ""
//    var txHash: String = "6EAFFD8940EBBC29364898DF218A644DA052875F69F3A00FA6836FCEFF866F71"
//    
////    1. Create Payment Channel
////    2. Get Channel ID from result ^ (You might have to wait for the validated ledger)
////    3. Create Authorization
//    
//    func testPaymentChannelE2E() {
////        channelCreate()
////        authorizeClaim(hash: txHash)
////        channelClaim()
//    }
//    
//    func authorizeClaim(hash: String) {
//        let exp = expectation(description: "testBasicFunctionality")
//        xrpLedger.tx(hash: hash).whenSuccess { response in
//            self.channelHex = response.getChannelHex()!
//            let params: [String: Any] = [
//                "amount": ReusableValues.amount,
//                "channel": self.channelHex,
//            ]
//            guard let encode = try? ReusableValues.wallet.encodeClaim(dict: params) else {
//                XCTFail("Should generate encode")
//                return
//            }
//            self.signatureHex = ReusableValues.wallet.sign(message: encode).toHexString()
//            exp.fulfill()
//        }
//        waitForExpectations(timeout: 20)
//    }
//
//    func channelCreate() {
//        // create the expectation
//        let exp = expectation(description: "testBasicFunctionality")
//        // call my asynchronous method
//        let amount = try! aAmount(drops: 1000000) // 1.0 XRP
//        let paymentChannel = PaymentChannelCreate(
//            from: ReusableValues.wallet,
//            destination: ReusableValues.destination,
//            publicKey: ReusableValues.wallet.publicKey,
//            amount: amount,
//            settleDelay: 60
//        )
//        paymentChannel.ledger.url = .xrpl_rpc_Testnet
//        _ = paymentChannel.send().always { [self] response in
//            switch response {
//            case .success(let result):
//                print(result)
//                guard let txJson = result["tx_json"] as? [String: AnyObject] else {
//                    XCTFail("INVALID TX JSON")
//                    return
//                }
//                guard let hash = txJson["hash"] as? String else {
//                    XCTFail("INVALID TX HASH")
//                    return
//                }
//                sleep(10)
//                xrpLedger.tx(hash: hash).whenSuccess { response in
//                    self.channelHex = response.getChannelHex()!
//                    let params: [String: Any] = [
//                        "amount": ReusableValues.amount,
//                        "channel": self.channelHex,
//                    ]
//                    guard let encode = try? ReusableValues.wallet.encodeClaim(dict: params) else {
//                        XCTFail("Should generate encode")
//                        return
//                    }
//                    self.signatureHex = ReusableValues.wallet.sign(message: encode).toHexString()
//                    sleep(2)
//                    exp.fulfill()
//                }
//            case .failure(let err):
//                XCTFail(err.localizedDescription)
//            }
//        }
//        
//        // wait three seconds for all outstanding expectations to be fulfilled
//        waitForExpectations(timeout: 40)
//    }
//    
//    func channelClaim() {
//        // create the expectation
//        let exp = expectation(description: "testBasicFunctionality")
//
//        // call my asynchronous method
//        let paymentChannel = PaymentChannelClaim(
//            from: ReusableValues.destWallet,
//            channel: self.channelHex,
//            balance: ReusableValues.amount,
//            amount: ReusableValues.amount,
//            signature: self.signatureHex,
//            publicKey: ReusableValues.wallet.publicKey
//        )
//        paymentChannel.ledger.url = .xrpl_rpc_Testnet
//        _ = paymentChannel.send().always { response in
//            switch response {
//            case .success(let result):
//                guard let result_status = result["engine_result"] as? String else {
//                    XCTFail("Invalid Engine Result")
//                    return
//                }
//                guard result_status == "tesSUCCESS" else {
//                    XCTFail("FAILED TX: \(result_status)")
//                    return
//                }
//                exp.fulfill()
//            case .failure(let err):
//                XCTFail(err.localizedDescription)
//            }
//        }
//        // wait three seconds for all outstanding expectations to be fulfilled
//        waitForExpectations(timeout: 40)
//    }
//    
//    func channelFund() {
//        // create the expectation
//        let exp = expectation(description: "testBasicFunctionality")
//
//        // call my asynchronous method
//        let amount = try! aAmount(drops: 1000000) // 1.0 XRP
//        let paymentChannel = PaymentChannelFund(
//            from: ReusableValues.wallet,
//            channel: ReusableValues.channelHex,
//            amount: amount
//        )
//        paymentChannel.ledger.url = .xrpl_rpc_Testnet
//        _ = paymentChannel.send().always { response in
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
//
// }
