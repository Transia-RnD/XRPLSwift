//
//  xUInt32.swift
//
//
//  Created by Denis Angell on 7/12/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/binarycodec/types/uint32.py

import Foundation

let WIDTH32: Int = 4  // 32 / 8

// swiftlint:disable:next type_name
class xUInt32: xUInt {
    /*
    Class for serializing and deserializing an 8-bit UInt.
    See `UInt Fields <https://xrpl.org/serialization.html#uint-fields>`_
     */

    static public var ZERO32: xUInt32 = xUInt32([UInt8].init(repeating: 0x0, count: WIDTH32))

    override init(_ bytes: [UInt8]? = nil) {
        // Construct a new xUInt32 type from a ``bytes`` value.
        super.init(bytes ?? xUInt32.ZERO32.bytes)
    }

    /*
    Construct a new xUInt32 type from a BinaryParser.
    Args:
        parser: The parser to construct a xUInt32 from.
    Returns:
        A new xUInt32.
    */
    override func fromParser(
        parser: BinaryParser,
        hint: Int? = nil
    ) -> xUInt32 {
        return try! xUInt32(parser.read(n: WIDTH32))
    }

    /*
    Construct a new xUInt32 type from a number.
    Args:
        value: The value to construct a xUInt32 from.
    Returns:
        A new xUInt32.
    Raises:
        XRPLBinaryCodecException: If a xUInt32 cannot be constructed.
    */
    class func from(value: Int) -> xUInt32 {
        let valueBytes = Data(bytes: value.data.bytes, count: WIDTH32)
        return xUInt32(valueBytes.bytes.reversed())
    }
}
