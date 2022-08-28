//
//  SerializedType.swift
//  
//
//  Created by Denis Angell on 7/2/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/binarycodec/types/serialized_type.py

import Foundation

class SerializedType {
    // The base class for all binary codec field types.

    public var bytes: [UInt8] = []

    init(bytes: [UInt8]) {
        // Construct a new SerializedType.
        self.bytes = bytes
    }

    func fromParser(
        parser: BinaryParser,
        // hint is Any so that subclasses can choose whether or not to require it.
        hint: Int?
    ) throws -> SerializedType {
        throw BinaryError.notImplemented
        return try! self.fromParser(parser: parser, hint: hint)
    }

    func from(value: SerializedType) throws -> SerializedType {
        throw BinaryError.notImplemented
        return try! self.from(value: value)
    }

    //    static func from(value: SerializedType | JSON | bigInt.BigInteger) -> SerializedType {
    class func from(value: SerializedType) throws -> SerializedType {
        throw BinaryError.notImplemented
        return try! self.from(value: value)
    }

    //    func from(value: Data) -> Data {
    //        return value
    //    }
    //
    //    func from(value: String) -> Data {
    //        print("fromValue")
    //        return Data(hex: value)
    //    }

    func toBytesSink(list: BytesList) -> BytesList {
        /*
         Write the bytes representation of a SerializedType to a bytearray.
         Args:
         bytesink: The bytearray to write self.buffer to.
         Returns: None
         */
        return list.put(bytesArg: bytes)
    }

    func toBytes() -> [UInt8] {
        /*
         Get the bytes representation of a SerializedType.
         Returns:
         The bytes representation of the SerializedType.
         */
        return bytes
    }
    
    func toJson() -> [[[String: AnyObject]]] {
        /*
         Returns the JSON representation of a SerializedType.
         If not overridden, returns hex string representation of bytes.
         Returns:
         The JSON representation of the SerializedType.
         */
        return []
    }
    
    func toJson() -> [[String: AnyObject]] {
        /*
         Returns the JSON representation of a SerializedType.
         If not overridden, returns hex string representation of bytes.
         Returns:
         The JSON representation of the SerializedType.
         */
        return []
    }

    func toJson() -> [String: AnyObject] {
        /*
         Returns the JSON representation of a SerializedType.
         If not overridden, returns hex string representation of bytes.
         Returns:
         The JSON representation of the SerializedType.
         */
        return [:]
    }

    func toJson() -> Any {
        /*
         Returns the JSON representation of a SerializedType.
         If not overridden, returns hex string representation of bytes.
         Returns:
         The JSON representation of the SerializedType.
         */
        return toHex()
    }

    func toJson() -> String {
        /*
         Returns the JSON representation of a SerializedType.
         If not overridden, returns hex string representation of bytes.
         Returns:
         The JSON representation of the SerializedType.
         */
        return toHex()
    }

    func str() -> String {
        /*
         Returns the hex string representation of self.buffer.
         Returns:
         The hex string representation of self.buffer.
         */
        return toHex()
    }

    func toHex() -> String {
        /*
         Get the hex representation of a SerializedType's bytes.
         Returns:
         The hex string representation of the SerializedType's bytes.
         */
        return bytes.toHexString().uppercased()
    }

    func len() -> Int {
        // Get the length of a SerializedType's bytes.
        return bytes.count
    }

}
