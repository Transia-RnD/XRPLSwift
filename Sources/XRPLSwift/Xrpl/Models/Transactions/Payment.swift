//
//  Payment.swift
//  AnyCodable
//
//  Created by Mitch Lang on 2/4/20.
//

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/models/transactions/payment.py

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

public class Payment: Transaction {
    
    /*
     Represents a Payment <https://xrpl.org/payment.html>`_ transaction, which
     sends value from one account to another. (Depending on the path taken, this
     can involve additional exchanges of value, which occur atomically.) This
     transaction type can be used for several `types of payments
     <http://xrpl.local/payment.html#types-of-payments>`_.
     Payments are also the only way to `create accounts
     <http://xrpl.local/payment.html#creating-accounts>`_.
     */
    
    public var amount: aAmount
    /*
     The amount of currency to deliver. If the Partial Payment flag is set,
     deliver *up to* this amount instead. This field is required.
     :meta hide-value:
     */
    
    public var destination: String
    /*
     The address of the account receiving the payment. This field is required.
     :meta hide-value:
     */
    
    public var destinationTag: UInt32?
    /*
     An arbitrary `destination tag
     <https://xrpl.org/source-and-destination-tags.html>`_ that
     identifies the reason for the Payment, or a hosted recipient to pay.
     */
    
    public var invoiceId: Int?
    /*
     Arbitrary 256-bit hash representing a specific reason or identifier for
     this Check.
     */
    
    public var paths: Int?
    /*
     Array of payment paths to be used (for a cross-currency payment). Must be
     omitted for XRP-to-XRP transactions.
     */
    
    public var sendMax: aAmount?
    /*
     Maximum amount of source currency this transaction is allowed to cost,
     including `transfer fees <http://xrpl.local/transfer-fees.html>`_,
     exchange rates, and slippage. Does not include the XRP destroyed as a
     cost for submitting the transaction. Must be supplied for cross-currency
     or cross-issue payments. Must be omitted for XRP-to-XRP payments.
     */
    
    public var deliverMin: aAmount?
    /*
     Minimum amount of destination currency this transaction should deliver.
     Only valid if this is a partial payment. If omitted, any positive amount
     is considered a success.
     */
    
    public init(
        from wallet: Wallet,
        amount: aAmount,
        destination: String,
        destinationTag: UInt32? = nil,
        invoiceId: Int? = nil,
        paths: Int? = nil,
        sendMax : aAmount? = nil,
        deliverMin : aAmount? = nil
    ) {
        
        self.amount = amount
        self.destination = destination
        self.destinationTag = destinationTag
        self.invoiceId = invoiceId
        self.paths = paths
        self.sendMax = sendMax
        self.deliverMin = deliverMin
        
        
        // TODO: Write into using variables on model not fields. (Serialize Later in Tx)
        // Sets the fields for the tx
        var _fields: [String: Any] = [
            "TransactionType": TransactionType.Payment.rawValue,
            "Destination": destination,
            "Amount": String(amount.drops),
            "Flags": UInt64(2147483648),
        ]
        
        // For Currencies
        if amount.currency != "XRP" {
            _fields["Amount"] = [
                "currency": amount.currency,
                "value": amount.toXrp().clean,
                "issuer": amount.issuer
            ]
        }
        
        if let destinationTag = destinationTag {
            _fields["DestinationTag"] = destinationTag
        }
        
        if let invoiceId = invoiceId {
            _fields["InvoiceID"] = invoiceId
        }
        
        if let paths = paths {
            _fields["Paths"] = paths
        }
        
        if let sendMax = sendMax {
            _fields["SendMax"] = sendMax
        }
        
        if let del = deliverMin {
            _fields["DeliverMin"] = deliverMin
        }
        
        super.init(wallet: wallet, fields: _fields)
    }
    
}
