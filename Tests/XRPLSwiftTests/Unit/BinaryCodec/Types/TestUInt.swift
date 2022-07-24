//
//  TestUInt.swift
//  
//
//  Created by Denis Angell on 7/11/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/tests/unit/core/binarycodec/types/test_uint.py

import XCTest
@testable import XRPLSwift

final class TestUInt: XCTestCase {
    func test_from_value() {
        let value1 = xUInt8.from(value: 124)
        let value2 = xUInt8.from(value: 123)
        let value3 = xUInt8.from(value: 124)
        
        XCTAssertGreaterThan(value1, value2)
        XCTAssertLessThan(value2, value1)
        XCTAssertNotEqual(value1, value2)
        XCTAssertEqual(value1, value3)
    }

    func testCompare() {
        let value1: xUInt8 = xUInt8.from(value: 124)
//        XCTAssertEqual(value1, 124)
//        XCTAssertLessThan(value1, 125)
//        XCTAssertGreaterThan(value1, 123)
    }
//
    func testCompareDifferent() {
        let const: Int = 124
        let uint8: xUInt8 = xUInt8.from(value: const)
        let uint16: xUInt16 = xUInt16.from(value: const)
        let uint32: xUInt32 = xUInt32.from(value:const)
        let uint64: xUInt64 = xUInt64.from(value:const)

        XCTAssertEqual(uint8, uint16)
        XCTAssertEqual(uint16, uint32)
        XCTAssertEqual(uint32, uint64)
//        XCTAssertEqual(uint64.value(), const)
    }

    // This test is not necessary in Swift?
//    func test_raises_invalid_value_type() {
//        let invalidValue: [UInt8] = [1, 2, 3]
//        XCTAssertThrowsError(try xUInt8().from(value: invalidValue))
//        XCTAssertThrowsError(try xUInt16().from(value: invalidValue))
//        XCTAssertThrowsError(try xUInt32().from(value: invalidValue))
//        XCTAssertThrowsError(try xUInt64().from(value: invalidValue))
//    }
}
