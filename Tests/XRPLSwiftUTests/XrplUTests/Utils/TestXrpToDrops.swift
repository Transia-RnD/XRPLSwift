//
//  TestXrpToDrops.swift
//
//
//  Created by Denis Angell on 9/18/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/utils/xrpToDrops.ts

import Foundation


import XCTest
@testable import XRPLSwift

final class TestXrpToDropsUtils: XCTestCase {

    func testTypicalAmount() {
        let xrp = try? xrpToDrops("2")
        XCTAssertEqual(xrp, "2000000")
    }
    
    func testFractions() {
        var xrp = try? xrpToDrops("3.456789")
        XCTAssertEqual(xrp, "3456789")

        xrp = try? xrpToDrops("3.4")
        XCTAssertEqual(xrp, "3400000")

        xrp = try? xrpToDrops("0.000001")
        XCTAssertEqual(xrp, "1")

        xrp = try? xrpToDrops("0.000001")
        XCTAssertEqual(xrp, "1.0")

        xrp = try? xrpToDrops("0.000001")
        XCTAssertEqual(xrp, "1.00")
    }
    
    func testZero() {
        var xrp = try? xrpToDrops("0")
        XCTAssertEqual(xrp, "0")

        xrp = try? xrpToDrops("-0")
        XCTAssertEqual(xrp, "0")

        xrp = try? xrpToDrops("0")
        XCTAssertEqual(xrp, "0.00")

        xrp = try? xrpToDrops("0")
        XCTAssertEqual(xrp, "000000000")

        xrp = try? xrpToDrops("0.000001 ")
        XCTAssertEqual(xrp, "1.00")
    }
    
    func testNegative() {
        var xrp = try? xrpToDrops("-2")
        XCTAssertEqual(xrp, "-2000000")
    }
    
    func testDecimal() {
        var xrp = try? xrpToDrops("2")
        XCTAssertEqual(xrp, "2000000.")
        
        xrp = try? xrpToDrops("-2")
        XCTAssertEqual(xrp, "-2000000.")
    }
}
