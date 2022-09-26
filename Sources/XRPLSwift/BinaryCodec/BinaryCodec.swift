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

// swiftlint:disable:next identifier_name
let TRANSACTION_SIGNATURE_PREFIX = Data(numToBytes(num: 0x53545800).bytes.reversed())
// swiftlint:disable:next identifier_name
let PAYMENT_CHANNEL_CLAIM_PREFIX = Data(numToBytes(num: 0x434C4D00).bytes.reversed())
// swiftlint:disable:next identifier_name
let TRANSACTION_MULTISIG_PREFIX = Data(numToBytes(num: 0x534D5400).bytes.reversed())

class BinaryCodec {
    /**
     Encode a transaction or other object into the canonical binary format.
     - parameters:
        - json: A JSON-like dictionary representation of an object.
     - returns:
     The binary-encoded object, as a hexadecimal string.
     */
    class func encode(json: [String: Any]) throws -> String {
        return try serializeJson(json: json)
    }

    /**
     Encode a transaction or other object into the canonical binary format.
     - parameters:
        - data: A Data representation of an object.
     - returns:
     The binary-encoded object, as a hexadecimal string.
     */
    class func encode(data: Data) throws -> String {
        let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        return try serializeJson(json: jsonResult as! [String: Any])
    }

    /**
     Encode a transaction into binary format in preparation for signing. (Only encodes fields that are intended to be signed.)
     - parameters:
        - json: A JSON-like dictionary representation of a transaction.
     - returns:
     The binary-encoded transaction, ready to be signed.
     */
    class func encodeForSigning(json: [String: Any]) throws -> String {
        return try serializeJson(
            json: json,
            prefix: TRANSACTION_SIGNATURE_PREFIX,
            signingOnly: true
        )
    }

    /**
     Encode a `payment channel <https://xrpl.org/payment-channels.html>`_ Claim
     to be signed.
     - parameters:
        - json: A JSON-like dictionary representation of a Claim.
     - returns:
     The binary-encoded claim, ready to be signed.
     */
    class func encodeForSigningClaim(json: [String: AnyObject]) throws -> String {
        let prefix: Data = PAYMENT_CHANNEL_CLAIM_PREFIX
        let channel: Hash = try Hash256.from(value: json["channel"] as! String)
        let amount: xUInt64 = try xUInt64.from(value: Int(json["amount"] as! String)!)
        let buffer: Data = prefix + channel.bytes + amount.bytes
        return buffer.toHex
    }

    /**
     Encode a transaction into binary format in preparation for providing one
     signature towards a multi-signed transaction.
     (Only encodes fields that are intended to be signed.)
     - parameters:
        - json: A JSON-like dictionary representation of a transaction.
        - signingAccount: The address of the signer who'll provide the signature.
     - returns:
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

    /**
     Decode a transaction from binary format to a JSON-like dictionary
     representation.
     - parameters:
        - buffer: The encoded transaction binary, as a hexadecimal string.
     - returns:
     A JSON-like dictionary representation of the transaction.
     */
    class func decode(buffer: String) -> [String: AnyObject] {
        let parser = BinaryParser(hex: buffer)
        let parsedType: SerializedType = try! parser.readType(type: STObject.self)
        return parsedType.toJson()
    }

    /**
     Serialize the json object into a hex string
     - parameters:
        - json: A JSON-like dictionary representation of a STObject.
        - prefix: A byte prefix
        - suffix: A byte suffix
        - signingOnly: A boolean represeting if the STObject needs to be signed
     - returns:
     A hex string of the encoded transaction.
     */
    class func serializeJson(
        json: [String: Any],
        prefix: Data? = nil,
        suffix: Data? = nil,
        signingOnly: Bool = false
    ) throws -> String {
        var buffer = Data()
        if let prefix = prefix {
            buffer += prefix
        }

        buffer += try STObject.from(value: json, onlySigning: signingOnly).bytes

        if let suffix = suffix {
            buffer += suffix
        }

        return buffer.toHex
    }
}
