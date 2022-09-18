//
//  PaymentChannelClaim.swift
//  AnyCodable
//
//  Created by Denis Angell on 2/19/22.
//
import Foundation

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/transactions/paymentChannelClaim.ts

public enum PaymentChannelClaimFlag: Int {
    /*
     Transactions of the PaymentChannelClaim type support additional values in the Flags
     field. This enum represents those options.
     `See PaymentChannelClaim Flags
     <https://xrpl.org/paymentchannelclaim.html#paymentchannelclaim-flags>`_
     */

    case tfRenew = 0x00010000
    /*
     Clear the channel's `Expiration` time. (`Expiration` is different from the
     channel's immutable `CancelAfter` time.) Only the source address of the payment
     channel can use this flag.
     */

    case tfClose = 0x00020000
    /*
     Request to close the channel. Only the channel source and destination addresses
     can use this flag. This flag closes the channel immediately if it has no more
     XRP allocated to it after processing the current claim, or if the destination
     address uses it. If the source address uses this flag when the channel still
     holds XRP, this schedules the channel to close after `SettleDelay` seconds have
     passed. (Specifically, this sets the `Expiration` of the channel to the close
     time of the previous ledger plus the channel's `SettleDelay` time, unless the
     channel already has an earlier `Expiration` time.) If the destination address
     uses this flag when the channel still holds XRP, any XRP that remains after
     processing the claim is returned to the source address.
     */
}

extension [PaymentChannelClaimFlag] {
    var interface: [PaymentChannelClaimFlag: Bool] {
        var flags: [PaymentChannelClaimFlag: Bool] = [:]
        for flag in self {
            if flag == .tfRenew {
                flags[flag] = true
            }
            if flag == .tfClose {
                flags[flag] = true
            }
        }
        return flags
    }
}

public class PaymentChannelClaim: BaseTransaction {
    /*
     Represents a `PaymentChannelClaim <https://xrpl.org/paymentchannelclaim.html>`_
     transaction, which claims XRP from a `payment channel
     <https://xrpl.org/payment-channels.html>`_, adjusts
     channel's expiration, or both. This transaction can be used differently
     depending on the transaction sender's role in the specified channel.
     */

    public var channel: String = ""
    /*
     The unique ID of the payment channel, as a 64-character hexadecimal
     string. This field is required.
     :meta hide-value:
     */

    public var balance: Amount?
    /*
     The cumulative amount of XRP to have delivered through this channel after
     processing this claim. Required unless closing the channel.
     */

    public var amount: Amount?
    /*
     The cumulative amount of XRP that has been authorized to deliver by the
     attached claim signature. Required unless closing the channel.
     */

    public var signature: String?
    /*
     The signature of the claim, as hexadecimal. This signature must be
     verifiable for the this channel and the given ``public_key`` and ``amount``
     values. May be omitted if closing the channel or if the sender of this
     transaction is the source address of the channel; required otherwise.
     */

    public var publicKey: String?
    /*
     The public key that should be used to verify the attached signature. Must
     match the `PublicKey` that was provided when the channel was created.
     Required if ``signature`` is provided.
     */

    enum CodingKeys: String, CodingKey {
        case channel = "Channel"
        case balance = "Balance"
        case amount = "Amount"
        case signature = "Signature"
        case publicKey = "PublicKey"
    }

    public init(
        channel: String,
        balance: Amount? = nil,
        amount: Amount? = nil,
        signature: String? = nil,
        publicKey: String? = nil
    ) {
        self.channel = channel
        self.balance = balance
        self.amount = amount
        self.signature = signature
        self.publicKey = publicKey
        super.init(account: "", transactionType: "PaymentChannelClaim")
    }

    override public init(json: [String: AnyObject]) throws {
        let decoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(PaymentChannelClaim.self, from: data)
        self.channel = decoded.channel
        self.balance = decoded.balance
        self.amount = decoded.amount
        self.signature = decoded.signature
        self.publicKey = decoded.publicKey
        try super.init(json: json)
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        channel = try values.decode(String.self, forKey: .channel)
        balance = try values.decodeIfPresent(Amount.self, forKey: .balance)
        amount = try values.decodeIfPresent(Amount.self, forKey: .amount)
        signature = try values.decodeIfPresent(String.self, forKey: .signature)
        publicKey = try values.decodeIfPresent(String.self, forKey: .publicKey)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try values.encode(channel, forKey: .channel)
        if let balance = balance { try values.encode(balance, forKey: .balance) }
        if let amount = amount { try values.encode(amount, forKey: .amount) }
        if let signature = signature { try values.encode(signature, forKey: .signature) }
        if let publicKey = publicKey { try values.encode(publicKey, forKey: .publicKey) }
    }
}

/**
 Verify the form and type of an PaymentChannelClaim at runtime.
 - parameters:
    - tx: An PaymentChannelClaim Transaction.
 - throws:
 When the PaymentChannelClaim is Malformed.
 */
public func validatePaymentChannelClaim(tx: [String: AnyObject]) throws {
    try validateBaseTransaction(common: tx)

    if tx["Channel"] == nil {
        throw ValidationError("PaymentChannelClaim: missing Channel")
    }

    if !(tx["Channel"] is String) {
        throw ValidationError("PaymentChannelClaim: Channel must be a string")
    }

    if tx["Balance"] != nil && !(tx["Balance"] is String) {
        throw ValidationError("PaymentChannelClaim: Balance must be a string")
    }

    if tx["Amount"] != nil && !(tx["Amount"] is String) {
        throw ValidationError("PaymentChannelClaim: Amount must be a string")
    }

    if tx["Signature"] != nil && !(tx["Signature"] is String) {
        throw ValidationError("PaymentChannelClaim: Signature must be a string")
    }

    if tx["PublicKey"] != nil && !(tx["PublicKey"] is String) {
        throw ValidationError("PaymentChannelClaim: PublicKey must be a string")
    }
}
