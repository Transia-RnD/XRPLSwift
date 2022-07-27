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

//enum AV {
//    case AccountID
//    case Amount
//
//    func all() {
//        return [
//            AV.AccountID.Type,
//            AV.Amount.Type,
//        ]
//    }
//}

struct AssociatedValue {
    //    case AccountID(AccountID)
    //    case b(Double)
    
    public var field: FieldInstance!
    public var xaddressDecoded: [String: AnyObject]!
    public var parser: BinaryParser!
    
    init(
        field: FieldInstance,
        xaddressDecoded: [String: AnyObject]
    ) {
        self.field = field
        self.xaddressDecoded = xaddressDecoded
    }
    
    init(
        field: FieldInstance,
        parser: BinaryParser
    ) {
        self.field = field
        self.parser = parser
    }
    
    //    func get(type: AV) -> SerializedType? {
    //        switch AV {
    //        case .AccountID:
    //            return
    //        default:
    //            return
    //        }
    //    }
    
    //    let Types: [String: SerializedType.Type] = [
    //        "AccountID": AccountID.self,
    //        "Amount": Amount.self,
    //        "Blob": Blob.self,
    //        "Currency": Currency.self,
    //        "Hash": Hash.self,
    //        "Hash128": Hash128.self,
    //        "Hash160": Hash160.self,
    //        "Hash256": Hash256.self,
    //    //    "PathSet": PathSet.self,
    //        "SerializedType": SerializedType.self,
    //        "STArray": STArray.self,
    //        "STObject": STObject.self,
    //        "UInt": xUInt.self,
    //        "UInt8": xUInt8.self,
    //        "UInt16": xUInt16.self,
    //        "UInt32": xUInt32.self,
    //        "UInt64": xUInt64.self,
    //        "Vector256": Vector256.self,
    //    ]
    
    func from() throws -> SerializedType? {
        if field.associatedType.self is AccountID.Type {
            print("AccountID")
            return try AccountID.from(value: xaddressDecoded[field.name]! as! String)
        }
        if field.associatedType.self is Amount.Type {
            print("Amount")
            if let value = xaddressDecoded[field.name] as? String {
                return try! Amount.from(value: value)
            }
            if let value = xaddressDecoded[field.name] as? [String: String] {
                return try Amount.from(value: value)
            }
            throw BinaryError.unknownError(error: "Invalid SerializedType Amount")
        }
        if field.associatedType.self is Blob.Type {
            print("Blob")
            return try! Blob.from(value: xaddressDecoded[field.name]! as! String)
        }
        if field.associatedType.self is Currency.Type {
            print("Currency")
            return try! Currency.from(value: xaddressDecoded[field.name]! as! String)
        }
        if field.associatedType.self is Hash256.Type {
            print("Hash256")
            return try! Hash256.from(value: xaddressDecoded[field.name]! as! String)
        }
        if field.associatedType.self is Hash160.Type {
            print("Hash160")
            return try! Hash160.from(value: xaddressDecoded[field.name]! as! String)
        }
        if field.associatedType.self is Hash128.Type {
            print("Hash128")
            return try! Hash128.from(value: xaddressDecoded[field.name]! as! String)
        }
        if field.associatedType.self is Hash.Type {
            print("Hash")
            return try! Hash.from(value: xaddressDecoded[field.name]! as! String)
        }
        //        if let av = field.associatedType.self as? PathSet.Type {
        //            print("PathSet")
        //            return try! av.from(value: xaddressDecoded[field.name]! as! PathSet)
        //        }
        if field.associatedType.self is STArray.Type {
            print("STArray")
            return try! STArray.from(value: xaddressDecoded[field.name]! as! [[String: AnyObject]])
        }
        if field.associatedType.self is STObject.Type {
            print("STObject")
            return try! STObject.from(value: xaddressDecoded[field.name]! as! [String: AnyObject])
        }
        if field.associatedType.self is xUInt64.Type  {
            print("xUInt64")
            if let value = xaddressDecoded[field.name] as? String {
                return try! xUInt64.from(value: value)
            }
            if let value = xaddressDecoded[field.name] as? Int {
                return try! xUInt64.from(value: value)
            }
            throw BinaryError.unknownError(error: "Invalid SerializedType Amount")
        }
        if field.associatedType.self is xUInt32.Type {
            print("xUInt32")
            return xUInt32.from(value: xaddressDecoded[field.name]! as! Int)
        }
        if field.associatedType.self is xUInt16.Type {
            print("xUInt16")
            return xUInt16.from(value: xaddressDecoded[field.name]! as! Int)
        }
        if field.associatedType.self is xUInt8.Type {
            print("xUInt8")
            return xUInt8.from(value: xaddressDecoded[field.name]! as! Int)
        }
        if field.associatedType.self is Vector256.Type {
            print("Vector256")
            return try Vector256.from(value: xaddressDecoded[field.name]! as! [String])
        }
        return nil
    }
    
