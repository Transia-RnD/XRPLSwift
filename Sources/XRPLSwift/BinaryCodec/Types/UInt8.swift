//
//  xUInt8.swift
//  
//
//  Created by Denis Angell on 7/2/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/binarycodec/types/uint8.py

import Foundation

let WIDTH8: Int = 1  // 8 / 8

class xUInt8: xUInt {
    /*
    Class for serializing and deserializing an 8-bit UInt.
    See `UInt Fields <https://xrpl.org/serialization.html#uint-fields>`_
     */
    
    static public var ZERO_8: xUInt8 = xUInt8(bytes: Data(bytes: [], count: WIDTH8).bytes)

    override init(bytes: [UInt8]? = nil) {
        // Construct a new xUInt8 type from a ``bytes`` value.
        super.init(bytes: bytes ?? xUInt8.ZERO_8.bytes)
    }

    func fromParser(
        parser: BinaryParser,
        _lengthHint: Int? = nil
    ) -> xUInt8 {
        /*
        Construct a new xUInt8 type from a BinaryParser.
        Args:
            parser: The parser to construct a UInt8 from.
        Returns:
            A new xUInt8.
        */
        return try! xUInt8(bytes: parser.read(n: WIDTH))
    }

    func from(value: Int) -> xUInt8 {
        /*
        Construct a new xUInt8 type from a number.
        Args:
            value: The value to construct a UInt8 from.
        Returns:
            A new xUInt8.
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
        return xUInt8(bytes: value.data.bytes)
        
//        throw BinaryError.unknownError(error: "Cannot construct UInt8 from given value")
    }
}


