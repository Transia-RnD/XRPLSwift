//
//  ModelUtils.swift
//  
//
//  Created by Denis Angell on 8/7/22.
//

import Foundation

//
//let HEX_REGEX: String = "/^[0-9A-Fa-f]+$/u"

/**
 * Verify that all fields of an object are in fields.
 *
 * @param obj - Object to verify fields.
 * @param fields - Fields to verify.
 * @returns True if keys in object are all in fields.
 */
public func onlyHasFields(
    obj: [String: AnyObject],
    fields: [String]
) -> Bool {
    return obj.allSatisfy { (key: String, value: AnyObject) in
        return fields.contains(key)
    }
}

/**
 * Perform bitwise AND (&) to check if a flag is enabled within Flags (as a number).
 *
 * @param Flags - A number that represents flags enabled.
 * @param checkFlag - A specific flag to check if it's enabled within Flags.
 * @returns True if checkFlag is enabled within Flags.
 */
public func isFlagEnabled(flags: Int, checkFlag: Int) -> Bool {
    // eslint-disable-next-line no-bitwise -- flags needs bitwise
    return (checkFlag & flags) == checkFlag
}

/**
 * Check if string is in hex format.
 *
 * @param str - The string to check if it's in hex format.
 * @returns True if string is in hex format
 */
func isHex(str: String) -> Bool {
    // Tests if value is a valid 40-char hex string.
    let regex = try! NSRegularExpression(pattern: "^[A-F0-9]+$")
    let nsrange = NSRange(str.startIndex..<str.endIndex, in: str)
    return regex.matches(in: str, range: nsrange).isEmpty ? false : true
}
