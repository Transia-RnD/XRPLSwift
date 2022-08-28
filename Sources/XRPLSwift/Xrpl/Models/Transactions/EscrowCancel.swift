//
//  EscrowCancel.swift
//  AnyCodable
//
//  Created by Mitch Lang on 2/5/20.
//  Updated by Denis Angell on 7/31/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/transactions/escrowCancel.ts

import Foundation

public class EscrowCancel: BaseTransaction {

    /**
     Represents an `EscrowCancel <https://xrpl.org/escrowcancel.html>`_
     transaction, which returns escrowed XRP to the sender after the Escrow has
     expired.
     */
    public var owner: String

    /**
     Transaction sequence (or Ticket number) of the EscrowCreate transaction
     that created the Escrow. This field is required.
     
     */
    public var offerSequence: Int

    enum CodingKeys: String, CodingKey {
        case owner = "Owner"
        case offerSequence = "OfferSequence"
    }

    public init(owner: String, offerSequence: Int) {
        self.owner = owner
        self.offerSequence = offerSequence
        super.init(account: "", transactionType: "EscrowCancel")
    }

    public override init(json: [String: AnyObject]) throws {
        let decoder: JSONDecoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(EscrowCancel.self, from: data)
        self.owner = decoded.owner
        self.offerSequence = decoded.offerSequence
        try super.init(json: json)
    }

    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        owner = try values.decode(String.self, forKey: .owner)
        offerSequence = try values.decode(Int.self, forKey: .offerSequence)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try values.encode(owner, forKey: .owner)
        try values.encode(offerSequence, forKey: .offerSequence)
    }
}

/**
 * Verify the form and type of an EscrowCancel at runtime.
 *
 * @param tx - An EscrowCancel Transaction.
 * @throws When the EscrowCancel is Malformed.
 */
public func validateEscrowCancel(tx: [String: AnyObject]) throws {
    try validateBaseTransaction(common: tx)

    if tx["Owner"] == nil {
        throw ValidationError.decoding("EscrowCancel: missing Owner")
    }

    if !(tx["Owner"] is String) {
        throw ValidationError.decoding("EscrowCancel: Owner must be a string")
    }

    if tx["OfferSequence"] == nil {
        throw ValidationError.decoding("EscrowCancel: missing OfferSequence")
    }

    if !(tx["OfferSequence"] is Int) {
        throw ValidationError.decoding("EscrowCancel: OfferSequence must be a string")
    }
}
