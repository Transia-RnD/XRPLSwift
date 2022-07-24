//
//  xUInt16.swift
//
//
//  Created by Denis Angell on 7/2/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/binarycodec/types/uint16.py

import Foundation

let WIDTH16: Int = 2  // 16 / 8

class xUInt16: xUInt {
    /*
    Class for serializing and deserializing an 8-bit UInt.
    See `UInt Fields <https://xrpl.org/serialization.html#uint-fields>`_
     */
    
    static public var ZERO_16: xUInt16 = xUInt16([UInt8].init(repeating: 0x0, count: WIDTH16))

    override init(_ bytes: [UInt8]? = nil) {
        // Construct a new xUInt16 type from a ``bytes`` value.
        super.init(bytes ?? xUInt16.ZERO_16.bytes)
    }

    /*
    Construct a new xUInt16 type from a BinaryParser.
    Args:
        parser: The parser to construct a UInt8 from.
    Returns:
        A new xUInt16.
    */
    override func fromParser(
        parser: BinaryParser,
        hint: Int? = nil
    ) -> xUInt16 {
        return try! xUInt16(parser.read(n: WIDTH16))
    }

    /*
    Construct a new xUInt16 type from a number.
    Args:
        value: The value to construct a xUInt16 from.
    Returns:
        A new xUInt16.
    Raises:
        XRPLBinaryCodecException: If a xUInt16 cannot be constructed.
    */
    class func from(value: Int) -> xUInt16 {
        let valueBytes = Data(bytes: value.data.bytes, count: WIDTH16)
        return xUInt16(valueBytes.bytes.reversed())
    }
}


