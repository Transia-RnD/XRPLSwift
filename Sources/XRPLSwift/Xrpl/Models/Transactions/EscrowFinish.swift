//
//  EscrowFinish.swift
//  AnyCodable
//
//  Created by Mitch Lang on 2/5/20.
//  Updated by Denis Angell on 8/7/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/transactions/escrowFinish.ts

import Foundation

public class EscrowFinish: BaseTransaction {

  /** Address of the source account that funded the held payment. */
    public let owner: String
  /**
   * Transaction sequence of EscrowFinish transaction that created the held.
   * payment to finish.
   */
    public let offerSequence: Int
  /**
   * Hex value matching the previously-supplied PREIMAGE-SHA-256.
   * crypto-condition of the held payment.
   */
    public let condition: String?
  /**
   * Hex value of the PREIMAGE-SHA-256 crypto-condition fulfillment matching.
   * the held payment's Condition.
   */
    public let fulfillment: String?

    enum CodingKeys: String, CodingKey {
        case owner = "Owner"
        case offerSequence = "OfferSequence"
        case condition = "Condition"
        case fulfillment = "Fulfillment"
    }

    public init(
        owner: String,
        offerSequence: Int,
        condition: String? = nil,
        fulfillment: String? = nil
    ) {
        self.owner = owner
        self.offerSequence = offerSequence
        self.condition = condition
        self.fulfillment = fulfillment
        super.init(account: "", transactionType: "EscrowFinish")
    }

    public override init(json: [String: AnyObject]) throws {
        let decoder: JSONDecoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(EscrowFinish.self, from: data)
        self.owner = decoded.owner
        self.offerSequence = decoded.offerSequence
        self.condition = decoded.condition
        self.fulfillment = decoded.fulfillment
        try super.init(json: json)
    }

    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        owner = try values.decode(String.self, forKey: .owner)
        offerSequence = try values.decode(Int.self, forKey: .offerSequence)
        condition = try values.decodeIfPresent(String.self, forKey: .condition)
        fulfillment = try values.decodeIfPresent(String.self, forKey: .fulfillment)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try values.encode(owner, forKey: .owner)
        try values.encode(offerSequence, forKey: .offerSequence)
        if let condition = condition { try values.encode(condition, forKey: .condition) }
        if let fulfillment = fulfillment { try values.encode(fulfillment, forKey: .fulfillment) }
    }
}

/**
 * Verify the form and type of an EscrowFinish at runtime.
 *
 * @param tx - An EscrowFinish Transaction.
 * @throws When the EscrowFinish is Malformed.
 */
public func validateEscrowFinish(tx: [String: AnyObject]) throws {
    try validateBaseTransaction(common: tx)

    if tx["Owner"] == nil {
        throw ValidationError.decoding("EscrowFinish: missing field Owner")
    }

    if !(tx["Owner"] is String) {
        throw ValidationError.decoding("EscrowFinish: Owner must be a String")
    }

    if tx["OfferSequence"] == nil {
        throw ValidationError.decoding("EscrowFinish: missing Destination")
    }

    if !(tx["OfferSequence"] is Int) {
        throw ValidationError.decoding("EscrowFinish: OfferSequence must be a Int")
    }

    if tx["Condition"] != nil && !(tx["Condition"] is String) {
        throw ValidationError.decoding("EscrowFinish: Condition must be a String")
    }

    if tx["Fulfillment"] != nil && !(tx["Fulfillment"] is String) {
        throw ValidationError.decoding("EscrowFinish: Fulfillment must be a String")
    }
}
