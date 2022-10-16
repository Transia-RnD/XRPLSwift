//
//  DeriveUtils.swift
//
//
//  Created by Denis Angell on 9/9/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/utils/derive.ts

import Foundation

/**
 Derive an X-Address from a public key and a destination tag.
 - parameters:
    - publicKey: The public key corresponding to an address.
    - tag: A destination tag to encode into an X-address. False indicates no destination tag.
    - test: Whether this address is for use in Testnet.
 - returns:
 X-Address.
 */
func deriveXAddress(
    _ publicKey: String,
    _ tag: Int? = nil,
    _ test: Bool = false
) -> String {
    let classicAddress = try! Keypairs.deriveAddress(publicKey)
    return try! AddressCodec.classicAddressToXAddress(classicAddress: classicAddress, tag: tag, isTest: test)
}
