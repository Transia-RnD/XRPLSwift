//
//  PaymentChannelCreate.swift
//  AnyCodable
//
//  Created by Denis Angell on 2/19/22.
//
import Foundation

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/models/transactions/payment_channel_create.py

public class PaymentChannelCreate: Transaction {
    
    /*
    Represents a `PaymentChannelCreate
    <https://xrpl.org/paymentchannelcreate.html>`_ transaction, which creates a
    `payment channel <https://xrpl.org/payment-channels.html>`_ and funds it with
    XRP. The sender of this transaction is the "source address" of the payment
    channel.
    */

    public var amount: aAmount
    /*
    The amount of XRP, in drops, to set aside in this channel. This field is
    required.
    :meta hide-value:
    */

    public var destination: Address
    /*
    The account that can receive XRP from this channel, also known as the
    "destination address" of the channel. Cannot be the same as the sender.
    This field is required.
    :meta hide-value:
    */

    public var settleDelay: Int
    /*
    The amount of time, in seconds, the source address must wait between
    requesting to close the channel and fully closing it. This field is
    required.
    :meta hide-value:
    */

    public var publicKey: String
    /*
    The public key of the key pair that the source will use to authorize
    claims against this  channel, as hexadecimal. This can be any valid
    secp256k1 or Ed25519 public key. This field is required.
    :meta hide-value:
    */

    public var cancelAfter: Int?
    /*
    An immutable expiration time for the channel, in seconds since the Ripple
    Epoch. The channel can be closed sooner than this but cannot remain open
    later than this time.
    */

    public var destinationTag: Int?
    /*
    An arbitrary `destination tag
    <https://xrpl.org/source-and-destination-tags.html>`_ that
    identifies the reason for the Payment Channel, or a hosted recipient to pay.
    */
    
    public init(
        from wallet: Wallet,
        destination: Address,
        destinationTag: Int? = nil,
        publicKey: String,
        amount: aAmount,
        settleDelay: Int,
        cancelAfter: Int? = nil
    ) {
        self.destination = destination
        self.destinationTag = destinationTag
        self.publicKey = publicKey
        self.amount = amount
        self.settleDelay = settleDelay
        self.cancelAfter = cancelAfter
        
        // TODO: Write into using variables on model not fields. (Serialize Later in Tx)
        // Sets the fields for the tx
        var _fields: [String:Any] = [
            "TransactionType": TransactionType.PaymentChannelCreate.rawValue,
            "SettleDelay": settleDelay,
            "PublicKey": publicKey,
            "Amount": String(amount.drops),
            "Destination": destination.rAddress,
        ]
        
        if let cancelAfter = cancelAfter {
            assert(cancelAfter > settleDelay)
            _fields["CancelAfter"] = cancelAfter
        }
        
        if let destinationTag = destinationTag {
            _fields["DestinationTag"] = destinationTag
        }
        
        super.init(wallet: wallet, fields: _fields)
    }
}
