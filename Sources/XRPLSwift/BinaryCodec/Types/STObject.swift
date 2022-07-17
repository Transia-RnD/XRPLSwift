//
//  STObject.swift
//  
//
//  Created by Denis Angell on 7/16/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/binarycodec/types/st_object.py

import Foundation

internal let OBJECT_END_MARKER_BYTE: [UInt8] = [0xE1]
internal let OBJECT_END_MARKER: String = "ObjectEndMarker"
internal let ST_OBJECT: String = "STObject"
internal let DESTINATION: String = "Destination"
internal let ACCOUNT: String = "Account"
internal let SOURCE_TAG: String = "SourceTag"
internal let DEST_TAG: String = "DestinationTag"

let UNL_MODIFY_TX: String = "0066"

func handleXAddress(field: String, xaddress: String) throws -> [String: AnyObject] {
    let result: [String: AnyObject] = try AddressCodec.xAddressToClassicAddress(xAddress: xaddress)
    let classicAddress = result["classicAddress"] as? String
    let tag = result["tag"] as? Int
    var tagName: String = ""
    if field == DESTINATION {
        tagName = DEST_TAG
    } else if field == ACCOUNT {
        tagName = SOURCE_TAG
    } else if tag != nil {
        throw BinaryError.unknownError(error: "\(field) cannot have an associated tag")
    }

    if tag != nil {
        return [ "field": classicAddress!, "tag": tag! ] as [String: AnyObject]
    }
    return [ "field": classicAddress ] as [String: AnyObject]
}


func strToEnum(field: String, value: Any) -> Any {
    // all of these fields have enum values that are used for serialization
    // converts the string name to the corresponding enum code
    if field == "TransactionType" {
        return Definitions().getTransactionTypeCode(transactionType: value as! String)
    }
    if field == "TransactionResult" {
        return Definitions().getTransactionResultCode(transactionResultType: value as! String)
    }
    if field == "LedgerEntryType" {
        return Definitions().getLedgerEntryTypeCode(ledgerEntryType: value as! String)
    }
    return value
}

func enumToStr(field: String, value: Any) -> Any {
    // reverse of the above function
    if field == "TransactionType" {
        return Definitions().getTransactionTypeName(transactionType: value as! Int)
    }
    if field == "TransactionResult" {
        return Definitions().getTransactionResultName(transactionResultType: value as! Int)
    }
    if field == "LedgerEntryType" {
        return Definitions().getLedgerEntryTypeName(ledgerEntryType: value as! Int)
    }
    return value
}

class STObject: SerializedType {

    init(_ bytes: [UInt8]? = nil) {
        super.init(bytes: bytes ?? [])
    }

//    public func fromParser() {
//        let serializer: BinarySerializer = BinarySerializer()
//
//        while not parser.isEnd():
//            let field = parser.readField()
//            if field.name == OBJECT_END_MARKER:
//                break
//
//            let associatedValue: Int = parser.readFieldValue(field)
//            serializer.writeFieldAndValue(field, associated_value)
//            if field.type == ST_OBJECT:
//                serializer.append(OBJECT_END_MARKER_BYTE)
//
//        return STObject(bytes(serializer))
//    }
    
    public func from(value: [String: Any], onlySigning: Bool = false) throws -> STObject {
        let serializer: BinarySerializer = BinarySerializer()

        var xaddressDecoded: [String: AnyObject] = [:]
        for (k, v) in value {
            if v is String && AddressCodec.isValidXAddress(xAddress: v as! String) {
                let handled = try handleXAddress(field: k, xaddress: v as! String)
                if (
                    handled.contains(where: { $0.key == SOURCE_TAG })
                    && handled[SOURCE_TAG] != nil
                    && value.contains(where: { $0.key == SOURCE_TAG })
                    && value[SOURCE_TAG] != nil
                    && handled[SOURCE_TAG] as? String != value[SOURCE_TAG] as? String
                ) {
                    throw BinaryError.unknownError(error: "Cannot have mismatched Account X-Address and SourceTag")
                }
                if (
                    handled.contains(where: { $0.key == DEST_TAG })
                    && handled[DEST_TAG] != nil
                    && value.contains(where: { $0.key == DEST_TAG })
                    && value[DEST_TAG] != nil
                    && handled[DEST_TAG] as? String != value[DEST_TAG] as? String
                ) {
                    throw BinaryError.unknownError(error: "Cannot have mismatched Destination X-Address and DestinationTag")
                }
                xaddressDecoded.merge(handled)  { (_, new) in new }
            } else {
                xaddressDecoded[k] = strToEnum(field: k, value: v) as AnyObject
            }
        }

        var sortedKeys: [FieldInstance] = []
        for fieldName in xaddressDecoded {
            let fieldInstance = Definitions().getFieldInstance(fieldName: fieldName.key)
            if (
//                fieldInstance != nil
                xaddressDecoded[fieldInstance.name] != nil
                && fieldInstance.isSerialized
            ) {
                sortedKeys.append(fieldInstance)
            }
        }
//        sortedKeys.sort(key=lambda x: x.ordinal)

//        if onlySigning {
//            sortedKeys = list(filter(lambda x: x.is_signing, sorted_keys))
//        }

        var isUnlModify: Bool = false

        for field in sortedKeys {
            var associatedValue: SerializedType? = nil
            do {
                if let av = field.associatedType.self as? AccountID.Type {
                    print("SOEMTHING")
                }
                if let av = field.associatedType.self as? STObject.Type {
                    print("SOEMTHING")
                    associatedValue = av.from(value: xaddressDecoded[field.name]! as! SerializedType)
                }
                print("NOPE")
//                associatedValue = try field.associatedType.from(value: xaddressDecoded[field.name]! as! SerializedType)
            } catch {
                // mildly hacky way to get more context in the error
                // provides the field name and not just the type it's expecting
                // keeps the original stack trace
//                e.args = (f"Error processing {field.name}: {e.args[0]}",) + e.args[1:]
                throw BinaryError.unknownError(error: "Error processing \(field.name): TODO")
            }
            if (
                field.name == "TransactionType"
                && associatedValue?.str() == UNL_MODIFY_TX
            ) {
                // triggered when the TransactionType field has a value of 'UNLModify'
                isUnlModify = true
            }
            let isUnlModifyWorkaround = field.name == "Account" && isUnlModify
            // true when in the UNLModify pseudotransaction (after the transaction type
            // has been processed) and working with the Account field
            // The Account field must not be a part of the UNLModify pseudotransaction
            // encoding, due to a bug in rippled

            serializer.writeFieldAndValue(
                field: field,
                value: associatedValue!,
                isUNLModifyWorkaround: isUnlModifyWorkaround
            )
            if field.type == ST_OBJECT {
                _ = serializer.sink.put(bytesArg: OBJECT_END_MARKER_BYTE)
            }
        }
        return STObject(serializer.sink.toBytes())
    }
    
//    public func toJson() {
//        let parser: BinaryParser = BinaryParser(str(self))
//        let accumulator: [Sting: AnyObject] = [:]
//
//        while not parser.isEnd():
//            field = parser.readField()
//            if field.name == OBJECT_END_MARKER:
//                break
//            let json_value = parser.readFieldValue(field).toJson()
//            accumulator[field.name] = enumToStr(field.name, jsonValue)
//
//        return accumulator
//    }
}
