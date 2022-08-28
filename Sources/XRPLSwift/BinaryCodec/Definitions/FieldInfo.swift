//
//  FieldInfo.swift
//  
//
//  Created by Denis Angell on 7/2/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/binarycodec/definitions/field_info.py

import Foundation

public class FieldInfo {
    public var nth: Int
    public var isVLEncoded: Bool
    public var isSerialized: Bool
    public var isSigningField: Bool
    public var type: String

    init(dict: NSDictionary) {
        self.nth = dict["nth"] as! Int
        self.isVLEncoded = dict["isVLEncoded"] as! Bool
        self.isSerialized = dict["isSerialized"] as! Bool
        self.isSigningField = dict["isSigningField"] as! Bool
        self.type = dict["type"] as! String

    }
}
