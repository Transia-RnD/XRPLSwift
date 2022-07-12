//
//  TestBlob.swift
//
//
//  Created by Denis Angell on 7/4/22.
//

import XCTest
@testable import XRPLSwift

final class TestBlob: XCTestCase {
    
    func testFromValue() {
        let value: String = "00AA"
        let valueBytes: [UInt8] = try! value.asHexArray()

        let blob1: Blob = try! Blob.from(value: value)
        let blob2: Blob = Blob(valueBytes)

        XCTAssertEqual(blob1.toBytes(), blob2.toBytes())
    }
    
    func testFromValue() {
        let value: String = "00AA"
        let valueBytes: [UInt8] = try! value.asHexArray()

        let blob1: Blob = try! Blob.from(value: value)
        let blob2: Blob = Blob(valueBytes)

        XCTAssertEqual(blob1.toBytes(), blob2.toBytes())
    }
}

