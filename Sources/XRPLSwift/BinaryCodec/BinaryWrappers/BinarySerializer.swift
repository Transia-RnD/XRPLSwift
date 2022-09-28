//
//  BinarySerializer.swift
//
//
//  Created by Denis Angell on 7/2/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/binarycodec/binary_wrappers/binary_serializer.py

import Foundation

// Constants used in length prefix encoding:
// max length that can be represented in a single byte per XRPL serialization encoding
// swiftlint:disable:next identifier_name
let _MAX_SINGLE_BYTE_LENGTH: Int = 192
// max length that can be represented in 2 bytes per XRPL serialization encoding
// swiftlint:disable:next identifier_name
let _MAX_DOUBLE_BYTE_LENGTH: Int = 12481
// max value that can be used in the second byte of a length field
// swiftlint:disable:next identifier_name
let _MAX_SECOND_BYTE_VALUE: Int = 240
// maximum length that can be encoded in a length prefix per XRPL serialization encoding
// swiftlint:disable:next identifier_name
let _MAX_LENGTH_VALUE: Int = 918744

public class BytesList {
    private var bytesArray: [UInt8] = []
    /**
     Get the total number of bytes in the BytesList
     - returns:
     the number of bytes
     */
    public func getLength() -> Int {
        return self.bytesArray.count
    }
    /**
     Put bytes in the BytesList
     - parameters:
     - bytesArg: A Buffer
     - returns:
     this BytesList
     */
    public func put(bytesArg: [UInt8]) -> BytesList {
        let bytes = bytesArg
        self.bytesArray.append(contentsOf: bytes)
        return self
    }
    /**
     Write this BytesList to the back of another bytes list
     - parameters:
     - list: The BytesList to write to
     */
    public func toBytesSink(list: BytesList) {
        list.put(bytesArg: toBytes())
    }
    /**
     Put bytes in the BytesList
     - returns:
     this BytesList
     */
    public func toBytes() -> [UInt8] {
        return self.bytesArray
    }
    /**
     Put bytes in the BytesList
     - returns:
     this bytes as hex
     */
    func toHex() -> String {
        return toBytes().toHex
    }
}

public class BinarySerializer {
    // Serializes JSON to XRPL binary format.
    public var sink = BytesList()
    init() { self.sink = BytesList() }
    private func UInt8Byte(_ int: Int) -> Data {
        return Data([UInt8(int)])
    }
    private func UInt8Byte(_ int: UInt8) -> Data {
        return int.bigEndian.data
    }
    /**
     Write a value to this BinarySerializer
     - parameters:
     - value: A SerializedType value
     */
    func write(value: SerializedType) {
        value.toBytesSink(list: self.sink)
    }
    /**
     Write bytes to this BinarySerializer
     - parameters:
     - bytes: The bytes to write
     */
    func put(bytes: Data) {
        sink.put(bytesArg: [UInt8](bytes))
    }
    /**
     Write a value of a given type to this BinarySerializer
     - parameters:
     - type: The type to write
     - value: A value of that type
     */
    func writeType(type: SerializedType, value: SerializedType) {
        self.write(value: try! SerializedType.from(value: value))
    }
    /**
     Write BytesList to this BinarySerializer
     - parameters:
     - bl: BytesList to write to BinarySerializer
     */
    func writeBytesList(bl: BytesList) {
        bl.toBytesSink(list: self.sink)
    }
    /**
     Helper function for length-prefixed fields including Blob types
     and some AccountID types. Calculates the prefix of variable length bytes.
     The length of the prefix is 1-3 bytes depending on the length of the contents:
     Content length <= 192 bytes: prefix is 1 byte
     192 bytes < Content length <= 12480 bytes: prefix is 2 bytes
     12480 bytes < Content length <= 918744 bytes: prefix is 3 bytes
     `See Length Prefixing <https://xrpl.org/serialization.html#length-prefixing>`_
     - parameters:
     - length: The length of the encode variable
     - returns:
     The byte arrary encoded length
     */
    func encodeVariableLength(length: Int) -> Data {
        var len = length
        if length <= _MAX_SINGLE_BYTE_LENGTH {
            return Data(from: UInt8(length))
        } else if length < _MAX_DOUBLE_BYTE_LENGTH {
            len -= _MAX_SINGLE_BYTE_LENGTH + 1
            let byte1 = UInt8((len >> 8) + (_MAX_SINGLE_BYTE_LENGTH + 1))
            let byte2 = UInt8(len & 0xff)
            return Data(fromArray: [byte1, byte2])
        } else if length <= _MAX_LENGTH_VALUE {
            len -= _MAX_DOUBLE_BYTE_LENGTH
            let byte1 = UInt8((len >> 16) + (_MAX_SECOND_BYTE_VALUE + 1))
            let byte2 = UInt8((len >> 8) & 0xff)
            let byte3 = UInt8(len & 0xff)
            return Data(fromArray: [byte1, byte2, byte3])
        }
        fatalError("VariableLength field must be <= \(_MAX_LENGTH_VALUE) bytes long")
        //        throw BinaryError.unknownError(error: "VariableLength field must be <= \(_MAX_LENGTH_VALUE) bytes long")
    }
    /**
     Write a variable length encoded value to the BinarySerializer.
     - parameters:
     - value: The SerializedType object to write to bytesink.
     - isUnlModifyWorkaround: Does not encode the value; just encodes `00` in its place.
     */
    func writeLengthEncoded(
        value: SerializedType,
        isUnlModifyWorkaround: Bool = false
    ) {
        let byteObject = BytesList()
        if !isUnlModifyWorkaround {
            _ = value.toBytesSink(list: byteObject)
        }
        self.put(bytes: encodeVariableLength(length: byteObject.getLength()))
        self.writeBytesList(bl: byteObject)
    }
    /**
     Write field and value to the buffer.
     - parameters:
     - field: The field to write to the buffer.
     - value: The value to write to the buffer.'
     - isUNLModifyWorkaround: Encode differently for UNLModify
     pseudotransactions, due to a bug in rippled. Only True for the Account
     field in UNLModify pseudotransactions. The default is False.
     */
    func writeFieldAndValue(
        field: FieldInstance,
        value: SerializedType,
        isUNLModifyWorkaround: Bool = false
    ) {
        self.put(bytes: Data(field.header.toBytes()))
        if field.isVLEncoded {
            writeLengthEncoded(value: value, isUnlModifyWorkaround: isUNLModifyWorkaround)
        } else {
            self.put(bytes: Data(value.bytes))
        }
    }
}
