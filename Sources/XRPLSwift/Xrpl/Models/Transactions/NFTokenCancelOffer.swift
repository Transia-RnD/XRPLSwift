//
//  NFTokenCancelOffer.swift
//  AnyCodable
//
//  Created by Denis Angell on 3/20/22.
//

import Foundation

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/transactions/NFTokenCancelOffer.ts

/**
 The NFTokenCancelOffer transaction deletes existing NFTokenOffer objects.
 It is useful if you want to free up space on your account to lower your
 reserve requirement.
 The transaction can be executed by the account that originally created
 the NFTokenOffer, the account in the `Recipient` field of the NFTokenOffer
 (if present), or any account if the NFTokenOffer has an `Expiration` and
 the NFTokenOffer has already expired.
 */
public class NFTokenCancelOffer: BaseTransaction {
    /**
     An array of identifiers of NFTokenOffer objects that should be cancelled
     by this transaction.
     It is an error if an entry in this list points to an
     object that is not an NFTokenOffer object. It is not an
     error if an entry in this list points to an object that
     does not exist. This field is required.
     :meta hide-value:
     */
    public let nftokenOffers: [String]

    enum CodingKeys: String, CodingKey {
        case nftokenOffers = "NFTokenOffers"
    }

    public init(
        nftokenOffers: [String]
    ) {
        self.nftokenOffers = nftokenOffers
        super.init(account: "", transactionType: "NFTokenCancelOffer")
    }

    override public init(json: [String: AnyObject]) throws {
        let decoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(NFTokenCancelOffer.self, from: data)
        self.nftokenOffers = decoded.nftokenOffers
        try super.init(json: json)
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        nftokenOffers = try values.decode([String].self, forKey: .nftokenOffers)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try values.encode(nftokenOffers, forKey: .nftokenOffers)
    }
}

/**
 * Verify the form and type of an NFTokenCancelOffer at runtime.
 *
 * @param tx - An NFTokenCancelOffer Transaction.
 * @throws When the NFTokenCancelOffer is Malformed.
 */
public func validateNFTokenCancelOffer(tx: [String: AnyObject]) throws {
    try validateBaseTransaction(common: tx)

    guard let offers = tx["NFTokenOffers"] as? [String] else {
        throw ValidationError.decoding("NFTokenCancelOffer: missing field NFTokenOffers")
    }

    if offers.count < 1 {
        throw ValidationError.decoding("NFTokenCancelOffer: empty field NFTokenOffers")
    }
}
