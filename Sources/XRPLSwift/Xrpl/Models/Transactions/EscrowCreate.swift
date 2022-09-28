//
//  EscrowCreate.swift
//  AnyCodable
//
//  Created by Mitch Lang on 2/4/20.
//  Updated by Denis Angell on 8/1/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/transactions/escrowCreate.ts

import Foundation

/**
 Represents an `EscrowCreate <https://xrpl.org/escrowcreate.html>`_
 transaction, which locks up XRP until a specific time or condition is met.
 */
public class EscrowCreate: BaseTransaction {
    /**
     Amount of XRP, in drops, to deduct from the sender's balance and set
     aside in escrow. This field is required.
     :meta hide-value:
     */
    public let amount: Amount

    /**
     The address that should receive the escrowed XRP when the time or
     condition is met. This field is required.
     :meta hide-value:
     */
    public let destination: String

    /**
     An arbitrary `destination tag
     <https://xrpl.org/source-and-destination-tags.html>`_ that
     identifies the reason for the Escrow, or a hosted recipient to pay.
     */
    public let destinationTag: Int?

    /**
     The time, in seconds since the Ripple Epoch, when this escrow expires.
     This value is immutable; the funds can only be returned the sender after
     this time.
     */
    public let cancelAfter: Int?

    /**
     The time, in seconds since the Ripple Epoch, when the escrowed XRP can
     be released to the recipient. This value is immutable; the funds cannot
     move until this time is reached.
     */
    public let finishAfter: Int?

    /**
     Hex value representing a `PREIMAGE-SHA-256 crypto-condition
     <https://tools.ietf.org/html/draft-thomas-crypto-conditions-04#section-8.1.>`_
     The funds can only be delivered to the recipient if this condition is
     fulfilled.
     */
    public let condition: String?

    enum CodingKeys: String, CodingKey {
        case amount = "Amount"
        case destination = "Destination"
        case destinationTag = "DestinationTag"
        case cancelAfter = "CancelAfter"
        case finishAfter = "FinishAfter"
        case condition = "Condition"
    }

    public init(
        amount: Amount,
        destination: String,
        destinationTag: Int? = nil,
        cancelAfter: Int? = nil,
        finishAfter: Int? = nil,
        condition: String? = nil
    ) {
        self.amount = amount
        self.destination = destination
        self.destinationTag = destinationTag
        self.cancelAfter = cancelAfter
        self.finishAfter = finishAfter
        self.condition = condition
        super.init(account: "", transactionType: "EscrowCreate")
    }

    override public init(json: [String: AnyObject]) throws {
        let decoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(EscrowCreate.self, from: data)
        self.amount = decoded.amount
        self.destination = decoded.destination
        self.destinationTag = decoded.destinationTag
        self.cancelAfter = decoded.cancelAfter
        self.finishAfter = decoded.finishAfter
        self.condition = decoded.condition
        try super.init(json: json)
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        amount = try values.decode(Amount.self, forKey: .amount)
        destination = try values.decode(String.self, forKey: .destination)
        destinationTag = try values.decodeIfPresent(Int.self, forKey: .destinationTag)
        cancelAfter = try values.decodeIfPresent(Int.self, forKey: .cancelAfter)
        finishAfter = try values.decodeIfPresent(Int.self, forKey: .finishAfter)
        condition = try values.decodeIfPresent(String.self, forKey: .condition)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try values.encode(amount, forKey: .amount)
        try values.encode(destination, forKey: .destination)
        if let destinationTag = destinationTag { try values.encode(destinationTag, forKey: .destinationTag) }
        if let cancelAfter = cancelAfter { try values.encode(cancelAfter, forKey: .cancelAfter) }
        if let finishAfter = finishAfter { try values.encode(finishAfter, forKey: .finishAfter) }
        if let condition = condition { try values.encode(condition, forKey: .condition) }
    }
}

/**
 Verify the form and type of an EscrowCreate at runtime.
 - parameters:
 - tx: An EscrowCreate Transaction.
 - throws:
 When the EscrowCreate is Malformed.
 */
public func validateEscrowCreate(tx: [String: AnyObject]) throws {
    try validateBaseTransaction(common: tx)

    if tx["Amount"] == nil {
        throw ValidationError("EscrowCreate: missing Amount")
    }

    if !(tx["Amount"] is String) {
        throw ValidationError("EscrowCreate: Amount must be a String")
    }

    if tx["Destination"] == nil {
        throw ValidationError("EscrowCreate: missing Destination")
    }

    if !(tx["Destination"] is String) {
        throw ValidationError("EscrowCreate: Destination must be a String")
    }

    if tx["CancelAfter"] == nil && tx["FinishAfter"] == nil {
        throw ValidationError("EscrowCreate: Either CancelAfter or FinishAfter must be specified")
    }

    if tx["FinishAfter"] == nil && tx["Condition"] == nil {
        throw ValidationError("EscrowCreate: Either Condition or FinishAfter must be specified")
    }

    if tx["CancelAfter"] != nil && !(tx["CancelAfter"] is Int) {
        throw ValidationError("EscrowCreate: CancelAfter must be a Int")
    }

    if tx["FinishAfter"] != nil && !(tx["FinishAfter"] is Int) {
        throw ValidationError("EscrowCreate: FinishAfter must be a Int")
    }

    if tx["Condition"] != nil && !(tx["Condition"] is String) {
        throw ValidationError("EscrowCreate: Condition must be a String")
    }

    if tx["DestinationTag"] != nil && !(tx["DestinationTag"] is Int) {
        throw ValidationError("EscrowCreate: DestinationTag must be a Int")
    }
}
