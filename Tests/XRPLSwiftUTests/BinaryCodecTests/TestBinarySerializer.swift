//
//  TestBinarySerializer.swift
//
//
//  Created by Denis Angell on 7/2/22.
//

import XCTest
@testable import XRPLSwift

final class TestUBinarySerializer: XCTestCase {

    func testWriteLengthEncoded() {
//        [100, 1000, 10000].forEach { _case in
        [100].forEach { _case in
            let byteString: String = String(repeating: "A2", count: _case)
            let blob = try! Blob.from(value: byteString)
            XCTAssertEqual(blob.bytes.count, _case)

            let binarySerializer = BinarySerializer()
            binarySerializer.writeLengthEncoded(value: blob)
            let binaryParser = BinaryParser(hex: binarySerializer.sink.toBytes().toHexString().uppercased())
            let decodedLength = try! binaryParser.readLengthPrefix()
            XCTAssertEqual(_case, decodedLength)
        }
    }
}
