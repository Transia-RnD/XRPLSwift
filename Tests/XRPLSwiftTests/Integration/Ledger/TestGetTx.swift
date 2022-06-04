//
//  TestGetTx.swift
//
//
//  Created by Denis Angell on 3/20/22.
//

import XCTest
@testable import XRPLSwift

final class TestGetTx: XCTestCase {

    var xrpLedger: Ledger = Ledger(endpoint: .xrpl_rpc_Testnet)
    
    func testBasicFunctionality() {
        // create the expectation
        let exp = expectation(description: "testBasicFunctionality")

        let hash: String = "D3DE34916F40F5C96AE5DD9117B25719FC311E6B299109CDB082A694B76F2D0A"
        xrpLedger.url = .xrpl_rpc_Hooknet
        let data = try! xrpLedger.tx(hash: hash).wait()
        print(data)
        exp.fulfill()
        // wait three seconds for all outstanding expectations to be fulfilled
        waitForExpectations(timeout: 10)
    }
    
    func getChannelId(tx: XrplBaseTransaction) -> String? {
        guard let meta = tx.meta, let nodes = meta.affectedNodes else {
            return nil
        }
        for node in nodes {
            if let nnode = node.get() as? CreatedNode, nnode.ledgerEntryType == .paychannel {
                return nnode.ledgerIndex
            }
        }
        return nil
    }
    
    func testChannelFunctionality() {
        // create the expectation
        let exp = expectation(description: "testBasicFunctionality")

        let hash: String = "B835D1E38C9581626A001157A142B392CBBB3C172A5E46411228184E83D51164"
        xrpLedger.url = .xrpl_rpc_Testnet
        let response = try! xrpLedger.tx(hash: hash).wait()
        let channelId = getChannelId(tx: response)
        XCTAssert(channelId == "A9FF7AB19A4F6F39825327AA3391047894F14ADF8D425B0F92943ACD7A5231B7")
        exp.fulfill()
        // wait three seconds for all outstanding expectations to be fulfilled
        waitForExpectations(timeout: 10)
    }
}
