//
//  UInt.swift
//
//
//  Created by Denis Angell on 7/11/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/binarycodec/types/uint.py

import Foundation


class xUInt: SerializedType {
    
    init(_ bytes: [UInt8]) {
        super.init(bytes: bytes)
    }
    
    // TODO: REVIEW THIS: See Tests...
    func value() -> Int {
        let data = Data(self.bytes)
        let value = Int(bigEndian: data.withUnsafeBytes { $0.pointee })
        return value
    }
    
//    class func from(value: Int) throws -> xUInt {
//        return xUInt(try! value.asHexArray())
//    }
    
}

extension xUInt: Comparable {
    public static func == (lhs: xUInt, rhs: xUInt) -> Bool {
        return lhs.value() == rhs.value() ? true : false
    }
    public static func != (lhs: xUInt, rhs: xUInt) -> Bool {
        return lhs.value() != rhs.value() ? true : false
    }
    static func < (lhs: xUInt, rhs: xUInt) -> Bool {
        return lhs.value() < rhs.value() ? true : false
    }
    static func <= (lhs: xUInt, rhs: xUInt) -> Bool {
        return lhs.value() <= rhs.value() ? true : false
    }
    static func > (lhs: xUInt, rhs: xUInt) -> Bool {
        return lhs.value() > rhs.value() ? true : false
    }
    static func >= (lhs: xUInt, rhs: xUInt) -> Bool {
        return lhs.value() >= rhs.value() ? true : false
    }
}
