//
//  OfferCancel.swift
//  AnyCodable
//
//  Created by Denis Angell on 3/20/22.
//

import Foundation

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/transactions/offerCancel.ts

public class OfferCancel: BaseTransaction {
    /*
    Represents an `OfferCancel <https://xrpl.org/offercancel.html>`_ transaction,
    which removes an Offer object from the `decentralized exchange
    <https://xrpl.org/decentralized-exchange.html>`_.
    */

    public let offerSequence: Int
    /*
    The Sequence number (or Ticket number) of a previous OfferCreate
    transaction. If specified, cancel any Offer object in the ledger that was
    created by that transaction. It is not considered an error if the Offer
    specified does not exist.
    */

    enum CodingKeys: String, CodingKey {
        case offerSequence = "OfferSequence"
    }

    public init(offerSequence: Int) {
        self.offerSequence = offerSequence
        super.init(account: "", transactionType: "CancelOffer")
    }

    public override init(json: [String: AnyObject]) throws {
        let decoder: JSONDecoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(OfferCancel.self, from: data)
        self.offerSequence = decoded.offerSequence
        try super.init(json: json)
    }

    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        offerSequence = try values.decode(Int.self, forKey: .offerSequence)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try values.encode(offerSequence, forKey: .offerSequence)
    }
}

/**
 Verify the form and type of an OfferCancel at runtime.
 - parameters:
    - tx: An OfferCancel Transaction.
 - throws:
 When the OfferCancel is Malformed.
 */
public func validateOfferCancel(tx: [String: AnyObject]) throws {
    try validateBaseTransaction(common: tx)

    if tx["OfferSequence"] == nil {
        throw ValidationError("OfferCancel: missing field OfferSequence")
    }

    if !(tx["OfferSequence"] is Int) {
        throw ValidationError("OfferCancel: OfferSequence must be a Int")
    }
}
