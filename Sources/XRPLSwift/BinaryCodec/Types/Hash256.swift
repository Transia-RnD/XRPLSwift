//
//  Hash256.swift
//
//
//  Created by Denis Angell on 7/4/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/binarycodec/types/hash256.py

import Foundation

class Hash256: Hash {
    /*
     Codec for serializing and deserializing a hash field with a width
     of 256 bits (32 bytes).
     `See Hash Fields <https://xrpl.org/serialization.html#hash-fields>`_
     */

    internal static var WIDTH256: Int = 32
    internal static var ZERO256 = Hash256([UInt8].init(repeating: 0x0, count: Hash256.WIDTH256))

    override init(_ bytes: [UInt8]? = nil) {
        super.init(bytes ?? Hash256.ZERO256.bytes)
    }

    override class func getLength() -> Int {
        return Hash256.WIDTH256
    }
}
