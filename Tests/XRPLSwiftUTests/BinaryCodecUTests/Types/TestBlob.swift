//
//  TestBlob.swift
//
//
//  Created by Denis Angell on 7/4/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/tests/unit/core/binarycodec/types/test_blob.py

import XCTest
@testable import XRPLSwift

final class TestBlob: XCTestCase {

    func testFromValue() {
        let value: String = "00AA"
        let valueBytes: [UInt8] = value.hexToBytes

        let blob1: Blob = try! Blob.from(value: value)
        let blob2: Blob = Blob(valueBytes)

        XCTAssertEqual(blob1.toBytes(), blob2.toBytes())
    }

    // This test is not necessary in Swift?
//    func testRaisesInvalidValueType() {
//        let invalidValue = [1, 2, 3]
//        XCTAssertThrowsError(Blob.from(value: invalidValue))
//    }
}
