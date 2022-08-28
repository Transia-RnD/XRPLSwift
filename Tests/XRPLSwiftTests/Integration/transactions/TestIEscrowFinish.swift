//
//  TestIEscrowFinish.swift
//  
//
//  Created by Denis Angell on 8/26/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/integration/transactions/escrowFinish.ts

import XCTest
@testable import XRPLSwift

final class TestIEscrowFinish: RippledITestCase {
    
    let TIMEOUT: Double = 20
    
    override func setUp() async throws {
        try await super.setUp()
    }
    
    override func tearDown() async throws {
        try await super.tearDown()
    }
    
    func testJson() async {
        // create the expectation
        let exp = expectation(description: "base")
        
        XCTFail()
        exp.fulfill()
        await waitForExpectations(timeout: TIMEOUT)
    }
}
