//
//  OfferCreate.swift
//  AnyCodable
//
//  Created by Denis Angell on 3/20/22.
//

import Foundation

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/models/transactions/offer_create.py

public enum OfferCreateFlag: UInt32 {
    
    /*
    Transactions of the OfferCreate type support additional values in the Flags field.
    This enum represents those options.
    `See OfferCreate Flags <https://xrpl.org/offercreate.html#offercreate-flags>`_
     */

    case tfPassive = 0x00010000
    /*
    If enabled, the offer does not consume offers that exactly match it, and instead
    becomes an Offer object in the ledger. It still consumes offers that cross it.
     */

    case tfImmediateOrCancel = 0x00020000
    /*
    Treat the offer as an `Immediate or Cancel order
    <https://en.wikipedia.org/wiki/Immediate_or_cancel>`_. If enabled, the offer
    never becomes a ledger object: it only tries to match existing offers in the
    ledger. If the offer cannot match any offers immediately, it executes
    "successfully" without trading any currency. In this case, the transaction has
    the result code `tesSUCCESS`, but creates no Offer objects in the ledger.
     */

    case tfFillOrKill = 0x00040000
    /*
    Treat the offer as a `Fill or Kill order
    <https://en.wikipedia.org/wiki/Fill_or_kill>`_. Only try to match existing
    offers in the ledger, and only do so if the entire `TakerPays` quantity can be
    obtained. If the `fix1578 amendment
    <https://xrpl.org/known-amendments.html#fix1578>`_ is enabled and the offer
    cannot be executed when placed, the transaction has the result code `tecKILLED`;
    otherwise, the transaction uses the result code `tesSUCCESS` even when it was
    killed without trading any currency.
     */

    case tfSell = 0x00080000
    /*
    Exchange the entire `TakerGets` amount, even if it means obtaining more than the
    `TakerPays amount` in exchange.
    */
}

public class OfferCreate: Transaction {
    /*
    Represents an `OfferCreate <https://xrpl.org/offercreate.html>`_ transaction,
    which executes a limit order in the `decentralized exchange
    <https://xrpl.org/decentralized-exchange.html>`_. If the specified exchange
    cannot be completely fulfilled, it creates an Offer object for the remainder.
    Offers can be partially fulfilled.
     */

    public var takerGets: aAmount
     /*
    The amount and type of currency being provided by the sender of this
    transaction. This field is required.
    :meta hide-value:
      */

    public var takerPays: aAmount
      /*
    The amount and type of currency the sender of this transaction wants in
    exchange for the full ``taker_gets`` amount. This field is required.
    :meta hide-value:
       */

    public var expiration: Int?
       /*
    Time after which the offer is no longer active, in seconds since the
    Ripple Epoch.
        */

    public var offerSequence: Int?
        /*
    The Sequence number (or Ticket number) of a previous OfferCreate to cancel
    when placing this Offer.
    */
    
    public init(
        wallet: Wallet,
        takerGets: aAmount,
        takerPays: aAmount,
        expiration: Int? = nil,
        offerSequence: Int? = nil
    ) {
        
        self.takerGets = takerGets
        self.takerPays = takerPays
        self.expiration = expiration
        self.offerSequence = offerSequence
        
        // TODO: Write into using variables on model not fields. (Serialize Later in Tx)
        // Sets the fields for the tx
        var _fields: [String:Any] = [
            "TransactionType" : TransactionType.OfferCreate.rawValue,
            "TakerGets": takerGets,
            "TakerPays": takerPays,
        ]
        
        if let expiration = expiration {
            _fields["Expiration"] = expiration
        }
        
        if let offerSequence = offerSequence {
            _fields["OfferSequence"] = offerSequence
        }
        
        super.init(wallet: wallet, fields: _fields)
    }
}
