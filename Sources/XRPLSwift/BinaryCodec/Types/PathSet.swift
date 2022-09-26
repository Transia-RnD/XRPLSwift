//
//  PathSet.swift
//
//
//  Created by Denis Angell on 7/16/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/binarycodec/types/path_set.py

import Foundation

// Constant for masking types of a PathStep

// swiftlint:disable:next identifier_name
let TYPE_ACCOUNT: Int  = 0x01
// swiftlint:disable:next identifier_name
let TYPE_CURRENCY: Int = 0x10
// swiftlint:disable:next identifier_name
let TYPE_ISSUER: Int = 0x20

// Constants for separating Paths in a PathSet
// swiftlint:disable:next identifier_name
let PATHSET_END_BYTE: Int = 0x00
// swiftlint:disable:next identifier_name
let PATH_SEPARATOR_BYTE: Int = 0xFF

internal func isPathStep(value: [String: AnyObject]) -> Bool {
    // Helper function to determine if a dictionary represents a valid path step.
    return value["issuer"] != nil || value["account"] != nil || value["currency"] != nil
}

internal func isPathSet(value: [[[String: AnyObject]]]) -> Bool {
    // Helper function to determine if a list represents a valid path set.
    return value.count == 0 || value[0].count == 0 || isPathStep(value: value[0][0])
}

// swiftlint:disable:next type_name
class xPathStep: SerializedType {

    static func from(value: [String: AnyObject]) throws -> xPathStep {
        var dataType: Int = 0x00
        var buffer: [UInt8] = []
        if let v = value["account"] as? String {
            let accountId = try AccountID.from(value: v)
            buffer += accountId.bytes
            dataType |= TYPE_ACCOUNT
        }
        if let v = value["currency"] as? String {
            let currency = try xCurrency.from(value: v)
            buffer += currency.bytes
            dataType |= TYPE_CURRENCY
        }
        if let v = value["issuer"] as? String {
            let issuer = try AccountID.from(value: v)
            buffer += issuer.bytes
            dataType |= TYPE_ISSUER
        }
        return xPathStep(bytes: Data(hex: String(dataType, radix: 16).uppercased()).bytes + buffer)
    }
    class func fromParser(
        parser: BinaryParser,
        hint: Int? = nil
    ) -> SerializedType {
        let dataType = Int(parser.readUInt8())
        var buffer: [UInt8] = []
        if (dataType & TYPE_ACCOUNT) != 0 {
            buffer += try! parser.read(n: AccountID.getLength())
        }
        if (dataType & TYPE_CURRENCY) != 0 {
            buffer += try! parser.read(n: xCurrency.getLength())
        }
        if (dataType & TYPE_ISSUER) != 0 {
            buffer += try! parser.read(n: AccountID.getLength())
        }
        return xPathStep(bytes: Data(hex: String(dataType, radix: 16).uppercased()).bytes + buffer)
    }

    override func toJson() -> [String: AnyObject] {
        /* Return a list of hashes encoded as hex strings.
         Returns:
         The JSON representation of this Vector256.
         Raises:
         XRPLBinaryCodecException: If the number of bytes in the buffer
         is not a multiple of the hash length.
         */
        let parser = BinaryParser(hex: self.toHex())
        let dataType = Int(parser.readUInt8())
        var json: [String: AnyObject] = [:]

        if (dataType & TYPE_ACCOUNT) != 0 {
            let accountId: String = AccountID().fromParser(parser: parser).toJson()
            json["account"] = accountId as AnyObject
        }
        if (dataType & TYPE_CURRENCY) != 0 {
            let currency: String = xCurrency().fromParser(parser: parser).toJson()
            json["currency"] = currency as AnyObject
        }
        if (dataType & TYPE_ISSUER) != 0 {
            let issuer: String = AccountID().fromParser(parser: parser).toJson()
            json["issuer"] = issuer as AnyObject
        }
        return json
    }

    func type() -> Int {
        /*
         Get a number representing the type of this PathStep.
         Returns:
         a number to be bitwise and-ed with TYPE_ constants to describe the types in
         the PathStep.
         */
        return Int(self.bytes[0])
    }
}

// swiftlint:disable:next type_name
class xPath: SerializedType {
    // Class for serializing/deserializing Paths.

    static func from(value: [[String: AnyObject]]) throws -> xPath {
        var buffer: [UInt8] = []
        for dict in value {
            let pathstep = try xPathStep.from(value: dict)
            buffer += pathstep.bytes
        }
        return xPath(bytes: buffer)
    }

    class func fromParser(
        parser: BinaryParser,
        hint: Int? = nil
    ) -> SerializedType {
        var buffer: [UInt8] = []
        while !parser.end() {
            let pathstep = xPathStep.fromParser(parser: parser)
            buffer += pathstep.bytes
            if try! parser.peek() == PATHSET_END_BYTE || parser.peek() == PATH_SEPARATOR_BYTE {
                break
            }
        }
        return xPath(bytes: buffer)
    }

    override func toJson() -> [[String: AnyObject]] {
        var json: [[String: AnyObject]] = []
        let pathParser = BinaryParser(hex: self.toHex())
        while !pathParser.end() {
            let pathstep = xPathStep.fromParser(parser: pathParser)
            json.append(pathstep.toJson())
        }
        return json
    }
}

// swiftlint:disable:next type_name
class xPathSet: SerializedType {

    static func from(value: [[[String: AnyObject]]]) throws -> xPathSet {
        if isPathSet(value: value) {
            var buffer: [UInt8] = []
            for pathDict in value {
                let path = try! xPath.from(value: pathDict)
                buffer.append(contentsOf: path.bytes)
                buffer.append(contentsOf: [UInt8(PATH_SEPARATOR_BYTE)])
            }
            buffer[buffer.count - 1] = UInt8(PATHSET_END_BYTE)
            return xPathSet(bytes: buffer)
        }
        throw BinaryError.unknownError(error: "Cannot construct PathSet from given value")
    }
    class func fromParser(
        parser: BinaryParser,
        hint: Int? = nil
    ) throws -> SerializedType {
        var buffer: [UInt8] = []
        while !parser.end() {
            let path = xPath.fromParser(parser: parser)
            buffer.append(contentsOf: path.bytes)
            buffer.append(contentsOf: try parser.read(n: 1))
            if buffer[buffer.count - 1] == UInt8(PATHSET_END_BYTE) {
                break
            }
        }
        // TODO: Review this function
        return xPathSet(bytes: buffer)

    }

    override func toJson() -> [[[String: AnyObject]]] {
        var json: [[[String: AnyObject]]] = []
        let pathsetParser = BinaryParser(hex: self.toHex())
        while !pathsetParser.end() {
            let path = xPath.fromParser(parser: pathsetParser)
            let pathJson: [[String: AnyObject]] = path.toJson()
            json.append(pathJson)
            try! pathsetParser.skip(n: 1)
        }
        return json
    }
}
