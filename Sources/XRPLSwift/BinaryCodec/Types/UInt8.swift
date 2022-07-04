//
//  UInt8.swift
//  
//
//  Created by Denis Angell on 7/2/22.
//

import Foundation

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/binarycodec/types/uint8.py

let _WIDTH: Int = 1  // 8 / 8


class xUInt8 {
    /*
    Class for serializing and deserializing an 8-bit UInt.
    See `UInt Fields <https://xrpl.org/serialization.html#uint-fields>`_
     */
    init() {}

//    init(bytes: UInt8(_WIDTH)) {
//        // Construct a new UInt8 type from a ``bytes`` value.
//        super().init(buffer)
//    }

    func from_parser(
        parser: BinaryParser,
        _lengthHint: Int? = nil
    ) -> UInt8 {
        /*
        Construct a new UInt8 type from a BinaryParser.
        Args:
            parser: The parser to construct a UInt8 from.
        Returns:
            A new UInt8.
        */
//        return UInt8(parser.read(n: _WIDTH))
        return 1
        
    }

    func fromValue(value: Int) -> UInt8 {
        print("")
        return 1
        /*
        Construct a new UInt8 type from a number.
        Args:
            value: The value to construct a UInt8 from.
        Returns:
            A new UInt8.
        Raises:
            XRPLBinaryCodecException: If a UInt8 cannot be constructed.
        */
//        if not isinstance(value, Int) {
//            throw BinaryError.unknownError(error: "Invalid type to construct a UInt8: expected int, received \(value.__class__.__name__).")
//
//        }
//
//        if isinstance(value, int) {
//            let valueBytes = (value).toBytes(_WIDTH, byteorder="big", signed=false)
//            return cls(value_bytes)
//        }
        
//        throw BinaryError.unknownError(error: "Cannot construct UInt8 from given value")
    }
}
