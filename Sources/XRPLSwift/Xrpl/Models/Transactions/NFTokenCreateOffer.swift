//
//  NFTokenCreateOffer.swift
//  AnyCodable
//
//  Created by Denis Angell on 3/20/22.
//

import Foundation

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/models/transactions/nftoken_create_offer.py

public enum NFTokenCreateOfferFlag: UInt32 {
    // Transaction Flags for an NFTokenCreateOffer Transaction.
    
    case tfSellToken = 1
    /*
    If set, indicates that the offer is a sell offer.
    Otherwise, it is a buy offer.
    */
}

public class NFTokenCreateOffer: Transaction {
    
    /*
    The NFTokenCreateOffer transaction creates either an offer to buy an
    NFT the submitting account does not own, or an offer to sell an NFT
    the submitting account does own.
    */

    public var nftokenId: String
    /*
    Identifies the TokenID of the NFToken object that the
    offer references. This field is required.
    :meta hide-value:
    */

    public var amount: aAmount
    /*
    Indicates the amount expected or offered for the Token.
    The amount must be non-zero, except when this is a sell
    offer and the asset is XRP. This would indicate that the current
    owner of the token is giving it away free, either to anyone at all,
    or to the account identified by the Destination field. This field
    is required.
    :meta hide-value:
    */

    public var owner: Address?
    /*
    Indicates the AccountID of the account that owns the
    corresponding NFToken.
    If the offer is to buy a token, this field must be present
    and it must be different than Account (since an offer to
    buy a token one already holds is meaningless).
    If the offer is to sell a token, this field must not be
    present, as the owner is, implicitly, the same as Account
    (since an offer to sell a token one doesn't already hold
    is meaningless).
    */

    public var expiration: Int?
    /*
    Indicates the time after which the offer will no longer
    be valid. The value is the number of seconds since the
    Ripple Epoch.
    */

    public var destination: Address?
    /*
    If present, indicates that this offer may only be
    accepted by the specified account. Attempts by other
    accounts to accept this offer MUST fail.
    */
    
    public init(
        from wallet: Wallet,
        flags: NFTokenCreateOfferFlag? = nil,
        nftokenId: String,
        amount: aAmount,
        owner: Address? = nil,
        expiration: Int? = nil,
        destination: Address? = nil
    ) {
        self.nftokenId = nftokenId
//        self.flags = flags // TODO: Because flags are added later, still need access here
        self.amount = amount
        self.owner = owner
        self.expiration = expiration
        self.destination = destination
        
        // TODO: Write into using variables on model not fields. (Serialize Later in Tx)
        // Sets the fields for the tx
        var _fields: [String:Any] = [
            "TransactionType" : TransactionType.NFTokenCreateOffer.rawValue,
            "nftoken_id": nftokenId
        ]
        
        // TODO: idk if this is correct
        if let flags = flags {
            _fields["Flags"] = flags.rawValue
        }
        
        // TODO: Use Switchable Amount XRP/Currency
        if let amount = amount.drops {
            _fields["Amount"] = amount
        }
        
        if let owner = owner {
            _fields["Owner"] = owner.rAddress
        }
        
        if let expiration = expiration {
            _fields["Expiration"] = expiration
        }
        
        if let destination = destination {
            _fields["Destination"] = destination.rAddress
        }
        
        super.init(wallet: wallet, fields: _fields)
    }
}
