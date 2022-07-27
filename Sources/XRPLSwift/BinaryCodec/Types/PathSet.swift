////
////  PathSet.swift
////
////
////  Created by Denis Angell on 7/16/22.
////
//
//// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/binarycodec/types/path_set.py
//
//import Foundation
//
//
//// Constant for masking types of a PathStep
//let TYPE_ACCOUNT: Int  = 0x01
//let TYPE_CURRENCY: Int = 0x10
//let TYPE_ISSUER: Int = 0x20
//
//// Constants for separating Paths in a PathSet
//let PATHSET_END_BYTE: Int = 0x00
//let PATH_SEPARATOR_BYTE: Int = 0xFF
//
//internal func isPathStep(value: [String: String]) -> Bool {
//    // Helper function to determine if a dictionary represents a valid path step.
//    guard value["issuer"] as String || value["currency"] as String else {
//        return false
//    }
//    return true
//
//}
//
//internal func isPathSet(value: [[[String: String]]]) -> Bool {
//    // Helper function to determine if a list represents a valid path set.
//    return value.count == 0 || value[0].count == 0 || isPathStep(value[0][0])
//}
//
//class PathStep: SerializedType {
//    static func from(value: [String: String]) throws -> Amount {
//        let dataType: Int = 0x00
//        let buffer = [UInt8] = []
//        if let v = value["account"] as String {
//            account_id = AccountID.from_value(v)
//            buffer += bytes(account_id)
//            dataType |= TYPE_ACCOUNT
//        }
//        if let v = value["currency"] as String {
//            currency = Currency.from_value(vv)
//            buffer += bytes(currency)
//            dataType |= TYPE_CURRENCY
//        }
//        if let v = value["account"] as String {
//            issuer = AccountID.from_value(value["issuer"])
//            buffer += bytes(issuer)
//            dataType |= TYPE_ISSUER
//        }
//
//        return PathStep(bytes([dataType]) + buffer)
//    }
//
//    override func fromParser(
//        parser: BinaryParser,
//        hint: Int? = nil
//    ) -> SerializedType {
//        let dataType: Int = parser.read_uint8()
//        buffer = [UInt8] = []
//
//        if dataType & TYPE_ACCOUNT {
//            let accountId: AccountID = parser.read(AccountID.LENGTH)
//            buffer += accountId
//        }
//        if dataType & TYPE_CURRENCY {
//            let currency: Currency = parser.read(Currency.LENGTH)
//            buffer += currency
//        }
//        if dataType & TYPE_ISSUER {
//            let issuer: AccountID = parser.read(AccountID.LENGTH)
//            buffer += issuer
//        }
//        return PathStep(bytes([dataType]) + buffer)
//    }
//
//    func toJson() throws -> [String] {
//        /* Return a list of hashes encoded as hex strings.
//        Returns:
//            The JSON representation of this Vector256.
//        Raises:
//            XRPLBinaryCodecException: If the number of bytes in the buffer
//                                        is not a multiple of the hash length.
//        */
//        let parser: BinaryParser = BinaryParser(String(self))
//        let dataType: Int = parser.read_uint8()
//        let json: [String: AnyObject] = [:]
//
//        if dataType & TYPE_ACCOUNT:
//            let accountId: AccountID = AccountID.from_parser(parser).to_json()
//            json["account"] = accountId
//        if dataType & TYPE_CURRENCY:
//                let currency: Currency = Currency.from_parser(parser).to_json()
//            json["currency"] = currency
//        if dataType & TYPE_ISSUER:
//            let issuer: AccountID = AccountID.from_parser(parser).to_json()
//            json["issuer"] = issuer
//
//        return json
//    }
//
//    func type() -> Int {
//        /*
//         Get a number representing the type of this PathStep.
//        Returns:
//            a number to be bitwise and-ed with TYPE_ constants to describe the types in
//            the PathStep.
//        */
//        return self.buffer[0]
//    }
//}
//
//class Path: SerializedType {
//    // Class for serializing/deserializing Paths.
//
//    func from(value: [[[String: String]]]) throws -> Amount {
//        let buffer: [UInt8] = []
//        for dict in value {
//            let pathstep = PathStep.from(value: dict)
//            buffer += bytes(pathstep)
//        }
//        return Path(buffer)
//    }
//
//    override func fromParser(
//        parser: BinaryParser,
//        hint: Int? = nil
//    ) -> SerializedType {
//        let buffer: [UInt8] = []
//        while not parser.isEnd():
//            let pathstep = PathStep.fromParser(parser)
//            buffer.append(bytes(pathstep))
//            if parser.peek() == cast(bytes, PATHSET_END_BYTE) || parser.peek() == cast(bytes, PATH_SEPARATOR_BYTE) {
//                break
//            }
//        return Path(b"".join(buffer))
//    }
//
//    func toJson() throws -> [String] {
//        let json: [String] = []
//        let pathParser: BinaryParser = BinaryParser(String(self))
//
//        while not pathParser.is_end() {
//            let pathstep: PathStep = PathStep.fromParser(pathParser)
//            json.append(pathstep.toJson())
//        }
//
//        return json
//    }
//
//}
//
//class PathSet: SerializedType {
//    func from(value: [[[String: String]]]) throws -> Amount {
//        if isPathSet(value: value) {
//            let buffer: [UInt8] = []
//            for pathDict in value {
//                let path: Path = Path.from(value: pathDict)
//                buffer.append(bytes(path))
//                buffer.append(bytes([PATH_SEPARATOR_BYTE]))
//            }
//
//            buffer[-1] = bytes([PATHSET_END_BYTE])
//            return PathSet(b"".join(buffer))
//        }
//        throw BinaryError.unknownError(error: "Cannot construct PathSet from given value")
//    }
//
//    override func fromParser(
//        parser: BinaryParser,
//        hint: Int? = nil
//    ) -> SerializedType {
//        let buffer: [UInt8] = []
//        while not parser.isEnd():
//            let path: Path = Path.fromParser(parser)
//            buffer.append(bytes(path))
//            buffer.append(parser.read(1))
//            if buffer[-1][0] == PATHSET_END_BYTE:
//                break
//        return PathSet(b"".join(buffer))
//    }
//
//    func toJson() throws -> [String] {
//        let json: [String] = []
//        let pathsetParser: BinaryParser = BinaryParser(String(self))
//
//        while not pathsetParser.isEnd():
//            let path: Path = Path.fromParser(pathsetParser)
//            json.append(path.toJson())
//            pathsetParser.skip(1)
//        return json
//    }
//}
