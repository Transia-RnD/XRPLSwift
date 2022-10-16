//
//  TestFieldIDCodec.swift
//
//
//  Created by Denis Angell on 7/4/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/tests/unit/core/binarycodec/test_field_id_codec.py

import XCTest
@testable import XRPLSwift

final class TestFieldIDCodec: XCTestCase {

    static let fieldTests: [FieldTest] = DataDrivenFixtures().getFieldTests()

    func testEncode() {
        for test in TestFieldIDCodec.fieldTests {
            let result: String = try! FieldIdCodec.encode(test.name).toHex
            XCTAssertEqual(test.expectedHex, result)
        }
    }

    func testDecode() {
        for test in TestFieldIDCodec.fieldTests {
            let result: String = try! FieldIdCodec.decode(test.expectedHex)
            XCTAssertEqual(test.name, result)
        }
    }
}
