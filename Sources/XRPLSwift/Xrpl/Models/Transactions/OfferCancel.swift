//
//  OfferCancel.swift
//  AnyCodable
//
//  Created by Denis Angell on 3/20/22.
//

import Foundation

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/models/transactions/offer_cancel.py

public class OfferCancel: Transaction {
    
    /*
    Represents an `OfferCancel <https://xrpl.org/offercancel.html>`_ transaction,
    which removes an Offer object from the `decentralized exchange
    <https://xrpl.org/decentralized-exchange.html>`_.
    */

    public var offerSequence: Int
    /*
    The Sequence number (or Ticket number) of a previous OfferCreate
    transaction. If specified, cancel any Offer object in the ledger that was
    created by that transaction. It is not considered an error if the Offer
    specified does not exist.
    */
    
    public init(
        wallet: Wallet,
        offerSequence: Int
    ) {
        
        self.offerSequence = offerSequence
        
        // TODO: Write into using variables on model not fields. (Serialize Later in Tx)
        // Sets the fields for the tx
        let _fields: [String:Any] = [
            "TransactionType" : TransactionType.NFTokenCancelOffer.rawValue,
            "offerSequence": offerSequence
        ]
        
        super.init(wallet: wallet, fields: _fields)
    }
}
