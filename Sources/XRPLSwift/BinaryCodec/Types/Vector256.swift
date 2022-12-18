//
//  Vector256.swift
//
//
//  Created by Denis Angell on 7/16/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/binarycodec/types/vector256.py

import Foundation

// swiftlint:disable:next identifier_name
internal let HASH_LENGTH_BYTES: Int = 32

class Vector256: SerializedType {
    public static var ZERO256 = Vector256(Data(bytes: [], count: HASH_LENGTH_BYTES).bytes)

    override init(_ bytes: [UInt8]? = nil) {
        super.init(bytes ?? Vector256.ZERO256.bytes)
    }

    static func from(_ value: [String]) throws -> Vector256 {
        var byteList: [UInt8] = []
        // swiftlint:disable:next identifier_name
        for s in value {
            byteList.append(contentsOf: try Hash256.from(s).bytes)
        }
        return Vector256(byteList)
    }

    /**
     Read a Vector256 object from a BinaryParser
     - parameters:
        - parser: BinaryParser to read the hash from
        - hint: Length of the bytes to read, optional
     */
    override func fromParser(
        _ parser: BinaryParser,
        _ hint: Int? = nil
    ) -> SerializedType {
        var byteList: [UInt8] = []
        let numBytes = hint != nil ? hint : parser.bytes.count
        let numHashes = Int(numBytes! / HASH_LENGTH_BYTES)
        for i in 0..<numHashes {
            byteList.append(contentsOf: try Hash256().fromParser(parser).bytes)
        }
        return Vector256(byteList)
    }

    /**
     Return a list of hashes encoded as hex strings.
     - returns:
     The JSON representation of this Vector256.
     - throws:
     XRPLBinaryCodecException: If the number of bytes in the buffer
     is not a multiple of the hash length.
     */
    override func toJson() -> [String] {
        if self.bytes.count % HASH_LENGTH_BYTES != 0 {
            fatalError("Invalid bytes for Vector256.")
            //            throw BinaryError.unknownError(error: "Invalid bytes for Vector256.")
        }

        var hashList: [String] = []
        for i in stride(from: 0, to: self.bytes.count, by: HASH_LENGTH_BYTES) {
            hashList.append([UInt8](self.bytes[i...i + HASH_LENGTH_BYTES - 1]).toHex)
        }
        return hashList
    }
}
