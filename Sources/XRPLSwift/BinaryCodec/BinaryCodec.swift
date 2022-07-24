//
//  BinaryCodec.swift
//  
//
//  Created by Denis Angell on 7/24/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/binarycodec/main.py

import Foundation


func numToBytes(num: Int) -> Data {
    return Data(bytes: Int(num).asBigByteArray.reversed(), count: 4)
}


let TRANSACTION_SIGNATURE_PREFIX: Data = numToBytes(num: 0x53545800)
let PAYMENT_CHANNEL_CLAIM_PREFIX: Data = numToBytes(num: 0x434C4D00)
let TRANSACTION_MULTISIG_PREFIX: Data = numToBytes(num: 0x534D5400)

class BinaryCodec {
    /*
     Encode a transaction or other object into the canonical binary format.
     Args:
     json: A JSON-like dictionary representation of an object.
     Returns:
     The binary-encoded object, as a hexadecimal string.
     */
    class func encode(json: [String: Any]) throws -> String {
        return try serializeJson(json: json)
    }
    
    /*
     Encode a transaction into binary format in preparation for signing. (Only
     encodes fields that are intended to be signed.)
     Args:
     json: A JSON-like dictionary representation of a transaction.
     Returns:
     The binary-encoded transaction, ready to be signed.
     */
    class func encodeForSigning(json: [String: Any]) throws -> String {
        return try serializeJson(
            json: json,
            prefix: TRANSACTION_SIGNATURE_PREFIX,
            signingOnly: true
        )
    }
    
    /*
     Encode a `payment channel <https://xrpl.org/payment-channels.html>`_ Claim
     to be signed.
     Args:
     json: A JSON-like dictionary representation of a Claim.
     Returns:
     The binary-encoded claim, ready to be signed.
     */
    class func encodeForSigningClaim(json: [String: Any]) throws -> String {
        let prefix: Data = PAYMENT_CHANNEL_CLAIM_PREFIX
        let channel: Hash256 = try Hash256.from(value: json["channel"] as! String) as! Hash256
        let amount: xUInt64 = try xUInt64.from(value: Int(json["amount"] as! String)!)
        
        let buffer: Data = prefix + channel.bytes + amount.bytes
        return buffer.toHexString().uppercased()
    }
    
    
    /*
     Encode a transaction into binary format in preparation for providing one
     signature towards a multi-signed transaction.
     (Only encodes fields that are intended to be signed.)
     Args:
     json: A JSON-like dictionary representation of a transaction.
     signing_account: The address of the signer who'll provide the signature.
     Returns:
     A hex string of the encoded transaction.
     */
    class func encodeForMultisigning(json: [String: Any], signingAccount: String) throws -> String {
        let signingAccountID = try AccountID.from(value: signingAccount).bytes
        
        return try serializeJson(
            json: json,
            prefix: TRANSACTION_MULTISIG_PREFIX,
            suffix: Data(signingAccountID),
            signingOnly: true
        )
    }
    
    /*
     Decode a transaction from binary format to a JSON-like dictionary
     representation.
     Args:
     buffer: The encoded transaction binary, as a hexadecimal string.
     Returns:
     A JSON-like dictionary representation of the transaction.
     */
    class func decode(buffer: String) -> [String: Any] {
        let parser: BinaryParser = BinaryParser(hex: buffer)
//        let parsedType: SerializedType = parser.readType(type: STObject)
//        return parsedType.toJson()
        return [:]
    }
    
    
    class func serializeJson(
        json: [String: Any],
        prefix: Data? = nil,
        suffix: Data? = nil,
        signingOnly: Bool = false
    ) throws -> String {
        var buffer: Data = Data()
        if prefix != nil {
            buffer += prefix!
        }
        
        buffer += try STObject.from(value: json, onlySigning: signingOnly).bytes
        
        if suffix != nil {
            buffer += suffix!
        }
        
        return buffer.toHexString().uppercased()
    }
}
