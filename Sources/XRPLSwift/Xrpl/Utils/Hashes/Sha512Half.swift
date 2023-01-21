//
//  Sha512Half.swift
//
//
//  Created by Denis Angell on 8/6/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/utils/hashes/sha512Half.ts

import Foundation

// swiftlint:disable:next identifier_name
let HASH_SIZE: Int = 32

/**
 Compute a sha512Half Hash of a hex string.
 - parameters:
    - hex: Hex string to hash.
 - returns:
 Hash of hex.
 */
public func sha512Half(_ hex: String) -> String {
    let hash = Data(hex: hex).sha512()
    return [UInt8](hash.prefix(through: HASH_SIZE - 1)).toHex
}
