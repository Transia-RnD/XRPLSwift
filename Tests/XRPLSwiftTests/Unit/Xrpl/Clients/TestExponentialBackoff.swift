//
//  TestExponentialBackoff.swift
//  
//
//  Created by Denis Angell on 7/27/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/ExponentialBackoff.ts

import Foundation

import XCTest
@testable import XRPLSwift

final class TestExponentialBackoff: XCTestCase {
    
    func testExponentialBackoffDuration() {
        XCTAssert(ExponentialBackoff().duration() == 100)
        var options: ExponentialBackoffOptions = ExponentialBackoffOptions(min: 100)
        XCTAssert(ExponentialBackoff(opts: options).duration() == 100)
        options.min = 123
        XCTAssert(ExponentialBackoff(opts: options).duration() == 123)
    }
    
    func testExponentialBackoffIncreaseReturn() {
        let options: ExponentialBackoffOptions = ExponentialBackoffOptions(min: 100, max: 1000)
        let backoff: ExponentialBackoff = ExponentialBackoff(opts: options)
        XCTAssert(backoff.duration() == 100)
        XCTAssert(backoff.duration() == 200)
        XCTAssert(backoff.duration() == 400)
        XCTAssert(backoff.duration() == 800)
    }
    
    func testExponentialBackoffNeverReturn() {
        let options: ExponentialBackoffOptions = ExponentialBackoffOptions(min: 300, max: 1000)
        let backoff: ExponentialBackoff = ExponentialBackoff(opts: options)
        XCTAssert(backoff.duration() == 300)
        XCTAssert(backoff.duration() == 600)
        XCTAssert(backoff.duration() == 1000)
        XCTAssert(backoff.duration() == 1000)
    }
    
    func testExponentialBackoffReset() {
        let options: ExponentialBackoffOptions = ExponentialBackoffOptions(min: 100, max: 1000)
        let backoff: ExponentialBackoff = ExponentialBackoff(opts: options)
        XCTAssert(backoff.duration() == 100)
        XCTAssert(backoff.duration() == 200)
        XCTAssert(backoff.duration() == 400)
        backoff.reset()
        XCTAssert(backoff.duration() == 100)
        XCTAssert(backoff.duration() == 200)
    }
}