    func fromParser(hint: Int? = nil) -> SerializedType? {
        if field.associatedType.self is AccountID.Type {
            print("AccountID")
            return AccountID().fromParser(parser: self.parser)
        }
        if field.associatedType.self is Amount.Type {
            print("Amount")
            return try! Amount().fromParser(parser: self.parser)
        }
        if field.associatedType.self is Blob.Type {
            print("Blob")
            return try! Blob().fromParser(parser: self.parser, hint: hint)
        }
        if field.associatedType.self is Currency.Type {
            print("Currency")
            return try! Currency().fromParser(parser: self.parser)
        }
        if field.associatedType.self is Hash.Type {
            print("Hash")
            return try! Hash().fromParser(parser: self.parser)
        }
        if field.associatedType.self is Hash128.Type {
            print("Hash128")
            return try! Hash128().fromParser(parser: self.parser)
        }
        if field.associatedType.self is Hash160.Type {
            print("Hash160")
            return try! Hash160().fromParser(parser: self.parser)
        }
        if field.associatedType.self is Hash256.Type {
            print("Hash256")
            return try! Hash256().fromParser(parser: self.parser)
        }
        //        if let av = field.associatedType.self as? PathSet.Type {
        //            print("PathSet")
        //            return try! av.from(value: xaddressDecoded[field.name]! as! PathSet)
        //        }
        if field.associatedType.self is STArray.Type {
            print("STArray")
            return try! STArray().fromParser(parser: self.self.parser, hint: hint)
        }
        if field.associatedType.self is STObject.Type {
            print("STObject")
            return try! STObject().fromParser(parser: parser, hint: hint)
        }
        if field.associatedType.self is xUInt64.Type {
            print("xUInt64")
            return xUInt64().fromParser(parser: self.parser)
        }
        if field.associatedType.self is xUInt32.Type {
            print("xUInt32")
            return xUInt32().fromParser(parser: self.parser)
        }
        if field.associatedType.self is xUInt16.Type {
            print("xUInt16")
            return xUInt16().fromParser(parser: self.parser)
        }
        if field.associatedType.self is xUInt8.Type {
            print("xUInt8")
            return xUInt8().fromParser(parser: self.parser)
        }
        //        if let av = field.associatedType.self as? xUInt.Type {
        //            print("xUInt")
        //            return try! xUInt.from(value: xaddressDecoded[field.name]! as! Int)
        //        }
        if let av = field.associatedType.self as? Vector256.Type {
            print("Vector256")
            return try! Vector256().fromParser(parser: self.parser)
        }
        return nil
    }
}


func handleXAddress(field: String, xaddress: String) throws -> [String: AnyObject] {
    let result: [String: AnyObject] = try AddressCodec.xAddressToClassicAddress(xAddress: xaddress)
    let classicAddress = result["classicAddress"] as? String
    let tag = result["tag"] as? Int
    var tagName: String = ""
    print(field)
    print(tagName)
    if field == DESTINATION {
        tagName = DEST_TAG
    } else if field == ACCOUNT {
        tagName = SOURCE_TAG
    } else if tag != nil {
        throw BinaryError.unknownError(error: "\(field) cannot have an associated tag")
    }
    
    if tag != nil {
        return [ "\(field)": classicAddress!, "\(tagName)": tag! ] as [String: AnyObject]
    }
    return [ "\(field)": classicAddress ] as [String: AnyObject]
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
    if let _value: xUInt16 = value as? xUInt16,  field == "TransactionType" {
        return Definitions().getTransactionTypeName(transactionType: Int(_value.toHex())!)
    }
    if let _value: xUInt16 = value as? xUInt16, field == "TransactionResult" {
        return Definitions().getTransactionResultName(transactionResultType: Int(_value.toHex())!)
    }
    if let _value: xUInt16 = value as? xUInt16, field == "LedgerEntryType" {
        return Definitions().getLedgerEntryTypeName(ledgerEntryType: Int(_value.toHex())!)
    }
    return value
}

class STObject: SerializedType {
    
    init(_ bytes: [UInt8]? = nil) {
        super.init(bytes: bytes ?? [])
    }
    
