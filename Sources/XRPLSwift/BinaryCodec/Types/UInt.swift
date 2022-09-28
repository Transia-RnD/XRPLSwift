//
//  UInt.swift
//
//
//  Created by Denis Angell on 7/11/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/binarycodec/types/uint.py

import Foundation

// swiftlint:disable:next type_name
class xUInt: SerializedType {
    init(_ bytes: [UInt8]) {
        super.init(bytes: bytes)
    }

    var value: Int {
        let data = Data(self.bytes.reversed())
        let value = Int(bigEndian: data.withUnsafeBytes { $0.pointee })
        return value.bigEndian
    }

    /**
     Convert a UInt object to JSON.

     Returns:
     The JSON representation of the UInt object.
     */
    override func toJson() -> Any {
        if self.value is Int {
            return Int(self.value)
        }
        return String(self.value)
    }
}

extension xUInt: Comparable {
    public static func == (lhs: xUInt, rhs: xUInt) -> Bool {
        return lhs.value == rhs.value ? true : false
    }
    public static func != (lhs: xUInt, rhs: xUInt) -> Bool {
        return lhs.value != rhs.value ? true : false
    }
    static func < (lhs: xUInt, rhs: xUInt) -> Bool {
        return lhs.value < rhs.value ? true : false
    }
    static func <= (lhs: xUInt, rhs: xUInt) -> Bool {
        return lhs.value <= rhs.value ? true : false
    }
    static func > (lhs: xUInt, rhs: xUInt) -> Bool {
        return lhs.value > rhs.value ? true : false
    }
    static func >= (lhs: xUInt, rhs: xUInt) -> Bool {
        return lhs.value >= rhs.value ? true : false
    }
}
