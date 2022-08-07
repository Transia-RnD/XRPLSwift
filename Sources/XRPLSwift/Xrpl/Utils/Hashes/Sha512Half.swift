//
//  File.swift
//
//
//  Created by Denis Angell on 8/6/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/utils/hashes/sha512Half.ts

import Foundation
import CommonCrypto

let HASH_SIZE: Int = 32

/**
 * Compute a sha512Half Hash of a hex string.
 *
 * @param hex - Hex string to hash.
 * @returns Hash of hex.
 */
public func sha512Half(hex: String) -> String {
    let hash: Data = Data(hex: hex).sha256()
    return [UInt8](hash.prefix(through: HASH_SIZE - 1)).toHexString()
}

