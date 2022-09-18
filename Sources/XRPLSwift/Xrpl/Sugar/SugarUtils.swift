//
//  SugarUtils.swift
//  
//
//  Created by Denis Angell on 8/6/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/sugar/utils.ts

import Foundation

/**
 * If an address is an X-Address, converts it to a classic address.
 *
 * @param account - A classic address or X-address.
 * @returns The account's classic address.
 * @throws Error if the X-Address has an associated tag.
 */
// eslint-disable-next-line import/prefer-default-export -- okay for a utils file - there could be more exports later
public func ensureClassicAddress(account: String) throws -> String {
    if AddressCodec.isValidXAddress(xAddress: account) {
        let result: AnyObject? = try AddressCodec.xAddressToClassicAddress(xAddress: account) as AnyObject
        let classicAddress: String? = result?["classicAddress"] as? String
        let tag: Int? = result?["tag"] as? Int
        /*
         * Except for special cases, X-addresses used for requests
         * must not have an embedded tag. In other words,
         * `tag` should be `false`.
         */
        if tag != nil {
            throw XrplError("This command does not support the use of a tag. Use an address without a tag.")
        }

        // For rippled requests that use an account, always use a classic address.
        return classicAddress!
    }
    return account
}
