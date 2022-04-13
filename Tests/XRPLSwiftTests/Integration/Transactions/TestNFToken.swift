//
//  TestNFTokenMint.swift
//
//
//  Created by Denis Angell on 3/20/22.
//

import XCTest
@testable import XRPLSwift

final class TestNFTokenMint: XCTestCase {

    var xrpLedger: Ledger = Ledger(endpoint: .xrpl_rpc_Testnet)
    
    static var uri: String = "ipfs://QmUs97DuBbqmzm4F4FZpQcx9ssSM7TxwP1pPj1b7hxgaYM"

    func testBasicFunctionality() {
        // create the expectation
        let exp = expectation(description: "testBasicFunctionality")
        
        XCTAssert(TestNFTokenMint.uri.data(using: String.Encoding.utf8)?.toHexString().uppercased() == "697066733A2F2F516D5573393744754262716D7A6D344634465A70516378397373534D37547877503170506A31623768786761594D")

        // call my asynchronous method
        let payment = NFTokenMint(
            wallet: ReusableValues.wallet,
            tokenTaxon: 0,
            uri: TestNFTokenMint.uri.data(using: String.Encoding.utf8)?.toHexString().uppercased()
        )
        payment.ledger.url = .xrpl_rpc_Testnet
        _ = payment.send().always { response in
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
