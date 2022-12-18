//
//  signPaymentChannelClaimUtils.swift
//
//
//  Created by Denis Angell on 9/9/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/utils/signPaymentChannelClaim.ts

import Foundation

/**
 Verify the signature of a payment channel claim.
 - parameters:
    - channel: Channel identifier specified by the paymentChannelClaim.
    - amount: Amount specified by the paymentChannelClaim.
    - privateKey: Private Key to sign paymentChannelClaim with.
 - returns:
 True if the channel is valid.
 */
func signPaymentChannelClaim(
    _ channel: String,
    _ amount: String,
    _ privateKey: String
) throws -> String {
//    print(try xrpToDrops(amount))
    let channelClaim = ChannelClaim(amount: try xrpToDrops(amount), channel: channel)
    let signingData = try BinaryCodec.encodeForSigningClaim(channelClaim)
//    print(Data(hex: signingData).bytes)
//    print(signingData.bytes)
    return try Keypairs.sign(signingData.bytes, privateKey).toHex
}
