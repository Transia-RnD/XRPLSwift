//
//  PaymentChannelClaim.swift
//  AnyCodable
//
//  Created by Denis Angell on 2/19/22.
//
import Foundation

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/models/transactions/payment_channel_claim.py


public enum PaymentChannelClaimFlag: UInt32 {
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

public class PaymentChannelClaim: Transaction {
    
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
    
    public init(
        from wallet: Wallet,
        channel: String,
        balance: Amount? = nil,
        amount: Amount? = nil,
        signature: String? = nil,
        publicKey: String? = nil,
        sourceTag : UInt32? = nil  // TODO: Move this to the base tx
    ) {
        
        self.channel = channel
        self.balance = balance
        self.amount = amount
        self.signature = signature
        self.publicKey = publicKey
        
        // TODO: Write into using variables on model not fields. (Serialize Later in Tx)
        // Sets the fields for the tx
        var _fields: [String:Any] = [
            "TransactionType": "PaymentChannelClaim",
            "Channel": channel,
        ]
        
        if amount != nil {
            _fields["Amount"] = String(amount!.drops)
        }
        
        if balance != nil {
            _fields["Balance"] = String(balance!.drops)
        }
        
        if signature != nil {
            _fields["Signature"] = signature
        }
        
        if publicKey != nil {
            _fields["PublicKey"] = publicKey
        }
        
        if let sourceTag = sourceTag {
            _fields["SourceTag"] = sourceTag
        }
        
        super.init(wallet: wallet, fields: _fields)
    }

}
