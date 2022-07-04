//
//  Blob.swift
//  
//
//  Created by Denis Angell on 7/3/22.
//

import Foundation

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/binarycodec/types/serialized_type.py

class Blob: SerializedType {
    /*
     Codec for serializing and deserializing blob fields.
     See `Blob Fields <https://xrpl.org/serialization.html#blob-fields>`_
     */
//    init() {}
    
    init(_ bytes: [UInt8]) {
        // Construct a new Blob type from a ``bytes`` value.
        super.init(bytes: bytes)
    }
    
    override func fromParser(
        parser: BinaryParser,
        hint: Int? = nil
    ) -> Blob {
        /*
         Construct a new Blob type from a BinaryParser.
         Args:
         parser: The parser to construct a Blob from.
         Returns:
         A new Blob.
         */
        return Blob(try! parser.read(n: hint!))
        
    }
    
    static func from(value: String) throws -> Blob {
        /*
         Construct a new Blob type from a number.
         Args:
         value: The value to construct a Blob from.
         Returns:
         A new Blob.
         Raises:
         XRPLBinaryCodecException: If a Blob cannot be constructed.
         */
//        if (type(of: value) != type(of: Blob.self)) {
//            throw BinaryError.unknownError(error: "Invalid type to construct a Blob: expected String, received \(value.self.description).")
//        }
        
        if (type(of: value) != type(of: String.self)) {
            return Blob(try! value.asHexArray())
        }
        throw BinaryError.unknownError(error: "Cannot construct Blob from value given")
    }
}
