//
//  BinaryParser.swift
//
//
//  Created by Denis Angell on 7/2/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/binarycodec/binary_wrappers/binary_parser.py

import Foundation

public enum BinaryError: Error {
    case notImplemented
    case unknownError(error: String)
}

/**
 Deserializes from hex-encoded XRPL binary format to JSON fields and values.
 */
public class BinaryParser {
    public var bytes: [UInt8]

    /**
     Initialize bytes to a hex string
     - parameters:
        - hex: A hex string
     */
    public init(hex: String) {
        bytes = hex.hexToBytes
    }

    /**
     Peek the first byte of the BinaryParser
     - returns:
     The first byte of the BinaryParser
     */
    public func peek() throws -> UInt8 {
        guard !bytes.isEmpty else {
            throw BinaryError.unknownError(error: "Invalid Bytes Length")
        }
        return bytes[0]
    }

    /**
     Consume the first n bytes of the BinaryParser
     - parameters:
        - n: The number of bytes to skip
     */
    // swiftlint:disable:next identifier_name
    public func skip(_ n: Int) throws {
        guard n <= bytes.count else {
            throw BinaryError.unknownError(error: "Invalid Bytes Length")
        }
        bytes = [UInt8](bytes[n...])
    }

    /**
     Read the first n bytes from the BinaryParser
     - parameters:
        - n: The number of bytes to read
     - returns:
     The bytes
     */
    // swiftlint:disable:next identifier_name
    public func read(_ n: Int) throws -> [UInt8] {
        let slice = bytes[0..<n]
        try? skip(n)
        return [UInt8](slice)
    }

    /**
     Read an integer of given size
     - parameters:
        - n: The number of bytes to read
     - returns:
     The number represented by those bytes
     */
    // swiftlint:disable:next identifier_name
    public func readUIntN(_ n: Int) throws -> Int {
        guard 0 < n && n <= 4 else {
            throw BinaryError.unknownError(error: "Invalid n")
        }
        return try read(n).reduce(0) { v, byte in
            return v << 8 | Int(byte)
        }
    }

    /**
     Read 1 byte from parser and return as unsigned int.
     - returns:
     The byte read.
     */
    public func readUInt8() throws -> UInt8 {
        return try UInt8(readUIntN(1))
    }

    /**
     Read 2 bytes from parser and return as unsigned int.
     - returns:
     The byte read.
     */
    public func readUInt16() throws -> UInt16 {
        return try UInt16(readUIntN(2))
    }

    /**
     Read 4 bytes from parser and return as unsigned int.
     - returns:
     The byte read.
     */
    public func readUInt32() throws -> UInt32 {
        return try UInt32(readUIntN(4))
    }

    /**
     Return the byte count
     - returns:
     The byte count.
     */
    public func size() -> Int {
        return bytes.count
    }

    /**
     Returns whether the binary parser has finished parsing (e.g. there is nothing
     left in the buffer that needs to be processed).
     - parameters:
        - customEnd: An ending byte-phrase.
     - returns:
     Whether or not it's the end.
     */
    public func end(_ customEnd: Int? = nil) -> Bool {
        // swiftlint:disable:next force_unwrapping
        return bytes.isEmpty || (customEnd != nil && bytes.count <= customEnd!)
    }

    /**
     Reads variable length encoded bytes
     - returns:
     The variable length bytes
     */
    func readVariableLength() throws -> [UInt8] {
        return try read(readLengthPrefix())
    }

    /**
     Reads variable length prefix
     - returns:
     The variable length prefix
     */
    func readLengthPrefix() throws -> Int {
        let byte1 = Int(try self.readUInt8())
        if byte1 <= 192 {
            return byte1
        } else if byte1 <= 240 {
            let byte2 = Int(try self.readUInt8())
            return 193 + (byte1 - 193) * 256 + byte2
        } else if byte1 <= 254 {
            let byte2 = Int(try self.readUInt8())
            let byte3 = Int(try self.readUInt8())
            return 12481 + (byte1 - 241) * 65536 + byte2 * 256 + byte3
        }
        fatalError("Invalid variable length indicator")
    }

