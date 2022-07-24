//
//  xUInt64.swift
//
//
//  Created by Denis Angell on 7/12/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/binarycodec/types/uint64.py

import Foundation

internal let WIDTH64: Int = 8  // 64 / 8

class xUInt64: xUInt {
    /*
    Class for serializing and deserializing an 8-bit UInt.
    See `UInt Fields <https://xrpl.org/serialization.html#uint-fields>`_
     */
    
    static public var ZERO_64: xUInt64 = xUInt64([UInt8].init(repeating: 0x0, count: WIDTH64))

    override init(_ bytes: [UInt8]? = nil) {
        // Construct a new xUInt64 type from a ``bytes`` value.
        super.init(bytes ?? xUInt64.ZERO_64.bytes)
    }

    /*
    Construct a new xUInt64 type from a BinaryParser.
    Args:
        parser: The parser to construct a xUInt32 from.
    Returns:
        A new xUInt64.
    */
    override func fromParser(
        parser: BinaryParser,
        hint: Int? = nil
    ) -> xUInt64 {
        return try! xUInt64(parser.read(n: WIDTH64))
    }

    /*
    Construct a new xUInt64 type from a number.
    Args:
        value: The value to construct a xUInt64 from.
    Returns:
        A new xUInt64.
    Raises:
        XRPLBinaryCodecException: If a UInt8 cannot be constructed.
    */
    class func from(value: Int) -> xUInt64 {
        let valueBytes = Data(bytes: value.data.bytes, count: WIDTH64)
        return xUInt64(valueBytes.bytes.reversed())
    }
}


