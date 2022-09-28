//
//  NFTokenCreateOffer.swift
//  AnyCodable
//
//  Created by Denis Angell on 3/20/22.
//

import Foundation

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/transactions/NFTokenCreateOffer.ts

// Transaction Flags for an NFTokenCreateOffer Transaction.
public enum NFTokenCreateOfferFlags: Int {
    /**
     If set, indicates that the offer is a sell offer.
     Otherwise, it is a buy offer.
     */
    case tfSellNFToken = 1
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

    public var amount: Amount
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

    enum CodingKeys: String, CodingKey {
        case nftokenId = "NFTokenID"
        //        case flags = "Flags"
        case amount = "Amount"
        case owner = "Owner"
        case expiration = "Expiration"
        case destination = "Destination"
    }

    public init(
        // Required
        nftokenId: String,
        amount: Amount,
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

    override public init(json: [String: AnyObject]) throws {
        let decoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(NFTokenCreateOffer.self, from: data)
        self.nftokenId = decoded.nftokenId
        self.amount = decoded.amount
        self.owner = decoded.owner
        self.expiration = decoded.expiration
        self.destination = decoded.destination
        try super.init(json: json)
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        nftokenId = try values.decode(String.self, forKey: .nftokenId)
        amount = try values.decode(Amount.self, forKey: .amount)
        owner = try values.decodeIfPresent(String.self, forKey: .owner)
        expiration = try values.decodeIfPresent(Int.self, forKey: .expiration)
        destination = try values.decodeIfPresent(String.self, forKey: .destination)
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

func validateNFTokenSellOfferCases(tx: [String: AnyObject]) throws {
    if tx["Owner"] != nil {
        throw ValidationError("NFTokenCreateOffer: Owner must not be present for sell offers")
    }
}

func validateNFTokenBuyOfferCases(tx: [String: AnyObject]) throws {
    if tx["Owner"] == nil {
        throw ValidationError("NFTokenCreateOffer: Owner must be present for buy offers")
    }

    if parseAmountValue(amount: tx["Amount"] as Any)! <= 0 {
        throw ValidationError("NFTokenCreateOffer: Amount must be greater than 0 for buy offers")
    }
}

/**
 Verify the form and type of an NFTokenCreateOffer at runtime.
 - parameters:
 - tx: An NFTokenCreateOffer Transaction.
 - throws:
 When the NFTokenCreateOffer is Malformed.
 */
public func validateNFTokenCreateOffer(tx: [String: AnyObject]) throws {
    try validateBaseTransaction(common: tx)

    if tx["Account"] as? String == tx["Owner"] as? String {
        throw ValidationError("NFTokenCreateOffer: Owner and Account must not be equal")
    }

    if tx["Account"] === tx["Destination"] {
        throw ValidationError("NFTokenCreateOffer: Destination and Account must not be equal")
    }

    if tx["NFTokenID"] == nil {
        throw ValidationError("NFTokenCreateOffer: missing field NFTokenID")
    }

    if !isAmount(amount: tx["Amount"] as Any) {
        throw ValidationError("NFTokenCreateOffer: invalid Amount")
    }

    if tx["Flags"] is Int && isFlagEnabled(
        flags: tx["Flags"] as! Int,
        checkFlag: NFTokenCreateOfferFlags.tfSellNFToken.rawValue
    ) {
        try validateNFTokenSellOfferCases(tx: tx)
    } else {
        try validateNFTokenBuyOfferCases(tx: tx)
    }
}
