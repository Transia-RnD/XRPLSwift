//
//  TestVerifyPaymentChannelClaim.swift
//  
//
//  Created by Denis Angell on 10/14/22.
//

import Foundation

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/utils/verifyPaymentChannelClaim.ts

import Foundation

import XCTest
@testable import XRPLSwift

final class TestVerifyPaymentChannelClaim: XCTestCase {

    func testVerify() {
        let publicKey = "02F89EAEC7667B30F33D0687BBA86C3FE2A08CCA40A9186C5BDE2DAA6FA97A37D8"
        let claim = RequestFixtures.signClaim()
        let result = try! verifyPaymentChannelClaim(
            claim["channel"] as! String,
            claim["amount"] as! String,
            ResponseFixtures.signClaim(),
            publicKey
        )
        XCTAssertEqual(result, true)
    }
}
