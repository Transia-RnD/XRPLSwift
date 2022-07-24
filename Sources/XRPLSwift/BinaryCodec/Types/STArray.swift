//
//  STArray.swift
//  
//
//  Created by Denis Angell on 7/16/22.
//


// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/binarycodec/types/st_array.py

import Foundation

internal let ARRAY_END_MARKER: [UInt8] = [0xF1]
internal let ARRAY_END_MARKER_NAME: String = "ArrayEndMarker"
internal let _OBJECT_END_MARKER: [UInt8] = [0xE1]

class STArray: SerializedType {
    
    /*
    Class for serializing and deserializing Lists of objects.
    See `Array Fields <https://xrpl.org/serialization.html#array-fields>`_
    */

    init(_ bytes: [UInt8]? = nil) {
        super.init(bytes: bytes ?? [])
    }

    override func fromParser(parser: BinaryParser, hint: Int? = nil) -> STArray {
        var bytestring: [UInt8] = []

        while !parser.end() {
            let field = parser.readField()
            if field.name == ARRAY_END_MARKER_NAME {
                break
            }
            bytestring += field.header.toBytes()
            bytestring += try! parser.readFieldValue(field: field)!.bytes
            bytestring += _OBJECT_END_MARKER
        }

        bytestring += ARRAY_END_MARKER
        return STArray(bytestring)
    }
    
    static func from(value: [[String: AnyObject]]) throws -> STArray {
//        if value.count > 0 && value[0] is [String: AnyObject] {
//            throw BinaryError.unknownError(error: "Cannot construct STArray from a list of non-dict")
//        }

        var bytestring: [UInt8] = []
        for obj in value {
            let transaction = try STObject.from(value: obj)
            bytestring += transaction.bytes
        }
        bytestring += ARRAY_END_MARKER
        return STArray(bytestring)
    }
    
    func toJson() -> [[String: AnyObject]] {
        var result: [[String: AnyObject]] = []
        let parser: BinaryParser = BinaryParser(hex: self.str())

        while !parser.end() {
            let field = parser.readField()
                if field.name == ARRAY_END_MARKER_NAME {
                break
            }

            var outer: [String: AnyObject] = [:]
            let _result: [String: AnyObject] = STObject().fromParser(parser: parser).toJson()
            outer[field.name] = _result as AnyObject
            result.append(outer)
        }
        return result
    }
}
