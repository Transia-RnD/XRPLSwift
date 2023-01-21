//
//  TestSignPaymentChannelClaim.swift
//
//
//  Created by Denis Angell on 10/14/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/utils/signPaymentChannelClaim.test.ts

import XCTest
@testable import XRPLSwift

final class TestSignPaymentChannelClaim: XCTestCase {

    func _testSign() {
        let channel = "3E18C05AD40319B809520F1A136370C4075321B285217323396D6FD9EE1E9037"
        let amount = ".00001"
        let privateKey = "ACCD3309DB14D1A4FC9B1DAE608031F4408C85C73EE05E035B7DC8B25840107A"
        let result = try! signPaymentChannelClaim(channel, amount, privateKey)
        XCTAssertEqual(result, ResponseFixtures.signClaim())
    }
}
