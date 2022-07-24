//
//  Blob.swift
//  
//
//  Created by Denis Angell on 7/3/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/binarycodec/types/blob.py

import Foundation

class Blob: SerializedType {
    /*
     Codec for serializing and deserializing blob fields.
     See `Blob Fields <https://xrpl.org/serialization.html#blob-fields>`_
     */
    
    init(_ bytes: [UInt8]? = nil) {
        // Construct a new Blob type from a ``bytes`` value.
        super.init(bytes: bytes ?? [])
    }
    
    /*
     Construct a new Blob type from a BinaryParser.
     Args:
     parser: The parser to construct a Blob from.
     Returns:
     A new Blob.
     */
    override func fromParser(
        parser: BinaryParser,
        hint: Int? = nil
    ) -> Blob {
        return Blob(try! parser.read(n: hint!))
    }
    
    /*
     Construct a new Blob type from a number.
     Args:
     value: The value to construct a Blob from.
     Returns:
     A new Blob.
     Raises:
     XRPLBinaryCodecException: If a Blob cannot be constructed.
     */
    static func from(value: String) throws -> Blob {
//        if (type(of: value) != type(of: String.self)) {
//            throw BinaryError.unknownError(error: "Invalid type to construct a Blob: expected String, received \(value.self.description).")
//        }
        
//        if (type(of: value) == type(of: String.self)) {
//            return Blob(try! value.asHexArray())
//        }
//        throw BinaryError.unknownError(error: "Cannot construct Blob from value given")
        
        return Blob(try! value.asHexArray())
    }
}
