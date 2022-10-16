//
//  verifyPaymentChannelClaimUtils.swift
//
//
//  Created by Denis Angell on 9/9/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/utils/verifyPaymentChannelClaim.ts

import Foundation

/**
 Verify the signature of a payment channel claim.
 - parameters:
    - channel: Channel identifier specified by the paymentChannelClaim.
    - amount: Amount specified by the paymentChannelClaim.
    - signature: Signature produced from signing paymentChannelClaim.
    - publicKey: Public key that signed the paymentChannelClaim.
 - returns:
 True if the channel is valid.
 */
func verifyPaymentChannelClaim(
    _ channel: String,
    _ amount: String,
    _ signature: String,
    _ publicKey: String
) throws -> Bool {
    let channelLClaim = ChannelClaim(amount: try xrpToDrops(amount), channel: channel)
    let signingData = try BinaryCodec.encodeForSigningClaim(channelLClaim)
    return try Keypairs.verify(Data(hex: signingData).bytes, Data(hex: signature).bytes, publicKey)
}
