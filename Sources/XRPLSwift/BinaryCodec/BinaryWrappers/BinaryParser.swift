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

public class BinaryParser {

    public var bytes: [UInt8]

    /**
     * Initialize bytes to a hex string
     *
     * @param hex a hex string
     */
    public init(hex: String) {
        bytes = try! hex.asHexArray()
    }

    /**
     * Peek the first byte of the BinaryParser
     *
     * @returns The first byte of the BinaryParser
     */
    public func peek() throws -> UInt8 {
        guard !bytes.isEmpty else {
            throw BinaryError.unknownError(error: "Invalid Bytes Length")
        }
        return bytes[0]
    }

    /**
     * Consume the first n bytes of the BinaryParser
     *
     * @param n the number of bytes to skip
     */
    // swiftlint:disable:next identifier_name
    public func skip(n: Int) throws {
        guard n <= bytes.count else {
            throw BinaryError.unknownError(error: "Invalid Bytes Length")
        }
        bytes = [UInt8](bytes[n...])
    }

    /**
     * read the first n bytes from the BinaryParser
     *
     * @param n The number of bytes to read
     * @return The bytes
     */
    // swiftlint:disable:next identifier_name
    public func read(n: Int) throws -> [UInt8] {
        guard n <= bytes.count else {
            throw BinaryError.unknownError(error: "Invalid Bytes Length")
        }
        let slice = bytes[0..<n]
        try! skip(n: n)
        return [UInt8](slice)
    }

    /**
     * Read an integer of given size
     *
     * @param n The number of bytes to read
     * @return The number represented by those bytes
     */
    // swiftlint:disable:next identifier_name
    public func readUIntN(n: Int) throws -> Int {
        guard 0 < n && n <= 4 else {
            throw BinaryError.unknownError(error: "Invalid n")
        }
        // swiftlint:disable:next identifier_name
        return try read(n: n).reduce(0) { v, byte in
            return v << 8 | Int(byte)
        }
    }

    public func readUInt8() -> UInt8 {
        return try! UInt8(readUIntN(n: 1))
    }

    public func readUInt16() -> UInt16 {
        return try! UInt16(readUIntN(n: 2))
    }

    public func readUInt32() -> UInt32 {
        return try! UInt32(readUIntN(n: 4))
    }

    public func size() -> Int {
        return bytes.count
    }

    // TODO: GUARD
    public func end(customEnd: Int? = nil) -> Bool {
        return bytes.isEmpty || (customEnd != nil && bytes.count <= customEnd!)
    }

    /**
     * Reads variable length encoded bytes
     *
     * @return The variable length bytes
     */
    func readVariableLength() -> [UInt8] {
        return try! read(n: readLengthPrefix())
    }

    /**
     * Reads the length of the variable length encoded bytes
     *
     * @return The length of the variable length encoded bytes
     */
    func readLengthPrefix() throws -> Int {
        let b1: Int = Int(self.readUInt8())
        if b1 <= 192 {
            return b1
        } else if b1 <= 240 {
            let b2: Int = Int(self.readUInt8())
            return 193 + (b1 - 193) * 256 + b2
        } else if b1 <= 254 {
            let b2: Int = Int(self.readUInt8())
            let b3: Int = Int(self.readUInt8())
            return 12481 + (b1 - 241) * 65536 + b2 * 256 + b3
        }
        fatalError("Invalid variable length indicator")
    }

    /**
     * Reads the field ordinal from the BinaryParser
     *
     * @return Field ordinal
     */
    func readFieldHeader() throws -> FieldHeader {
        var type: UInt8 = readUInt8()
        var nth = type & 15
        type >>= 4

        if type == 0 {
            type = readUInt8()
            if type == 0 || type < 16 {
                throw BinaryError.unknownError(error: "Cannot read FieldOrdinal, type_code out of range")
            }
        }

        if nth == 0 {
            nth = readUInt8()
            if nth == 0 || nth < 16 {
                throw BinaryError.unknownError(error: "Cannot read FieldOrdinal, field_code out of range")
            }
        }
        return FieldHeader(typeCode: Int(type), fieldCode: Int(nth))
    }

    /**
     * Read the field from the BinaryParser
     *
     * @return The field represented by the bytes at the head of the BinaryParser
     */
    func readField() -> FieldInstance {
        let fieldHeader: FieldHeader = try! self.readFieldHeader()
        let fieldName: String = Definitions().getFieldNameFromHeader(fieldHeader: fieldHeader)
        return Definitions().getFieldInstance(fieldName: fieldName)
    }

    /**
     * Read a given type from the BinaryParser
     *
     * @param type The type that you want to read from the BinaryParser
     * @return The instance of that type read from the BinaryParser
     */
    func readType(type: Any) throws -> SerializedType {
        if type is AccountID {
            return AccountID().fromParser(parser: self, hint: nil)
        }
        if type is xAmount {
            return try xAmount().fromParser(parser: self, hint: nil)
        }
        if type is Blob {
            return Blob().fromParser(parser: self, hint: nil)
        }
        if type is xCurrency {
            return xCurrency().fromParser(parser: self, hint: nil)
        }
        if type is Hash256 {
            return Hash256().fromParser(parser: self, hint: nil)
        }
        if type is Hash160 {
            return Hash160().fromParser(parser: self, hint: nil)
        }
        if type is Hash128 {
            return Hash128().fromParser(parser: self, hint: nil)
        }
        if type is Hash {
            return Hash().fromParser(parser: self, hint: nil)
        }
        if type is STArray {
            return STArray().fromParser(parser: self, hint: nil)
        }
        if type is STObject.Type {
            return STObject().fromParser(parser: self, hint: nil)
        }
        if type is xUInt64.Type {
            return xUInt64().fromParser(parser: self, hint: nil)
        }
        if type is xUInt32.Type {
            return xUInt32().fromParser(parser: self, hint: nil)
        }
        if type is xUInt16.Type {
            return xUInt16().fromParser(parser: self, hint: nil)
        }
        if type is xUInt8.Type {
            return xUInt8().fromParser(parser: self, hint: nil)
        }
        if type is Vector256.Type {
            return Vector256().fromParser(parser: self, hint: nil)
        }
        fatalError("Invalid Serialized Type")
    }

    /**
     * Get the type associated with a given field
     *
     * @param field The field that you want to get the type of
     * @return The type associated with the given field
     */
    func typeForField(field: FieldInstance) -> SerializedType.Type {
        return field.associatedType.self
    }

    /**
     * Read value of the type specified by field from the BinaryParser
     *
     * @param field The field that you want to get the associated value for
     * @return The value associated with the given field
     */
    func readFieldValue(field: FieldInstance) throws -> SerializedType? {
//        print("READING FIELD...")
//        print("FIELD NAME: \(field.name)")
        let associatedValue = AssociatedValue(field: field, parser: self)
        let sizeHint: Int? = field.isVLEncoded
        ? try self.readLengthPrefix()
        : nil
        let value = associatedValue.fromParser(hint: sizeHint)!
        if value.bytes.isEmpty {
            throw BinaryError.unknownError(error: "fromParser for (\(field.name), \(field.type) -> nil ")
        }
//        print("FIELD NAME: \(value.toJson())")
        return value
    }

    /**
     * Get the next field and value from the BinaryParser
     *
     * @return The field and value
     */
    func readFieldAndValue() -> (FieldInstance, SerializedType) {
        let field = readField()
        return (field, try! readFieldValue(field: field)!)
    }
}
