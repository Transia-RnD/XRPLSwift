//
//  Hash128.swift
//
//
//  Created by Denis Angell on 7/4/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/binarycodec/types/hash_128.py

import Foundation

class Hash128: Hash {
    /*
     Codec for serializing and deserializing a hash field with a width
     of 128 bits (16 bytes).
     `See Hash Fields <https://xrpl.org/serialization.html#hash-fields>`_
     */

    internal static var WIDTH128: Int = 16
    internal static var ZERO128 = Hash128([UInt8].init(repeating: 0x0, count: Hash128.WIDTH128))

    override init(_ bytes: [UInt8]? = nil) {
        super.init(bytes ?? Hash128.ZERO128.bytes)
    }

    override class func getLength() -> Int {
        return Hash128.WIDTH128
    }
}
