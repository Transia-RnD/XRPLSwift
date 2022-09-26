//
//  File.swift
//  
//
//  Created by Denis Angell on 9/18/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/utils/dropsToXrp.ts

import Foundation

import XCTest
@testable import XRPLSwift

final class TestDropsToXrpUtils: XCTestCase {

    func testTypicalAmount() {
        let xrp = try? dropsToXrp("2000000")
        XCTAssertEqual(xrp, "2")
    }

    func testFractions() {
        var xrp = try? dropsToXrp("3456789")
        XCTAssertEqual(xrp, "3.456789")

        xrp = try? dropsToXrp("3400000")
        XCTAssertEqual(xrp, "3.4")

        xrp = try? dropsToXrp("1")
        XCTAssertEqual(xrp, "0.000001")

        xrp = try? dropsToXrp("1.0")
        XCTAssertEqual(xrp, "0.000001")

        xrp = try? dropsToXrp("1.00")
        XCTAssertEqual(xrp, "0.000001")
    }

    func testZero() {
        var xrp = try? dropsToXrp("0")
        XCTAssertEqual(xrp, "0")

        xrp = try? dropsToXrp("-0")
        XCTAssertEqual(xrp, "0")

        xrp = try? dropsToXrp("0.00")
        XCTAssertEqual(xrp, "0")

        xrp = try? dropsToXrp("000000000")
        XCTAssertEqual(xrp, "0")

        xrp = try? dropsToXrp("1.00")
        XCTAssertEqual(xrp, "0.000001")
    }

    func testNegative() {
        var xrp = try? dropsToXrp("-2000000")
        XCTAssertEqual(xrp, "-2")
    }

    func testDecimal() {
        var xrp = try? dropsToXrp("2000000.")
        XCTAssertEqual(xrp, "2")

        xrp = try? dropsToXrp("-2000000.")
        XCTAssertEqual(xrp, "-2")
    }
}
