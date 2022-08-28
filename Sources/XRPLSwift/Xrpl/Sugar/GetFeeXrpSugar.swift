//
//  GetFeeXrpSugar.swift
//  
//
//  Created by Denis Angell on 8/21/22.
//

// https://github.com/XRPLF/xrpl.js/blob/02ed92807e34d823fcfa8aefffbc2e45413be9a8/packages/xrpl/src/sugar/getFeeXrp.ts

import Foundation

// swiftlint:disable:next identifier_name
let NUM_DECIMAL_PLACES: Int = 6
// swiftlint:disable:next identifier_name
let BASE_10: Int = 10

/**
 * Calculates the current transaction fee for the ledger.
 * Note: This is a public API that can be called directly.
 *
 * @param client - The Client used to connect to the ledger.
 * @param cushion - The fee cushion to use.
 * @returns The transaction fee.
 */
public func getFeeXrp(
    client: XrplClient,
    cushion: Int? = nil
) async throws -> String {
    let feeCushion = cushion ?? client.feeCushion

    let request = try ServerInfoRequest(["command": "server_info"] as [String: AnyObject])
    let response = try await client.request(request).wait() as? BaseResponse<ServerInfoResponse>
    let serverInfo = response?.result?.info
    let baseFee = serverInfo?.validatedLedger?.baseFeeXrp

    if baseFee == nil {
        throw XrplError.unknown("getFeeXrp: Could not get base_fee_xrp from server_info")
    }

//    let baseFeeXrp = BigNumber(baseFee)
    if serverInfo?.loadFactor == nil {
        // https://github.com/ripple/rippled/issues/3812#issuecomment-816871100
        serverInfo?.loadFactor = 1
    }
//    var fee = baseFeeXrp * serverInfo?.loadFactor * feeCushion
    return "100"
    // Cap fee to `client.maxFeeXRP`
//    fee = BigNumber.min(fee, client.maxFeeXRP)
    // Round fee to 6 decimal places
//    return BigNumber(fee.toFixed(NUM_DECIMAL_PLACES)).toString(BASE_10)
}
