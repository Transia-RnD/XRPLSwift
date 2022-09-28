//
//  TestBinaryCodec.swift
//
//
//  Created by Denis Angell on 7/2/22.
//

import XCTest
@testable import XRPLSwift

final class TestBinaryParser: XCTestCase {

    func testPeekSkipReadMethods() {
        let testHex: String = "00112233445566"
        let testBytes: [UInt8] = testHex.hexToBytes
        let binaryParser = BinaryParser(hex: testHex)
        do {
            let firstByte = try binaryParser.peek()
            XCTAssertEqual(firstByte, testBytes[0])

            try binaryParser.skip(n: 3)
            XCTAssertEqual([UInt8](testBytes[3...]), binaryParser.bytes)

            let nextNBytes = try binaryParser.read(n: 2)
            XCTAssertEqual([UInt8](testBytes[3..<5]), nextNBytes)
        } catch {
            print(error.localizedDescription)
            XCTFail("Could not peek/skip/read BinaryParser")
        }
    }

    func testIntReadMethods() {
        let testHex: String = "01000200000003"
        let binaryParser = BinaryParser(hex: testHex)
        let int8 = binaryParser.readUInt8()
        let int16 = binaryParser.readUInt16()
        let int32 = binaryParser.readUInt32()
        XCTAssertEqual(int8, 1)
        XCTAssertEqual(int16, 2)
        XCTAssertEqual(int32, 3)
    }

    func testReadVariableLengthLength() {
        //        [100, 1000, 10000].forEach { _case in
        [100].forEach { _case in
            let binarySerializer = BinarySerializer()
            let byteString: String = String(repeating: "A2", count: _case)
            let blob = try! Blob.from(value: byteString)
            binarySerializer.writeLengthEncoded(value: blob)

            // hex string representation of encoded length prefix
            let encodedLength = binarySerializer.sink.toHex()
            let binaryParser = BinaryParser(hex: encodedLength)
            let decodedLength = try! binaryParser.readLengthPrefix()
            XCTAssertEqual(_case, decodedLength)
        }
    }
}
