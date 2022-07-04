//
//  File.swift
//  
//
//  Created by Denis Angell on 7/2/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/binarycodec/definitions/field_instance.py

import Foundation

func getTypeByName(name: String) -> SerializedType? {
    /*
    Convert the string name of a class to the class object itself.
    Args:
        name: the name of the class.
    Returns:
        The corresponding class object.
    */

//    let typeMap: [String: SerializedType] = [:]
//
//    for (name, objectType) in types.dict {
//        if name in types.all {
//            typeMap["name"] = objectType
//        }
//    }
//
//    return typeMap[name]
    return nil
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
    public var associatedType: SerializedType

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
        self.nth = fieldInfo.nth
        self.isVLEncoded = fieldInfo.isVLEncoded
        self.isSerialized = fieldInfo.isSerialized
        self.isSigning = fieldInfo.isSigningField
        self.type = fieldInfo.type
        self.name = fieldName
        self.header = fieldHeader
        self.ordinal = header.typeCode << 16 | nth
        self.associatedType = getTypeByName(name: type)!
    }
}
