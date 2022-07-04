//
//  Hash.swift
//  
//
//  Created by Denis Angell on 7/4/22.
//

import Foundation


class Hash: SerializedType {
    public var width: Int
    
    init(_ bytes: [UInt8]) {
        self.width = bytes.count
        super.init(bytes: bytes)
        //        if (this.bytes.byteLength !== (this.constructor as typeof Hash).width) {
        //          throw new Error(`Invalid Hash length ${this.bytes.byteLength}`)
        //        }
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
