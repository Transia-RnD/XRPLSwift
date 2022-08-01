//
//  TestIsConnected.swift
//
//
//  Created by Denis Angell on 7/27/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/client/isConnected.ts

import Foundation

import XCTest
@testable import XRPLSwift

final class TestIsConnected: XCTestCase {
    
    func testExponentialBackoffDuration() {
        XCTAssert(ExponentialBackoff().duration() == 100)
        var options: ExponentialBackoffOptions = ExponentialBackoffOptions(min: 100)
        XCTAssert(ExponentialBackoff(opts: options).duration() == 100)
        options.min = 123
        XCTAssert(ExponentialBackoff(opts: options).duration() == 123)
    }
}
