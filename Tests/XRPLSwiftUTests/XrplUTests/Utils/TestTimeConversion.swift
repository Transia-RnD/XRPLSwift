//
//  File.swift
//  
//
//  Created by Denis Angell on 10/15/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/utils/timeConversion.test.ts

import XCTest
@testable import XRPLSwift

class TimeConversionTests: XCTestCase {
    func testRippleTimeToISOTime() {
        let rippleTime: Int = 0
        let isoTime = "2000-01-01T00:00:00.000Z"
        XCTAssertEqual(rippleTimeToISOTime(rippleTime), isoTime)
    }

    func testISOTimeToRippleTime() {
        let rippleTime: Int = 0
        let isoTime = "2000-01-01T00:00:00.000Z"
        XCTAssertEqual(isoTimeToRippleTime(isoTime), rippleTime)
    }

    func testISOTimeToRippleTimeFromDate() {
        let rippleTime: Int = 0
        let isoTime = "2000-01-01T00:00:00.000Z"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = formatter.date(from: isoTime)!
        XCTAssertEqual(isoTimeToRippleTime(date), rippleTime)
    }

    func testUnixTimeToRippleTime() {
        let unixTime: Int = 946684801000
        let rippleTime: Int = 1
        XCTAssertEqual(unixTimeToRippleTime(unixTime), rippleTime)
    }

    func testRippleTimeToUnixTime() {
        let unixTime: Int = 946684801000
        let rippleTime: Int = 1
        XCTAssertEqual(rippleTimeToUnixTime(rippleTime), unixTime)
    }
}
