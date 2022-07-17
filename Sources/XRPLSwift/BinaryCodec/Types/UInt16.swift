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
    
    static public var ZERO_16: xUInt16 = xUInt16(bytes: Data(bytes: [], count: WIDTH16).bytes)

    override init(bytes: [UInt8]? = nil) {
        // Construct a new xUInt16 type from a ``bytes`` value.
        super.init(bytes: bytes ?? xUInt16.ZERO_16.bytes)
    }

    func fromParser(
        parser: BinaryParser,
        _lengthHint: Int? = nil
    ) -> xUInt16 {
        /*
        Construct a new xUInt16 type from a BinaryParser.
        Args:
            parser: The parser to construct a UInt8 from.
        Returns:
            A new xUInt16.
        */
        return try! xUInt16(bytes: parser.read(n: WIDTH))
        
    }

    func from(value: Int) -> xUInt16 {
        /*
        Construct a new xUInt16 type from a number.
        Args:
            value: The value to construct a xUInt16 from.
        Returns:
            A new xUInt16.
        Raises:
            XRPLBinaryCodecException: If a xUInt16 cannot be constructed.
        */
//        if not isinstance(value, Int) {
//            throw BinaryError.unknownError(error: "Invalid type to construct a UInt8: expected int, received \(value.__class__.__name__).")
//
//        }

//        if isinstance(value, int) {
//            let valueBytes = (value).toBytes(_WIDTH, byteorder="big", signed=false)
//            return cls(value_bytes)
//        }
        return xUInt16(bytes: value.data.bytes)
        
//        throw BinaryError.unknownError(error: "Cannot construct UInt8 from given value")
    }
}


