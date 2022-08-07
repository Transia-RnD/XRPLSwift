////
////  TestNFTokenE2E.swift
////
////
////  Created by Denis Angell on 6/2/22.
////
//
//import XCTest
//@testable import XRPLSwift
//
//final class TestNFTokenE2E: XCTestCase {
//
//    var xrpLedger: Ledger = Ledger(endpoint: .xrpl_rpc_Testnet)
//    
//    var nftokenId: String = ""
//    
////    1. Mint NFToken 2x
////    2. Burn NFToken #2
////    3. Create Sell Offer #2
////    4. Accept Sell Offer #2
////    4. Create Buy Offer #2
//    
//    func testNFTokenE2E() {
////        mintToken()
////        burnToken(nftokenId: nftokenId)
//    }
//
//    func mintToken() {
//        // create the expectation
//        let exp = expectation(description: "testBasicFunctionality")
//        // call my asynchronous method
//        let mintTx = NFTokenMint(
//            from: ReusableValues.wallet,
//            nftokenTaxon: 0
//        )
//        mintTx.ledger.url = .xrpl_rpc_Xls20
//        _ = mintTx.send().always { [self] response in
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
//                sleep(5)
//                xrpLedger.tx(hash: hash).whenSuccess { response in
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
//    func burnToken(nftokenId: String) {
//        // create the expectation
//        let exp = expectation(description: "testBasicFunctionality")
//        // call my asynchronous method
//        let burnTx = NFTokenBurn(
//            from: ReusableValues.wallet,
//            account: try! Address(rAddress: ReusableValues.wallet.address),
//            nftokenId: self.nftokenId
//        )
//        burnTx.ledger.url = .xrpl_rpc_Xls20
//        _ = burnTx.send().always { [self] response in
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
//                sleep(5)
//                xrpLedger.tx(hash: hash).whenSuccess { response in
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
//}
