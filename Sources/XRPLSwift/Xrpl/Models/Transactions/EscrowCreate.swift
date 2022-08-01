//
//  EscrowCreate.swift
//  AnyCodable
//
//  Created by Mitch Lang on 2/4/20.
//  Created by Denis Angell on 8/1/22.
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
    public let amount: rAmount
    
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
    
    
    public init(
        amount: rAmount,
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
    
    enum CodingKeys: String, CodingKey {
        case amount = "amount"
        case destination = "Destination"
        case destinationTag = "DestinationTag"
        case cancelAfter = "CancelAfter"
        case finishAfter = "FinishAfter"
        case condition = "condition"
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        amount = try values.decode(rAmount.self, forKey: .amount)
        destination = try values.decode(String.self, forKey: .destination)
        destinationTag = try? values.decode(Int.self, forKey: .destinationTag)
        cancelAfter = try? values.decode(Int.self, forKey: .cancelAfter)
        finishAfter = try? values.decode(Int.self, forKey: .finishAfter)
        condition = try? values.decode(String.self, forKey: .condition)
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
