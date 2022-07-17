//
//  xUInt32.swift
//
//
//  Created by Denis Angell on 7/12/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/binarycodec/types/uint32.py

import Foundation

let WIDTH32: Int = 4  // 32 / 8

class xUInt32: xUInt {
    /*
    Class for serializing and deserializing an 8-bit UInt.
    See `UInt Fields <https://xrpl.org/serialization.html#uint-fields>`_
     */
    
    static public var ZERO_32: xUInt32 = xUInt32(bytes: Data(bytes: [], count: WIDTH32).bytes)

    override init(bytes: [UInt8]? = nil) {
        // Construct a new xUInt32 type from a ``bytes`` value.
        super.init(bytes: bytes ?? xUInt32.ZERO_32.bytes)
    }

    func fromParser(
        parser: BinaryParser,
        _lengthHint: Int? = nil
    ) -> xUInt32 {
        /*
        Construct a new xUInt32 type from a BinaryParser.
        Args:
            parser: The parser to construct a xUInt32 from.
        Returns:
            A new xUInt32.
        */
        return try! xUInt32(bytes: parser.read(n: WIDTH))
        
    }

    func from(value: Int) -> xUInt32 {
        /*
        Construct a new xUInt32 type from a number.
        Args:
            value: The value to construct a xUInt32 from.
        Returns:
            A new xUInt32.
        Raises:
            XRPLBinaryCodecException: If a xUInt32 cannot be constructed.
        */
//        if not isinstance(value, Int) {
//            throw BinaryError.unknownError(error: "Invalid type to construct a UInt8: expected int, received \(value.__class__.__name__).")
//
//        }

//        if isinstance(value, int) {
//            let valueBytes = (value).toBytes(_WIDTH, byteorder="big", signed=false)
//            return cls(value_bytes)
//        }
        return xUInt32(bytes: value.data.bytes)
        
//        throw BinaryError.unknownError(error: "Cannot construct UInt8 from given value")
    }
}


