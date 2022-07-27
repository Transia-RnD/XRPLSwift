//
//  PaymentChannelFund.swift
//  AnyCodable
//
//  Created by Denis Angell on 2/19/22.
//
import Foundation

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/models/transactions/payment_channel_fund.py

public class PaymentChannelFund: Transaction {
    
    /*
    Represents a `PaymentChannelFund <https://xrpl.org/paymentchannelfund.html>`_
    transaction, adds additional XRP to an open `payment channel
    <https://xrpl.org/payment-channels.html>`_, and optionally updates the
    expiration time of the channel. Only the source address
    of the channel can use this transaction.
    */

    public var channel: String
    /*
    The unique ID of the payment channel, as a 64-character hexadecimal
    string. This field is required.
    :meta hide-value:
    */

    public var amount: aAmount
    /*
    The amount of XRP, in drops, to add to the channel. This field is
    required.
    :meta hide-value:
    */

    public var expiration: Int?
    /*
    A new mutable expiration time to set for the channel, in seconds since the
    Ripple Epoch. This must be later than the existing expiration time of the
    channel or later than the current time plus the settle delay of the channel.
    This is separate from the immutable ``cancelAfter`` time.
    */
    
    public init(
        from wallet: Wallet,
        channel: String,
        amount: aAmount,
        expiration: Int? = nil
    ) {
        self.channel = channel
        self.amount = amount
        self.expiration = expiration
        
        // TODO: Write into using variables on model not fields. (Serialize Later in Tx)
        // Sets the fields for the tx
        var _fields: [String:Any] = [
            "TransactionType": TransactionType.PaymentChannelFund.rawValue,
            "Channel": channel,
            "Amount": String(amount.drops),
        ]
        
        if let expiration = expiration {
            _fields["Expiration"] = expiration
        }
        
        super.init(wallet: wallet, fields: _fields)
    }

}
