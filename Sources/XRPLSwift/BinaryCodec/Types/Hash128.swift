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
    
    static public var width: Int = 16
    static public var ZERO_128: Hash128 = Hash128(Data(bytes: [], count: Hash128.width).bytes)
    
    override init(_ bytes: [UInt8]? = nil) {
        super.init(bytes ?? Hash128.ZERO_128.bytes)
    }
}
