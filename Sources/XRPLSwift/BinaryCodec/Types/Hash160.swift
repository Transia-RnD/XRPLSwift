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
    
    static public var width: Int = 20
    static public var ZERO_160: Hash160 = Hash160(Data(bytes: [], count: Hash160.width).bytes)
    
    override init(_ bytes: [UInt8]? = nil) {
        super.init(bytes ?? Hash160.ZERO_160.bytes)
    }
}
