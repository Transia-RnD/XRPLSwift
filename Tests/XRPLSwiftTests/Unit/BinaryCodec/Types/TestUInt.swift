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

    // TODO: Review these: // 8/16/32 all need .bigEndian
    func testCompare() {
        let value1: xUInt8 = xUInt8.from(value: 124)
        XCTAssertEqual(value1.value().bigEndian, 124)
        XCTAssertLessThan(value1.value().bigEndian, 125)
        XCTAssertGreaterThan(value1.value().bigEndian, 123)
    }

    func testCompareDifferent() {
        let const: Int = 124
        let string: String = "0000000000000002"
        let uint8: xUInt8 = xUInt8.from(value: const)
        let uint16: xUInt16 = xUInt16.from(value: const)
        let uint32: xUInt32 = xUInt32.from(value: const)
        let uint64: xUInt64 = try! xUInt64.from(value: const)
        let uint64s: xUInt64 = try! xUInt64.from(value: string)

        XCTAssertEqual(Int(uint8.str()), Int(uint16.str()))
        XCTAssertEqual(Int(uint16.str()), Int(uint32.str()))
        XCTAssertEqual(Int(uint32.str()), Int(uint64.str()))
        XCTAssertEqual(uint64.value(), const)
        XCTAssertEqual(uint64s.str(), string)
    }

    // MARK: INVALID SWIFT IMPLEMENTATION
//    func test_raises_invalid_value_type() {
//        let invalidValue: [UInt8] = [1, 2, 3]
//        XCTAssertThrowsError(try xUInt8().from(value: invalidValue))
//        XCTAssertThrowsError(try xUInt16().from(value: invalidValue))
//        XCTAssertThrowsError(try xUInt32().from(value: invalidValue))
//        XCTAssertThrowsError(try xUInt64().from(value: invalidValue))
//    }
}
