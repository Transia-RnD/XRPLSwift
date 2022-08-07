//
//  NFTokenCreateOffer.swift
//  AnyCodable
//
//  Created by Denis Angell on 3/20/22.
//

import Foundation

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/transactions/NFTokenCreateOffer.ts

// Transaction Flags for an NFTokenCreateOffer Transaction.
public enum NFTokenCreateOfferFlag: UInt32 {
    
    /**
    If set, indicates that the offer is a sell offer.
    Otherwise, it is a buy offer.
    */
    case tfSellToken = 1
}


/**
The NFTokenCreateOffer transaction creates either an offer to buy an
NFT the submitting account does not own, or an offer to sell an NFT
the submitting account does own.
*/
public class NFTokenCreateOffer: BaseTransaction {
    
    public var nftokenId: String
    /*
    Identifies the TokenID of the NFToken object that the
    offer references. This field is required.
    :meta hide-value:
    */

    public var amount: rAmount
    /*
    Indicates the amount expected or offered for the Token.
    The amount must be non-zero, except when this is a sell
    offer and the asset is XRP. This would indicate that the current
    owner of the token is giving it away free, either to anyone at all,
    or to the account identified by the Destination field. This field
    is required.
    :meta hide-value:
    */

    public var owner: String?
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

    public var destination: String?
    /*
    If present, indicates that this offer may only be
    accepted by the specified account. Attempts by other
    accounts to accept this offer MUST fail.
    */
    
    public init(
        // Required
        nftokenId: String,
        amount: rAmount,
        // Optional
//        flags: NFTokenCreateOfferFlag? = nil,
        owner: String? = nil,
        expiration: Int? = nil,
        destination: String? = nil
    ) {
        self.nftokenId = nftokenId
//        self.flags = flags
        self.amount = amount
        self.owner = owner
        self.expiration = expiration
        self.destination = destination
        super.init(account: "", transactionType: "NFTokenCreateOffer")
    }
    
    enum CodingKeys: String, CodingKey {
        case nftokenId = "NFTokenID"
//        case flags = "Flags"
        case amount = "Amount"
        case owner = "Owner"
        case expiration = "Expiration"
        case destination = "Destination"
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        nftokenId = try values.decode(String.self, forKey: .nftokenId)
        amount = try values.decode(rAmount.self, forKey: .amount)
        owner = try? values.decode(String.self, forKey: .owner)
        expiration = try? values.decode(Int.self, forKey: .expiration)
        destination = try? values.decode(String.self, forKey: .destination)
        try super.init(from: decoder)
    }
    
    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try values.encode(nftokenId, forKey: .nftokenId)
        try values.encode(amount, forKey: .amount)
        if let owner = owner { try values.encode(owner, forKey: .owner) }
        if let expiration = expiration { try values.encode(expiration, forKey: .expiration) }
        if let destination = destination { try values.encode(destination, forKey: .destination) }
    }
}