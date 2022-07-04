//
//  Hash160.swift
//  
//
//  Created by Denis Angell on 7/4/22.
//

import Foundation


class Hash160: Hash {
    static public var width: Int = 20
    static public var ZERO_160: Hash160 = Hash160(Data(bytes: [], count: Hash160.width).bytes)
    
    override init(_ bytes: [UInt8]?) {
//        if (!bytes.isEmpty && bytes.count == 0) {
//            bytes = Hash160.ZERO_160.bytes
//        }
        super.init(bytes ?? Hash160.ZERO_160.bytes)
    }
}