    /**
     Reads the field ordinal from the BinaryParser
     - parameters:
        - customEnd: An ending byte-phrase.
     - returns:
     Field ordinal
     */
    func readFieldHeader() throws -> FieldHeader {
        var type: UInt8 = try readUInt8()
        var nth = type & 15
        type >>= 4

        if type == 0 {
            type = try readUInt8()
            if type == 0 || type < 16 {
                throw BinaryError.unknownError(error: "Cannot read FieldOrdinal, type_code out of range")
            }
        }

        if nth == 0 {
            nth = try readUInt8()
            if nth == 0 || nth < 16 {
                throw BinaryError.unknownError(error: "Cannot read FieldOrdinal, field_code out of range")
            }
        }
        return FieldHeader(Int(type), Int(nth))
    }

    /**
     Read the field from the BinaryParser
     - returns:
     The field represented by the bytes at the head of the BinaryParser
     */
    func readField() throws -> FieldInstance {
        let fieldHeader: FieldHeader = try self.readFieldHeader()
        let fieldName: String = try Definitions().getFieldNameFromHeader(fieldHeader)
        return try Definitions().getFieldInstance(fieldName)
    }

    /**
     Read a given type from the BinaryParser
     - parameters:
        - type: The type that you want to read from the BinaryParser
     - returns:
     The instance of that type read from the BinaryParser
     */
    func readType(_ type: Any) throws -> SerializedType {
        if type is AccountID {
            return AccountID().fromParser(self, nil)
        }
        if type is xAmount {
            return try xAmount().fromParser(self, nil)
        }
        if type is Blob {
            return Blob().fromParser(self, nil)
        }
        if type is xCurrency {
            return xCurrency().fromParser(self, nil)
        }
        if type is Hash256 {
            return Hash256().fromParser(self, nil)
        }
        if type is Hash160 {
            return Hash160().fromParser(self, nil)
        }
        if type is Hash128 {
            return Hash128().fromParser(self, nil)
        }
        if type is Hash {
            return Hash().fromParser(self, nil)
        }
        if type is STArray {
            return STArray().fromParser(self, nil)
        }
        if type is STObject.Type {
            return STObject().fromParser(self, nil)
        }
        if type is xUInt64.Type {
            return xUInt64().fromParser(self, nil)
        }
        if type is xUInt32.Type {
            return xUInt32().fromParser(self, nil)
        }
        if type is xUInt16.Type {
            return xUInt16().fromParser(self, nil)
        }
        if type is xUInt8.Type {
            return xUInt8().fromParser(self, nil)
        }
        if type is Vector256.Type {
            return Vector256().fromParser(self, nil)
        }
        fatalError("Invalid Serialized Type")
    }

    /**
     Get the type associated with a given field
     - parameters:
        - type: The field that you want to get the type of
     - returns:
     The type associated with the given field
     */
    func typeForField(_ field: FieldInstance) -> SerializedType.Type? {
        return field.associatedType.self
    }

    /**
     Read value of the type specified by field from the BinaryParser
     - parameters:
        - field: The field tinstance that you are reading
     - returns:
     The value associated with the given field
     */
    func readFieldValue(_ field: FieldInstance) throws -> SerializedType? {
        let associatedValue = AssociatedValue(field: field, parser: self)
        let sizeHint: Int? = field.isVLEncoded ? try self.readLengthPrefix() : nil
        guard let value = try associatedValue.fromParser(hint: sizeHint), !value.bytes.isEmpty else {
            throw BinaryError.unknownError(error: "fromParser for (\(field.name), \(field.type) -> nil ")
        }
        return value
    }

    /**
     Get the next field and value from the BinaryParser
     - returns:
     The field and value
     */
    func readFieldAndValue() throws -> (FieldInstance, SerializedType?) {
        let field = try readField()
        return (field, try readFieldValue(field))
    }
}
