//
//  NFTokenCancelOffer.swift
//  AnyCodable
//
//  Created by Denis Angell on 3/20/22.
//

import Foundation

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/models/transactions/nftoken_cancel_offer.py

public class NFTokenCancelOffer: Transaction {
    
    /*
    The NFTokenCancelOffer transaction deletes existing NFTokenOffer objects.
    It is useful if you want to free up space on your account to lower your
    reserve requirement.
    The transaction can be executed by the account that originally created
    the NFTokenOffer, the account in the `Recipient` field of the NFTokenOffer
    (if present), or any account if the NFTokenOffer has an `Expiration` and
    the NFTokenOffer has already expired.
    */

    public var nftokenOffers: [String]
    /*
    An array of identifiers of NFTokenOffer objects that should be cancelled
    by this transaction.
    It is an error if an entry in this list points to an
    object that is not an NFTokenOffer object. It is not an
    error if an entry in this list points to an object that
    does not exist. This field is required.
    :meta hide-value:
    */
    
    public init(
        from wallet: Wallet,
        nftokenOffers: [String]
    ) {
        self.nftokenOffers = nftokenOffers
        
        // TODO: Write into using variables on model not fields. (Serialize Later in Tx)
        // Sets the fields for the tx
        let _fields: [String:Any] = [
            "TransactionType" : TransactionType.NFTokenCancelOffer.rawValue,
            "NFTokenOffers": nftokenOffers
        ]
        
        super.init(wallet: wallet, fields: _fields)
    }
}
