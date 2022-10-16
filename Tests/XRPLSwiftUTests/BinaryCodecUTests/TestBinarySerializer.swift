//
//  TestBinarySerializer.swift
//
//
//  Created by Denis Angell on 7/2/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/tests/unit/core/binarycodec/test_binary_serializer.py

import XCTest
@testable import XRPLSwift

final class TestBinarySerializer: XCTestCase {

    func testWriteLengthEncoded() {
        let array: [Int] = [100, 1000, 10000]
        array.forEach { _case in
            let byteString: String = String(repeating: "A2", count: _case)
            let blob = try! Blob.from(byteString)
            XCTAssertEqual(blob.bytes.count, _case)

            let binarySerializer = BinarySerializer()
            binarySerializer.writeLengthEncoded(blob)
            let binaryParser = BinaryParser(hex: binarySerializer.sink.toBytes().toHex)
            let decodedLength = try! binaryParser.readLengthPrefix()
            XCTAssertEqual(_case, decodedLength)
        }
    }
}
