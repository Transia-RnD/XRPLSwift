//
//  xUInt64.swift
//
//
//  Created by Denis Angell on 7/12/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/binarycodec/types/uint64.py

import Foundation

internal let WIDTH: Int = 8  // 64 / 8

class xUInt64: xUInt {
    /*
    Class for serializing and deserializing an 8-bit UInt.
    See `UInt Fields <https://xrpl.org/serialization.html#uint-fields>`_
     */
    
    static public var ZERO_64: xUInt64 = xUInt64(bytes: Data(bytes: [], count: WIDTH).bytes)

    override init(bytes: [UInt8]? = nil) {
        // Construct a new xUInt64 type from a ``bytes`` value.
        super.init(bytes: bytes ?? xUInt64.ZERO_64.bytes)
    }

    func fromParser(
        parser: BinaryParser,
        _lengthHint: Int? = nil
    ) -> xUInt64 {
        /*
        Construct a new xUInt64 type from a BinaryParser.
        Args:
            parser: The parser to construct a xUInt32 from.
        Returns:
            A new xUInt64.
        */
        return try! xUInt64(bytes: parser.read(n: WIDTH))
        
    }

    func from(value: Int) -> xUInt64 {
        /*
        Construct a new xUInt64 type from a number.
        Args:
            value: The value to construct a xUInt64 from.
        Returns:
            A new xUInt64.
        Raises:
            XRPLBinaryCodecException: If a UInt8 cannot be constructed.
        */
//        if not isinstance(value, Int) {
//            throw BinaryError.unknownError(error: "Invalid type to construct a UInt8: expected int, received \(value.__class__.__name__).")
//
//        }

//        if isinstance(value, int) {
//            let valueBytes = (value).toBytes(_WIDTH, byteorder="big", signed=false)
//            return cls(value_bytes)
//        }
        return xUInt64(bytes: value.data.bytes)
        
//        throw BinaryError.unknownError(error: "Cannot construct UInt8 from given value")
    }
}