    override func fromParser(
        parser: BinaryParser,
        hint: Int? = nil
    ) -> STObject {
        let serializer: BinarySerializer = BinarySerializer()

        while !parser.end() {
            let field = parser.readField()
            if field.name == OBJECT_END_MARKER {
                break
            }

            let associatedValue: SerializedType = try! parser.readFieldValue(field: field)!
            serializer.writeFieldAndValue(field: field, value: associatedValue)
            if field.type == ST_OBJECT {
                serializer.put(bytes: Data(OBJECT_END_MARKER_BYTE))
            }
        }

        return STObject(serializer.sink.toBytes())
    }
    
    class func from(value: [String: Any], onlySigning: Bool = false) throws -> STObject {
        let serializer: BinarySerializer = BinarySerializer()
        
        var xaddressDecoded: [String: AnyObject] = [:]
        for (k, v) in value {
            if v is String && AddressCodec.isValidXAddress(xAddress: v as! String) {
                print("ADDRESS")
                let handled = try handleXAddress(field: k, xaddress: v as! String)
                print(handled)
                if (
                    handled.contains(where: { $0.key == SOURCE_TAG })
                    && handled[SOURCE_TAG] != nil
                    && value.contains(where: { $0.key == SOURCE_TAG })
                    && value[SOURCE_TAG] != nil
                    && handled[SOURCE_TAG] as? Int != value[SOURCE_TAG] as? Int
                ) {
                    throw BinaryError.unknownError(error: "Cannot have mismatched Account X-Address and SourceTag")
                }
                if (
                    handled.contains(where: { $0.key == DEST_TAG })
                    && handled[DEST_TAG] != nil
                    && value.contains(where: { $0.key == DEST_TAG })
                    && value[DEST_TAG] != nil
                    && handled[DEST_TAG] as? Int != value[DEST_TAG] as? Int
                ) {
                    throw BinaryError.unknownError(error: "Cannot have mismatched Destination X-Address and DestinationTag")
                }
                xaddressDecoded.merge(handled)  { (_, new) in new }
            } else {
//                print("KEY: \(k)")
//                print("VALUE: \(strToEnum(field: k, value: v) as AnyObject)")
                xaddressDecoded[k] = strToEnum(field: k, value: v) as AnyObject
            }
        }
        
        var sortedKeys: [FieldInstance] = []
        print(xaddressDecoded)
        for fieldName in xaddressDecoded {
            let fieldInstance = Definitions().getFieldInstance(fieldName: fieldName.key)
            if (
                xaddressDecoded[fieldInstance.name] != nil
                && fieldInstance.isSerialized
            ) {
                sortedKeys.append(fieldInstance)
            }
        }
        sortedKeys = sortedKeys.sorted(by: { $0.ordinal < $1.ordinal })
        
        if onlySigning {
            sortedKeys = sortedKeys.filter({ $0.isSigning })
        }
        
        var isUnlModify: Bool = false
        
        for field in sortedKeys {
            print("--------------------------")
            print("--------------------------")
            var associatedValue: SerializedType? = nil
            do {
                print("FIELD NAME: \(field.name)")
                let av: AssociatedValue = AssociatedValue(field: field, xaddressDecoded: xaddressDecoded)
                associatedValue = try av.from()
                print("AV: \(associatedValue?.toHex())")
                
                
                //                if let av = field.associatedType.self as? AccountID.Type {
                //                    print("SOEMTHING")
                //                }
                //                print("AV: \(av)")
                //                if let av = field.associatedType.self as? STObject.Type {
                //                    print("SOEMTHING")
                ////                    associatedValue = av.from(value: xaddressDecoded[field.name]! as! SerializedType)
                //                }
                //                print("NOPE")
                //                print(xaddressDecoded[field.name])
                //                associatedValue = try field.associatedType.from(value: xaddressDecoded[field.name]! as! SerializedType)
                //                print("FIELD NAME: \(associatedValue)")
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
//        print(serializer.sink.toBytes().toHexString())
        return STObject(serializer.sink.toBytes())
    }
    
    override func toJson() -> [String: Any] {
        print("TO JSON")
        let parser: BinaryParser = BinaryParser(hex: self.toHex())
        var accumulator: [String: AnyObject] = [:]
        
        while !parser.end() {
            let field: FieldInstance = parser.readField()
            print(field.name)
            if field.name == OBJECT_END_MARKER {
                break
            }
            let fieldValue: Any = try! parser.readFieldValue(field: field)!
            accumulator[field.name] = enumToStr(field: field.name, value: fieldValue) as AnyObject
        }
        
        return accumulator
    }
}
