//
//  xUInt8.swift
//
//
//  Created by Denis Angell on 7/2/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/binarycodec/types/uint8.py

import Foundation

let WIDTH8: Int = 1  // 8 / 8

// swiftlint:disable:next type_name
class xUInt8: xUInt {
    /*
     Class for serializing and deserializing an 8-bit UInt.
     See `UInt Fields <https://xrpl.org/serialization.html#uint-fields>`_
     */

    public static var ZERO8 = xUInt8([UInt8].init(repeating: 0x0, count: WIDTH8))

    override init(_ bytes: [UInt8]? = nil) {
        // Construct a new xUInt8 type from a ``bytes`` value.
        super.init(bytes ?? xUInt8.ZERO8.bytes)
    }

    /*
     Construct a new xUInt8 type from a BinaryParser.
     Args:
     parser: The parser to construct a UInt8 from.
     Returns:
     A new xUInt8.
     */
    override func fromParser(
        parser: BinaryParser,
        hint: Int? = nil
    ) -> xUInt8 {
        return try! xUInt8(parser.read(n: WIDTH8))
    }

    /*
     Construct a new xUInt8 type from a number.
     Args:
     value: The value to construct a UInt8 from.
     Returns:
     A new xUInt8.
     Raises:
     XRPLBinaryCodecException: If a UInt8 cannot be constructed.
     */
    class func from(value: Int) -> xUInt8 {
        let valueBytes = Data(bytes: value.data.bytes, count: WIDTH8)
        return xUInt8(valueBytes.bytes.reversed())
    }
}
