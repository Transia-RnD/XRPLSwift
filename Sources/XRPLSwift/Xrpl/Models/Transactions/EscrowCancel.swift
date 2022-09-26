//
//  EscrowCancel.swift
//  AnyCodable
//
//  Created by Mitch Lang on 2/5/20.
//  Updated by Denis Angell on 7/31/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/transactions/escrowCancel.ts

import Foundation

/**
 Represents a [EscrowCancel](https://xrpl.org/escrowcancel.html) transaction,
 transaction, which returns escrowed XRP to the sender after the Escrow has
 expired.
 */
public class EscrowCancel: BaseTransaction {
    /// Address of the source account that funded the escrow payment.
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

    override public init(json: [String: AnyObject]) throws {
        let decoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(EscrowCancel.self, from: data)
        self.owner = decoded.owner
        self.offerSequence = decoded.offerSequence
        try super.init(json: json)
    }

    public required init(from decoder: Decoder) throws {
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
 Verify the form and type of an EscrowCancel at runtime.
 - parameters:
    - tx: An EscrowCancel Transaction.
 - throws:
 When the EscrowCancel is Malformed.
 */
public func validateEscrowCancel(tx: [String: AnyObject]) throws {
    try validateBaseTransaction(common: tx)

    if tx["Owner"] == nil {
        throw ValidationError("EscrowCancel: missing Owner")
    }

    if !(tx["Owner"] is String) {
        throw ValidationError("EscrowCancel: Owner must be a string")
    }

    if tx["OfferSequence"] == nil {
        throw ValidationError("EscrowCancel: missing OfferSequence")
    }

    if !(tx["OfferSequence"] is Int) {
        throw ValidationError("EscrowCancel: OfferSequence must be a string")
    }
}
