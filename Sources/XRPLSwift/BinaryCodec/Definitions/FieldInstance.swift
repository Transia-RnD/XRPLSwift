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

func getTypeByName(name: String) -> SerializedType.Type? {
    /*
    Convert the string name of a class to the class object itself.
    Args:
        name: the name of the class.
    Returns:
        The corresponding class object.
    */
    var typeMap: [String: SerializedType.Type] = [:]
    for (name, objectType) in binaryTypes { typeMap[name] = objectType.self }
    return typeMap[name]
}

class FieldInstance {
    // A collection of serialization information about a specific field type.
    public var nth: Int
    public var isVLEncoded: Bool
    public var isSerialized: Bool
    public var isSigning: Bool
    public var type: String
    public var name: String
    public var header: FieldHeader
    public var ordinal: Int
    public var associatedType: SerializedType.Type

    init(
        fieldInfo: FieldInfo,
        fieldName: String,
        fieldHeader: FieldHeader
    ) {
        /*
        Construct a FieldInstance.
        :param field_info: The field's serialization info from definitions.json.
        :param field_name: The field's string name.
        :param field_header: A FieldHeader object with the type_code and field_code.
        */
        print("CONSTRUCT FIELD INSTANCE")
        print(fieldInfo.type)
        self.nth = fieldInfo.nth
        self.isVLEncoded = fieldInfo.isVLEncoded
        self.isSerialized = fieldInfo.isSerialized
        self.isSigning = fieldInfo.isSigningField
        self.type = fieldInfo.type
        self.name = fieldName
        self.header = fieldHeader
        self.ordinal = header.typeCode << 16 | nth
        self.associatedType = getTypeByName(name: self.type)!
    }
}
