//
//  TestKeypairsUtils.swift
//  
//
//  Created by Denis Angell on 8/7/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/ripple-keypairs/test/utils-test.js

import Foundation

import XCTest
@testable import XRPLSwift

final class TestKeypairsUtils: XCTestCase {

    func testEmptyHexToBytes() {
        XCTAssertEqual("".hexToBytes, [])
    }

    func testZeroHexToBytes() {
        XCTAssertEqual("000000".hexToBytes, [0, 0, 0])
    }

    func testMiscHexToBytes() {
        XCTAssertEqual("DEADBEEF".hexToBytes, [222, 173, 190, 239])
    }

    func testMiscBytesToHex() {
        XCTAssertEqual(Data(hex: "DEADBEEF").toHex, "DEADBEEF")
    }

    func testMisc1BytesToHex() {
        XCTAssertEqual([UInt8]([222, 173, 190, 239]).toHex, "DEADBEEF")
    }

    func testFailHexToBytes() {
        // BAD BAD BAD BAD
        XCTAssertNotEqual("DEADBEEF".bytes.toHex, "DEADBEEF")
    }
}
