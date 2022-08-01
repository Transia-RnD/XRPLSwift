//
//  PaymentChannelFund.swift
//  AnyCodable
//
//  Created by Denis Angell on 2/19/22.
//
import Foundation

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/transactions/paymentChannelFund.ts

public class PaymentChannelFund: BaseTransaction {
    
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

    public var amount: rAmount
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
        channel: String,
        amount: rAmount,
        expiration: Int? = nil
    ) {
        self.channel = channel
        self.amount = amount
        self.expiration = expiration
        
        super.init(account: "", transactionType: "PaymentChannelFund")
    }
    
    enum CodingKeys: String, CodingKey {
        case channel = "Channel"
        case amount = "Amount"
        case expiration = "Expiration"
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        channel = try values.decode(String.self, forKey: .channel)
        amount = try values.decode(rAmount.self, forKey: .amount)
        expiration = try? values.decode(Int.self, forKey: .expiration)
        try super.init(from: decoder)
    }
    
    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try values.encode(channel, forKey: .channel)
        try values.encode(amount, forKey: .amount)
        if let expiration = expiration { try values.encode(expiration, forKey: .expiration) }
    }

}
