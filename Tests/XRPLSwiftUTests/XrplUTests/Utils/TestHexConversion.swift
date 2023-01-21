//
//  TestHexConversion.swift
//  
//
//  Created by Denis Angell on 10/14/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/utils/hexConversion.test.ts

import Foundation

import XCTest
@testable import XRPLSwift

final class TestHexConversionUtils: XCTestCase {

    func testConvert() {
        let str = "example.com"
        let hex = str.convertStringToHex
        XCTAssertEqual(hex, "6578616D706C652E636F6D")
        let result = hex.convertHexToString
        XCTAssertEqual(result, str)
    }
}
