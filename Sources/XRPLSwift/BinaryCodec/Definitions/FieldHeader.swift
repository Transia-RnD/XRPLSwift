//
//  FieldHeader.swift
//  
//
//  Created by Denis Angell on 7/2/22.
//

import Foundation


public struct FieldHeader: Hashable {
    /*
     A container class for simultaneous storage of a field's type code and
    field code.
    */
    
    public var typeCode: Int
    public var fieldCode: Int

    init(typeCode: Int, fieldCode: Int) {
        /*
        Construct a FieldHeader.
        `See Field Order <https://xrpl.org/serialization.html#canonical-field-order>`_
        :param type_code: The code for this field's serialization type.
        :param field_code: The sort code that orders fields of the same type.
        */
        self.typeCode = typeCode
        self.fieldCode = fieldCode
    }

    func isEqual(other: FieldHeader) -> Bool {
        // Two FieldHeaders are equal if both type code and field_code are the same.
//        if  !isinstance(other, FieldHeader) {
//            return NotImplemented
//        }
        return typeCode == other.typeCode && self.fieldCode == other.fieldCode
            
    }

    func toHash() -> Int {
        // Two equal FieldHeaders must have the same hash value.
//        return hash((self.typeCode, self.fieldCode))
        return 0
        
    }

    func toBytes() -> [Int] {
        /*
        Get the bytes representation of a FieldHeader.
        Returns:
            The bytes representation of the FieldHeader.
        */
        var header: [Int] = []
        if self.typeCode < 16 {
            if self.typeCode < 16 {
                header.append(self.typeCode << 4 | self.fieldCode)
            } else {
                header.append(self.typeCode << 4)
                header.append(self.fieldCode)
            }
        } else if self.fieldCode < 16 {
            header += [self.fieldCode, self.typeCode]
        } else {
            header += [0, self.typeCode, self.fieldCode]
        }

        return header
    }
}
