//
//  FieldIdCodec.swift
//
//
//  Created by Denis Angell on 7/24/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/binarycodec/field_id_codec.py

import Foundation

/**
 Functions to encode/decode the rippled field from the json dictionary
 */
public class FieldIdCodec {
    /**
     This field ID consists of the type code and field code, in 1 to 3 bytes
     depending on whether those values are "common" (<16) or "uncommon" (>=16)
     - parameters:
     - fieldName: The name of the field to get the serialization data type for.
     - returns:
     The serialization data type for the given field name.
     */
    class func encode(_ fieldName: String) throws -> Data {
        let fieldHeader: FieldHeader = Definitions().getFieldHeaderFromName(fieldName)
        return try self.encodeFieldId(fieldHeader)
    }

    /**
     Returns the field name represented by the given field ID.
     - parameters:
     - fieldId: The field_id to decode.
     - returns:
     The field name represented by the given field ID.
     */
    class func decode(_ fieldId: String) throws -> String {
        let fieldHeader: FieldHeader = try self.decodeFieldId(fieldId)
        return Definitions().getFieldNameFromHeader(fieldHeader)
    }

    /**
     Returns the unique field ID for a given field header. This field ID consists of the type code and field code, in 1 to 3 bytes
     depending on whether those values are "common" (<16) or "uncommon" (>=16)
     - parameters:
     - fieldHeader: The fieldHeader to decode.
     - returns:
     The unique field as data
     */
    class func encodeFieldId(_ fieldHeader: FieldHeader) throws -> Data {
        let typeCode = fieldHeader.typeCode
        let fieldCode = fieldHeader.fieldCode

        if !(0 < fieldCode || fieldCode <= 255) || !(0 < typeCode || typeCode <= 255) {
            throw BinaryError.unknownError(error: "Codes must be nonzero and fit in 1 byte.")
        }

        if typeCode < 16 && fieldCode < 16 {
            // high 4 bits is the type_code
            // low 4 bits is the field code
            let combinedCode = (typeCode << 4) | fieldCode
            return self.uint8ToBytes(combinedCode)
        }
        if typeCode >= 16 && fieldCode < 16 {
            // first 4 bits are zeroes
            // next 4 bits is field code
            // next byte is type code
            let byte1 = self.uint8ToBytes(fieldCode)
            let byte2 = self.uint8ToBytes(typeCode)
            return byte1 + byte2
        }
        if typeCode < 16 && fieldCode >= 16 {
            // first 4 bits is type code
            // next 4 bits are zeroes
            // next byte is field code
            let byte1 = self.uint8ToBytes(typeCode << 4)
            let byte2 = self.uint8ToBytes(fieldCode)
            return byte1 + byte2
        } else {  // both are >= 16
            // first byte is all zeroes
            // second byte is type code
            // third byte is field code
            let byte2 = self.uint8ToBytes(typeCode)
            let byte3 = self.uint8ToBytes(fieldCode)
            return [0x0] + byte2 + byte3
        }
    }

    /**
     Returns a FieldHeader object representing the type code and field code of
     a decoded field ID.
     - parameters:
     - fieldId: The fieldId to decode.
     - returns:
     A FieldHeader object representing the type code and field code of
     */
    class func decodeFieldId(_ fieldId: String) throws -> FieldHeader {
        let byteArray = fieldId.hexToBytes
        if byteArray.count == 1 {
            let highBits = byteArray[0] >> 4
            let lowBits = byteArray[0] & 0x0F
            return FieldHeader(Int(highBits), Int(lowBits))
        }
        if byteArray.count == 2 {
            let firstByte = byteArray[0]
            let secondByte = byteArray[1]
            let firstByteHighBits = firstByte >> 4
            let firstByteLowBits = firstByte & 0x0F
            if firstByteHighBits == 0 { // next 4 bits are field code, second byte is type code
                return FieldHeader(Int(secondByte), Int(firstByteLowBits))
            }
            // Otherwise, next 4 bits are type code, second byte is field code
            return FieldHeader(Int(firstByteHighBits), Int(secondByte))
        }
        if byteArray.count == 3 {
            return FieldHeader(Int(byteArray[1]), Int(byteArray[2]))
        }

        throw BinaryError.unknownError(error: "Field ID must be between 1 and 3 bytes. This field ID contained \(byteArray.count) bytes.")
    }

    /**
     Returns a Data representation of  the FieldId Codec
     - parameters:
     - i: The integer to convert to bytes
     - returns:
     A Data representation of  the FieldId Codec
     */
    class func uint8ToBytes(_ i: Int) -> Data {
        return Data(bytes: i.data.bytes, count: 1)
    }
}
