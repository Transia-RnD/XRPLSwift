//
//  Hash160.swift
//
//
//  Created by Denis Angell on 7/4/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/binarycodec/types/hash_160.py

import Foundation

class Hash160: Hash {
    /*
     Codec for serializing and deserializing a hash field with a width
     of 160 bits (20 bytes).
     `See Hash Fields <https://xrpl.org/serialization.html#hash-fields>`_
     */

    internal static var WIDTH160: Int = 20
    internal static var ZERO160 = Hash160([UInt8].init(repeating: 0x0, count: Hash160.WIDTH160))

    override init(_ bytes: [UInt8]? = nil) {
        super.init(bytes ?? Hash160.ZERO160.bytes)
    }

    override class func getLength() -> Int {
        return Hash160.WIDTH160
    }
}
