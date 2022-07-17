//
//  TestHashTypes.swift
//  
//
//  Created by Denis Angell on 7/11/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/tests/unit/core/binarycodec/types/test_hash_types.py

import XCTest
@testable import XRPLSwift

final class TestHash128: XCTestCase {
    
    public var hex_128_bits: String = ""
    public var parser: BinaryParser?
    public let expectedWidth: Int = 16
    
    func testConstructors() {
        self.hex_128_bits = "10000000002000000000300000000012"
        self.parser = BinaryParser(hex: hex_128_bits)
        
        let fromConstructor: Hash128 = Hash128(try! self.hex_128_bits.asHexArray())
        let fromValue: SerializedType = try! Hash128().from(value: self.hex_128_bits)
        let fromParser: Hash = Hash128().fromParser(parser: self.parser!)
        XCTAssertEqual(fromConstructor.toHex(), self.hex_128_bits)
        XCTAssertEqual(fromValue.toHex(), self.hex_128_bits)
        XCTAssertEqual(fromParser.toHex(), self.hex_128_bits)
    }
    
    func testConstructorRaisesInvalidLength() {
        // 17 bytes, 34 nibbles
        let tooManyBytesHex: String = "1000000000200000000030000000001234"
        XCTAssertThrowsError(try Hash128().from(value: tooManyBytesHex))
    }

    // This test is not necessary in Swift?
//    func testRaisesInvalidValueType() {
//        let invalidValue: Int = 1
//        XCTAssertThrowsError(try! Hash128().from(value: invalidValue))
//    }
}

final class TestHash160: XCTestCase {
    // 20 bytes, 40 nibbles
    public var hex_160_bits: String = ""
    public var parser: BinaryParser?
    public let expectedWidth: Int = 20
    
    func testConstructors() {
        self.hex_160_bits = "1000000000200000000030000000004000000000"
        self.parser = BinaryParser(hex: hex_160_bits)
        
        let fromConstructor: Hash160 = Hash160(try! self.hex_160_bits.asHexArray())
        let fromValue: SerializedType = try! Hash160().from(value: self.hex_160_bits)
        let fromParser: Hash = Hash160().fromParser(parser: self.parser!)
        XCTAssertEqual(fromConstructor.toHex(), self.hex_160_bits)
        XCTAssertEqual(fromValue.toHex(), self.hex_160_bits)
        XCTAssertEqual(fromParser.toHex(), self.hex_160_bits)
    }
    
    func testConstructorRaisesInvalidLength() {
        // 21 bytes, 42 nibbles
        let tooManyBytesHex: String = "100000000020000000003000000000400000000012"
        XCTAssertThrowsError(try Hash160().from(value: tooManyBytesHex))
    }

    // This test is not necessary in Swift?
//    func testRaisesInvalidValueType() {
//        let invalidValue: Int = 1
//        XCTAssertThrowsError(try! Hash160().from(value: invalidValue))
//    }
}


final class TestHash256: XCTestCase {
    // 32 bytes, 64 nibbles
    public var hex_256_bits: String = ""
    public var parser: BinaryParser?
    public let expectedWidth: Int = 32
    
    func testConstructors() {
        self.hex_256_bits = "1000000000200000000030000000004000000000500000000060000000001234"
        self.parser = BinaryParser(hex: hex_256_bits)
        
        let fromConstructor: Hash256 = Hash256(try! self.hex_256_bits.asHexArray())
        let fromValue: SerializedType = try! Hash256().from(value: self.hex_256_bits)
        let fromParser: Hash = Hash256().fromParser(parser: self.parser!)
        XCTAssertEqual(fromConstructor.toHex(), self.hex_256_bits)
        XCTAssertEqual(fromValue.toHex(), self.hex_256_bits)
        XCTAssertEqual(fromParser.toHex(), self.hex_256_bits)
    }
    
    func testConstructorRaisesInvalidLength() {
        // 33 bytes, 66 nibbles
        let tooManyBytesHex: String = "100000000020000000003000000000400000000050000000006000000000123456"
        XCTAssertThrowsError(try Hash256().from(value: tooManyBytesHex))
    }

    // This test is not necessary in Swift?
//    func testRaisesInvalidValueType() {
//        let invalidValue: Int = 1
//        XCTAssertThrowsError(try! Hash256().from(value: invalidValue))
//    }
}
