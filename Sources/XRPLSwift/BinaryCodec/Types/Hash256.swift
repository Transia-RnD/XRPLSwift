//
//  Hash256.swift
//
//
//  Created by Denis Angell on 7/4/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/binarycodec/types/hash_256.py

import Foundation


class Hash256: Hash {
    
    /*
    Codec for serializing and deserializing a hash field with a width
    of 256 bits (32 bytes).
    `See Hash Fields <https://xrpl.org/serialization.html#hash-fields>`_
    */
    
    static public var width: Int = 32
    static public var ZERO_256: Hash256 = Hash256(Data(bytes: [], count: Hash256.width).bytes)
    
    override init(_ bytes: [UInt8]? = nil) {
        super.init(bytes ?? Hash256.ZERO_256.bytes)
    }
}
