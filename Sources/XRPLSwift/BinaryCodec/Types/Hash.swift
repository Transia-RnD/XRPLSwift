//
//  Hash.swift
//  
//
//  Created by Denis Angell on 7/4/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/binarycodec/types/hash.py

import Foundation


class Hash: SerializedType {
    public var width: Int
    
    init(_ bytes: [UInt8]) {
        self.width = bytes.count
        super.init(bytes: bytes)
    }
    
    func from(value: String) throws -> Hash {
//        if value is String {
//            throw BinaryError.unknownError(error: "Invalid type to construct a {cls.__name__}: expected str, received {value.__class__.__name__}.")
//        }
        return Hash(try! value.asHexArray())
    }
    
    /**
     * Read a Hash object from a BinaryParser
     *
     * @param parser BinaryParser to read the hash from
     * @param hint length of the bytes to read, optional
     */
    override func fromParser(
        parser: BinaryParser,
        hint: Int? = nil
    ) -> Hash {
        return Hash(try! parser.read(n: hint ?? self.width))
    }
    
    /**
     * Overloaded operator for comparing two hash objects
     *
     * @param other The Hash to compare this to
     */
    func compareTo(other: Hash) -> Int {
        print()
        return 0
//        return self.bytes.compare(
//            (this.constructor as typeof Hash).from(other).bytes,
//        )
    }
    
    /**
     * @returns the hex-string representation of this Hash
     */
    override func str() -> String {
        return self.toHex()
    }
    
    /**
       * Returns four bits at the specified depth within a hash
       *
       * @param depth The depth of the four bits
       * @returns The number represented by the four bits
       */
    func nibblet(depth: Int) -> Int {
        let byteIx = depth > 0 ? (depth / 2) | 0 : 0
        var b: UInt8 = self.bytes[byteIx]
        if (depth % 2 == 0) {
          b = (b & 0xf0) >> 4
        } else {
          b = b & 0x0f
        }
        return Int(b)
    }
    
}
