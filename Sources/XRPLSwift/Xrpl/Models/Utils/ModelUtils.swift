//
//  ModelUtils.swift
//
//
//  Created by Denis Angell on 8/7/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/utils/index.ts

import Foundation

/**
 Verify that all fields of an object are in fields.
 - parameters:
 - obj: Object to verify fields.
 - fields: Fields to verify.
 - returns:
 True if keys in object are all in fields.
 */
public func onlyHasFields(
    obj: [String: AnyObject],
    fields: [String]
) -> Bool {
    return obj.allSatisfy { (key: String, _: AnyObject) in
        return fields.contains(key)
    }
}

/**
 Perform bitwise AND (&) to check if a flag is enabled within Flags (as a number).
 - parameters:
 - flags: A number that represents flags enabled.
 - checkFlag: A specific flag to check if it's enabled within Flags.
 - returns:
 True if checkFlag is enabled within Flags.
 */
public func isFlagEnabled(flags: Int, checkFlag: Int) -> Bool {
    return (checkFlag & flags) == checkFlag
}

/**
 Check if string is in hex format.
 - parameters:
 - str: The string to check if it's in hex format.
 - returns:
 True if string is in hex format
 */
func isHex(str: String) -> Bool {
    // Tests if value is a valid 40-char hex string.
    guard let regex = try? NSRegularExpression(pattern: "^[0-9A-Fa-f]+$") else { return false }
    let nsrange = NSRange(str.startIndex..<str.endIndex, in: str)
    return regex.matches(in: str, range: nsrange).isEmpty ? false : true
}
