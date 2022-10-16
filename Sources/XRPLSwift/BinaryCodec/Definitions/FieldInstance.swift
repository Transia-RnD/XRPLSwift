//
//  FieldInstance.swift
//
//
//  Created by Denis Angell on 7/2/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/binarycodec/definitions/field_instance.py

import Foundation

let binaryTypes: [String: SerializedType.Type] = [
    "AccountID": AccountID.self,
    "Amount": xAmount.self,
    "Blob": Blob.self,
    "Currency": xCurrency.self,
    "Hash": Hash.self,
    "Hash128": Hash128.self,
    "Hash160": Hash160.self,
    "Hash256": Hash256.self,
    "PathSet": xPathSet.self,
    "SerializedType": SerializedType.self,
    "STArray": STArray.self,
    "STObject": STObject.self,
    "UInt": xUInt.self,
    "UInt8": xUInt8.self,
    "UInt16": xUInt16.self,
    "UInt32": xUInt32.self,
    "UInt64": xUInt64.self,
    "Vector256": Vector256.self
]

/**
 Convert the string name of a class to the class object itself.
 - parameters:
 - name: The name of the class.
 - returns:
 The corresponding class object.
 */
func getTypeByName(_ name: String) -> SerializedType.Type? {
    var typeMap: [String: SerializedType.Type] = [:]
    for (name, objectType) in binaryTypes { typeMap[name] = objectType.self }
    return typeMap[name]
}

/**
 A collection of serialization information about a specific field type.
 */
class FieldInstance {
    var nth: Int
    var isVLEncoded: Bool
    var isSerialized: Bool
    var isSigning: Bool
    var type: String
    var name: String
    var header: FieldHeader
    var ordinal: Int
    var associatedType: SerializedType.Type?

    /**
     Construct a FieldInstance.
     - parameters:
     - fieldInfo: The field's serialization info from definitions.json.
     - fieldName: The field's string name.
     - fieldHeader: A FieldHeader object with the typeCode and fieldCode.
     */
    init(
        _ fieldInfo: FieldInfo,
        _ fieldName: String,
        _ fieldHeader: FieldHeader
    ) {
        self.nth = fieldInfo.nth
        self.isVLEncoded = fieldInfo.isVLEncoded
        self.isSerialized = fieldInfo.isSerialized
        self.isSigning = fieldInfo.isSigningField
        self.type = fieldInfo.type
        self.name = fieldName
        self.header = fieldHeader
        self.ordinal = header.typeCode << 16 | nth
        self.associatedType = getTypeByName(self.type)
    }
}
