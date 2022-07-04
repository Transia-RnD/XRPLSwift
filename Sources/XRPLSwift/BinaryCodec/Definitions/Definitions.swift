//
//  Definitions.swift
//  
//
//  Created by Denis Angell on 7/2/22.
//

import Foundation

public struct LoadDefinitions {
    
    public var TYPES: [String: Int]
    public var LEDGER_ENTRY_TYPES: [String: Int]
    public var FIELDS: [String: AnyObject]
    public var TRANSACTION_RESULTS: [String: Int]
    public var TRANSACTION_TYPES: [String: Int]
    
    public var TRANSACTION_TYPES_REVERSE: [Int: String]
    public var TRANSACTION_RESULTS_REVERSE: [Int: String]
    public var LEDGER_ENTRY_TYPES_REVERSE: [Int: String]
    
    public var TYPE_ORDINAL_MAP: [String: Int] = [:]
    public var FIELD_INFO_MAP: [String: FieldInfo] = [:]
    public var FIELD_HEADER_NAME_MAP: [FieldHeader: String] = [:]
    
    init(dict: [String:AnyObject]) {
        self.TYPES = dict["TYPES"] as! [String:Int]
        self.TYPE_ORDINAL_MAP = self.TYPES
        self.LEDGER_ENTRY_TYPES = dict["LEDGER_ENTRY_TYPES"] as! [String:Int]
        self.TRANSACTION_RESULTS = dict["TRANSACTION_RESULTS"] as! [String:Int]
        self.TRANSACTION_TYPES = dict["TRANSACTION_TYPES"] as! [String:Int]
    
        let fields = dict["FIELDS"] as! [[AnyObject]]
        var fieldsDict: [String: AnyObject] = [:]
        _ = fields.map { (array) in
            let field = array[0] as! String
            fieldsDict[field] = array[1] as! NSDictionary
        }
        self.FIELDS = fieldsDict
        
        var reverseTT: [Int: String] = [:]
        TRANSACTION_TYPES.forEach({ (key: String, value: Int) in
            reverseTT[value] = key
        })
        self.TRANSACTION_TYPES_REVERSE = reverseTT
        
        var reverseTR: [Int: String] = [:]
        TRANSACTION_RESULTS.forEach({ (key: String, value: Int) in
            reverseTR[value] = key
        })
        self.TRANSACTION_RESULTS_REVERSE = reverseTR
        
        var reverseLE: [Int: String] = [:]
        LEDGER_ENTRY_TYPES.forEach({ (key: String, value: Int) in
            reverseLE[value] = key
        })
        self.LEDGER_ENTRY_TYPES_REVERSE = reverseLE
        
        for field in self.FIELDS {
            let fieldInfo = FieldInfo(dict: field.value as! NSDictionary)
            let header: FieldHeader = FieldHeader(
                typeCode: self.TYPE_ORDINAL_MAP[fieldInfo.type]!,
                fieldCode: fieldInfo.nth
            )
            self.FIELD_INFO_MAP[field.key] = fieldInfo
            self.FIELD_HEADER_NAME_MAP[header] = field.key
        }
    }
}

public struct Definitions {
    
    // instance variables
    public var definitions: LoadDefinitions!
    
    init() {
        do {
            let data: Data = serializerDefinitions.data(using: .utf8)!
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? [String:AnyObject] {
                self.definitions = LoadDefinitions(dict: jsonResult)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func all() -> [String] {
        return [
            "TYPES",
            "FIELDS",
            "TRANSACTION_RESULTS",
            "TRANSACTION_TYPES",
        ]
    }
    
    func getFieldTypeName(fieldName: String) -> String {
        /*
        Returns the serialization data type for the given field name.
        `Serialization Type List <https://xrpl.org/serialization.html#type-list>`_

        Args:
            field_name: The name of the field to get the serialization data type for.

        Returns:
            The serialization data type for the given field name.
        */
        return definitions.FIELD_INFO_MAP[fieldName]!.type
    }
    
    func getFieldTypeCode(fieldName: String) throws -> Int {
        /*
        Returns the type code associated with the given field.
        `Serialization Type Codes <https://xrpl.org/serialization.html#type-codes>`_

        Args:
            field_name: The name of the field get a type code for.

        Returns:
            The type code associated with the given field name.

        Raises:
            XRPLBinaryCodecException: If definitions.json is invalid.
        */
        let fieldTypeName: String = self.getFieldTypeName(fieldName: fieldName)
        let fieldTypeCode: Int = definitions.TYPE_ORDINAL_MAP[fieldTypeName]!
//        if (type(of: fieldTypeCode) != type(of: Int.self)) {
//            throw BinaryError.unknownError(error: "Field type codes in definitions.json must be ints.")
//        }
        return fieldTypeCode
    }
    
    func getFieldCode(fieldName: String) -> Int {
        /*
        Returns the field code associated with the given field.
        `Serialization Field Codes <https://xrpl.org/serialization.html#field-codes>`_

        Args:
            field_name: The name of the field to get a field code for.

        Returns:
            The field code associated with the given field.
        */
        return definitions.FIELD_INFO_MAP[fieldName]!.nth
    }
    
    func getFieldHeaderFromName(fieldName: String) -> FieldHeader {
        /*
        Returns a FieldHeader object for a field of the given field name.

        Args:
            field_name: The name of the field to get a FieldHeader for.

        Returns:
            A FieldHeader object for a field of the given field name.
        */
        return FieldHeader(
            typeCode: try! self.getFieldTypeCode(fieldName: fieldName),
            fieldCode: try! self.getFieldCode(fieldName: fieldName)
        )
    }
    
    func getFieldNameFromHeader(fieldHeader: FieldHeader) -> String {
        /*
        Returns the field name described by the given FieldHeader object.

        Args:
            field_header: The header to get a field name for.

        Returns:
            The name of the field described by the given FieldHeader.
        */
        return definitions.FIELD_HEADER_NAME_MAP[fieldHeader]!
    }
}
