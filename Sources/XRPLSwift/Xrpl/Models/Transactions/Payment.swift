//
//  Payment.swift
//  AnyCodable
//
//  Created by Mitch Lang on 2/4/20.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/transactions/payment.ts

import Foundation

public enum PaymentFlag: UInt32 {
    /*
     Transactions of the Payment type support additional values in the Flags field.
     This enum represents those options.
     `See Payment Flags <https://xrpl.org/payment.html#payment-flags>`_
     */
    
    case tfNoDirectRipple = 0x00010000
    /*
     Do not use the default path; only use paths included in the Paths field.
     This is intended to force the transaction to take arbitrage opportunities.
     Most clients do not need this.
     */
    
    case tfPartialPayment = 0x00020000
    /*
     If the specified Amount cannot be sent without spending more than SendMax,
     reduce the received amount instead of failing outright.
     See `Partial Payments <https://xrpl.org/partial-payments.html>`_ for more details.
     */
    
    case tfLimitQualtity = 0x00040000
    /*
     Only take paths where all the conversions have an input:output ratio
     that is equal or better than the ratio of Amount:SendMax.
     See `Limit <https://xrpl.org/payment.html#limit-quality>`_ Quality for details.
     */
}

public class Payment: BaseTransaction {
    
    /*
     Represents a Payment <https://xrpl.org/payment.html>`_ transaction, which
     sends value from one account to another. (Depending on the path taken, this
     can involve additional exchanges of value, which occur atomically.) This
     transaction type can be used for several `types of payments
     <http://xrpl.local/payment.html#types-of-payments>`_.
     Payments are also the only way to `create accounts
     <http://xrpl.local/payment.html#creating-accounts>`_.
     */
    
    public let amount: rAmount
    /*
     The amount of currency to deliver. If the Partial Payment flag is set,
     deliver *up to* this amount instead. This field is required.
     :meta hide-value:
     */
    
    public let destination: String
    /*
     The address of the account receiving the payment. This field is required.
     :meta hide-value:
     */
    
    public let destinationTag: Int?
    /*
     An arbitrary `destination tag
     <https://xrpl.org/source-and-destination-tags.html>`_ that
     identifies the reason for the Payment, or a hosted recipient to pay.
     */
    
    public let invoiceId: Int?
    /*
     Arbitrary 256-bit hash representing a specific reason or identifier for
     this Check.
     */
    
    public let paths: Int?
    /*
     Array of payment paths to be used (for a cross-currency payment). Must be
     omitted for XRP-to-XRP transactions.
     */
    
    public let sendMax: rAmount?
    /*
     Maximum amount of source currency this transaction is allowed to cost,
     including `transfer fees <http://xrpl.local/transfer-fees.html>`_,
     exchange rates, and slippage. Does not include the XRP destroyed as a
     cost for submitting the transaction. Must be supplied for cross-currency
     or cross-issue payments. Must be omitted for XRP-to-XRP payments.
     */
    
    public let deliverMin: rAmount?
    /*
     Minimum amount of destination currency this transaction should deliver.
     Only valid if this is a partial payment. If omitted, any positive amount
     is considered a success.
     */
    
    public init(
        amount: rAmount,
        destination: String,
        destinationTag: Int? = nil,
        invoiceId: Int? = nil,
        paths: Int? = nil,
        sendMax : rAmount? = nil,
        deliverMin : rAmount? = nil
    ) {
        
        self.amount = amount
        self.destination = destination
        self.destinationTag = destinationTag
        self.invoiceId = invoiceId
        self.paths = paths
        self.sendMax = sendMax
        self.deliverMin = deliverMin
        super.init(account: "", transactionType: "Payment")
    }
    
    enum CodingKeys: String, CodingKey {
        case amount = "Amount"
        case destination = "Destination"
        case destinationTag = "DestinationTag"
        case invoiceId = "InvoiceID"
        case paths = "Paths"
        case sendMax = "SendMax"
        case deliverMin = "DeliverMin"
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        amount = try values.decode(rAmount.self, forKey: .amount)
        destination = try values.decode(String.self, forKey: .destination)
        destinationTag = try? values.decode(Int.self, forKey: .destinationTag)
        invoiceId = try? values.decode(Int.self, forKey: .invoiceId)
        paths = try? values.decode(Int.self, forKey: .paths)
        sendMax = try? values.decode(rAmount.self, forKey: .sendMax)
        deliverMin = try? values.decode(rAmount.self, forKey: .deliverMin)
        try super.init(from: decoder)
    }
    
    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try values.encode(amount, forKey: .amount)
        try values.encode(destination, forKey: .destination)
        if let destinationTag = destinationTag { try values.encode(destinationTag, forKey: .destinationTag) }
        if let invoiceId = invoiceId { try values.encode(invoiceId, forKey: .invoiceId) }
        if let paths = paths { try values.encode(paths, forKey: .paths) }
        if let sendMax = sendMax { try values.encode(sendMax, forKey: .sendMax) }
        if let deliverMin = deliverMin { try values.encode(deliverMin, forKey: .deliverMin) }
    }
}
