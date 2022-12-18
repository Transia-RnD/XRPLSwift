//
//  File.swift
//
//
//  Created by Denis Angell on 9/9/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/utils/stringConversion.ts

import Foundation

/**
 * Converts a string to its hex equivalent. Useful for Memos.
 *
 * @param string - The string to convert to Hex.
 * @returns The Hex equivalent of the string.
 * @category Utilities
 */
extension String {
    var convertStringToHex: String {
        return Data(self.utf8).toHex
    }
}

/**
 * Converts hex to its string equivalent. Useful to read the Domain field and some Memos.
 *
 * @param hex - The hex to convert to a string.
 * @param encoding - The encoding to use. Defaults to 'utf8' (UTF-8). 'ascii' is also allowed.
 * @returns The converted string.
 * @category Utilities
 */
extension String {
    var convertHexToString: String {
        return String(decoding: Data(hex: self), as: UTF8.self)
    }
}
