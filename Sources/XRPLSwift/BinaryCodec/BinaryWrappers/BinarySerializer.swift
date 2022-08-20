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

// func _encodeVariableLengthPrefix(length: Int) -> [UInt8] {
//    /*
//     Helper function for length-prefixed fields including Blob types
//     and some AccountID types. Calculates the prefix of variable length bytes.
//     The length of the prefix is 1-3 bytes depending on the length of the contents:
//     Content length <= 192 bytes: prefix is 1 byte
//     192 bytes < Content length <= 12480 bytes: prefix is 2 bytes
//     12480 bytes < Content length <= 918744 bytes: prefix is 3 bytes
//     `See Length Prefixing <https://xrpl.org/serialization.html#length-prefixing>`_
//     */
//    if length <= _MAX_SINGLE_BYTE_LENGTH {
//        return length.to_bytes(1, byteorder="big", signed=False)
//    }
//    if length < _MAX_DOUBLE_BYTE_LENGTH {
//        length -= _MAX_SINGLE_BYTE_LENGTH + 1
//        let byte1 = ((length >> 8) + (_MAX_SINGLE_BYTE_LENGTH + 1)).toBytes(
//            1, byteorder="big", signed=False
//        )
//        let byte2 = (length & 0xFF).to_bytes(1, byteorder="big", signed=False)
//        return byte1 + byte2
//    }
//    if length <= _MAX_LENGTH_VALUE {
//        length -= _MAX_DOUBLE_BYTE_LENGTH
//        let byte1 = ((_MAX_SECOND_BYTE_VALUE + 1) + (length >> 16)).toBytes(
//            1, byteorder="big", signed=False
//        )
//        let byte2 = ((length >> 8) & 0xFF).to_bytes(1, byteorder="big", signed=False)
//        let byte3 = (length & 0xFF).toBytes(1, byteorder="big", signed=False)
//        return byte1 + byte2 + byte3
//    }
//
//    throw BinaryError.unknownError(error: "VariableLength field must be <= \(_MAX_LENGTH_VALUE) bytes long")
//
// }

public class BytesList {
    private var bytesArray: [UInt8] = []

    /**
     * Get the total number of bytes in the BytesList
     *
     * @return the number of bytes
     */
    public func getLength() -> Int {
        return self.bytesArray.count
    }

    /**
     * Put bytes in the BytesList
     *
     * @param bytesArg A Buffer
     * @return this BytesList
     */
    public func put(bytesArg: [UInt8]) -> BytesList {
        let bytes = bytesArg
        self.bytesArray.append(contentsOf: bytes)
        return self
    }

    /**
     * Write this BytesList to the back of another bytes list
     *
     *  @param list The BytesList to write to
     */
    public func toBytesSink(list: BytesList) {
        list.put(bytesArg: toBytes())
    }

    public func toBytes() -> [UInt8] {
        return self.bytesArray
    }

    func toHex() -> String {
        return toBytes().toHexString()
    }
}

public class BinarySerializer {
    // Serializes JSON to XRPL binary format.

    public var sink: BytesList = BytesList()

    init() { self.sink = BytesList() }

    private func UInt8Byte(_ int: Int) -> Data {
        return Data([UInt8(int)])
    }

    private func UInt8Byte(_ int: UInt8) -> Data {
        return int.bigEndian.data
    }

    /**
     * Write a value to this BinarySerializer
     *
     * @param value a SerializedType value
     */
    func write(value: SerializedType) {
        value.toBytesSink(list: self.sink)
    }

    /**
     * Write bytes to this BinarySerializer
     *
     * @param bytes the bytes to write
     */
    func put(bytes: Data) {
        sink.put(bytesArg: [UInt8](bytes))
    }

    /**
     * Write a value of a given type to this BinarySerializer
     *
     * @param type the type to write
     * @param value a value of that type
     */
    func writeType(type: SerializedType, value: SerializedType) {
        self.write(value: try! SerializedType.from(value: value))
    }

    /**
     * Write BytesList to this BinarySerializer
     *
     * @param bl BytesList to write to BinarySerializer
     */
    func writeBytesList(bl: BytesList) {
//        print("SINK: \(self.sink.toHex())")
        bl.toBytesSink(list: self.sink)
    }

    func encodeVariableLength(length: Int) -> Data {
        var lenBytes: Data = Data([UInt8].init(repeating: 0x0, count: 3))
        var len = length
        if length <= 192 {
            lenBytes[0] = UInt8(length)
            return lenBytes[0..<1]
        } else if length <= 12480 {
            len -= 193
            lenBytes[0] = UInt8(193 + (len >> 8))
            lenBytes[1] = UInt8(len & 0xff)
            return lenBytes[0...2]
        } else if length <= 918744 {
            len -= 12481
            lenBytes[0] = UInt8(241 + (len >> 16))
            lenBytes[1] = UInt8((len >> 8) & 0xff)
            lenBytes[2] = UInt8(len & 0xff)
            return lenBytes[0...3]
        }
        fatalError("VariableLength field must be <= 918744 bytes long")
    }

    /*
     Write a variable length encoded value to the BinarySerializer.
     Args:
     value: The SerializedType object to write to bytesink.
     encode_value: Does not encode the value; just encodes `00` in its place.
     Used in the UNLModify encoding workaround. The default is True.
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

    /*
     Write field and value to the buffer.
     Args:
     field: The field to write to the buffer.
     value: The value to write to the buffer.
     is_unl_modify_workaround: Encode differently for UNLModify
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
