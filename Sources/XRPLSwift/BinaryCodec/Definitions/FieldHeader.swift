//
//  FieldHeader.swift
//
//
//  Created by Denis Angell on 7/2/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/binarycodec/definitions/field_header.py

import Foundation

/**
 A container class for simultaneous storage of a field's type code and field code.
 */
public struct FieldHeader: Hashable {
    public var typeCode: Int
    public var fieldCode: Int

    /**
     Construct a FieldHeader.
     - parameters:
     - typeCode: The code for this field's serialization type.
     - fieldCode: The sort code that orders fields of the same type.
     */
    init(_ typeCode: Int, _ fieldCode: Int) {
        self.typeCode = typeCode
        self.fieldCode = fieldCode
    }

    /**
     Two FieldHeaders are equal if both type code and field_code are the same.
     */
    func isEqual(_ other: FieldHeader) -> Bool {
        //        if  !isinstance(other, FieldHeader) {
        //            return NotImplemented
        //        }
        return typeCode == other.typeCode && self.fieldCode == other.fieldCode
    }

    /**
     Two equal FieldHeaders must have the same hash value.
     */
    func toHash() -> Int {
        //        return hash((self.typeCode, self.fieldCode))
        return 0
    }

    /**
     Get the bytes representation of a FieldHeader.
     - returns:
     The bytes representation of the FieldHeader.
     */
    func toBytes() -> [UInt8] {
        var header: [UInt8] = []
        if self.typeCode < 16 {
            if self.fieldCode < 16 {
                header.append(UInt8(self.typeCode << 4 | self.fieldCode))
            } else {
                header.append(UInt8(self.typeCode) << 4)
                header.append(UInt8(self.fieldCode))
            }
        } else if self.fieldCode < 16 {
            header += [UInt8(self.fieldCode), UInt8(self.typeCode)]
        } else {
            header += [0, UInt8(self.typeCode), UInt8(self.fieldCode)]
        }
        return header
    }
}
