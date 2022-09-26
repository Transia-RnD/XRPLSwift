//
//  Blob.swift
//  
//
//  Created by Denis Angell on 7/3/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/binarycodec/types/blob.py

import Foundation

/**
 Codec for serializing and deserializing blob fields.
 See `Blob Fields <https://xrpl.org/serialization.html#blob-fields>`_
 */
class Blob: SerializedType {

    // Construct a new Blob type from a ``bytes`` value.
    init(_ bytes: [UInt8]? = nil) {
        super.init(bytes: bytes ?? [])
    }

    /**
     Construct a new Blob type from a BinaryParser.
     - parameters:
        - parser: The parser to construct a Blob from.
     - returns:
     A new Blob.
     */
    override func fromParser(
        parser: BinaryParser,
        hint: Int? = nil
    ) -> Blob {
        return Blob(try! parser.read(n: hint!))
    }

    /**
     Construct a new Blob type from a number.
     - parameters:
        - value: The value to construct a Blob from.
     - returns:
     A new Blob.
     - throws: RPLBinaryCodecException: If a Blob cannot be constructed.
     */
    static func from(value: String) throws -> Blob {
        return Blob(value.hexToBytes)
    }
}
