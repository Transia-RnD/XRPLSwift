////
////  File.swift
////
////
////  Created by Denis Angell on 7/30/22.
////
//
//import Foundation
//
//
///**
// * The `channel_verify` method checks the validity of a signature that can be
// * used to redeem a specific amount of XRP from a payment channel. Expects a
// * response in the form of a {@link ChannelVerifyResponse}.
// *
// * @category Requests
// */
//public class ChannelVerifyRequest: BaseRequest {
//    //  public let command: String = "channel_verify"
//    /** The amount of XRP, in drops, the provided signature authorizes. */
//    public let amount: String
//    /**
//     * The Channel ID of the channel that provides the XRP. This is a
//     * 64-character hexadecimal string.
//     */
//    public let channelId: String
//    /**
//     * The public key of the channel and the key pair that was used to create the
//     * signature, in hexadecimal or the XRP Ledger's base58 format.
//     */
//    public let publicKey: String
//    /** The signature to verify, in hexadecimal. */
//    public let signature: String
//    
//    enum CodingKeys: String, CodingKey {
//        case amount = "amount"
//        case channelId = "channel_id"
//        case publicKey = "public_key"
//        case signature = "signature"
//    }
//}
//
///**
// * Response expected from an {@link ChannelVerifyRequest}.
// *
// * @category Responses
// */
//public class ChannelVerifyResponse: BaseResponse {
//    /**
//     * If true, the signature is valid for the stated amount, channel, and
//     * public key.
//     */
//    public let signatureVerified: Bool
//    
//    enum CodingKeys: String, CodingKey {
//        case signatureVerified = "signature_verified"
//    }
//}
