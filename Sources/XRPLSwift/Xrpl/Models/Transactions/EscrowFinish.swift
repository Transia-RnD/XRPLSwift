//
//  EscrowFinish.swift
//  AnyCodable
//
//  Created by Mitch Lang on 2/5/20.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/transactions/escrowFinish.ts

import Foundation

public class EscrowFinish: BaseTransaction {
    
  /** Address of the source account that funded the held payment. */
    public let owner: String
  /**
   * Transaction sequence of EscrowCreate transaction that created the held.
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
    
    public init(owner: String, offerSequence: UInt32) {
        
        super.init(account: "", transactionType: "EscrowFinish")
    }
    
    enum CodingKeys: String, CodingKey {
        case owner = "Owner"
        case offerSequence = "OfferSequence"
        case condition = "Condition"
        case fulfillment = "Fulfillment"
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        owner = try values.decode(String.self, forKey: .owner)
        offerSequence = try values.decode(Int.self, forKey: .offerSequence)
        condition = try? values.decode(String.self, forKey: .condition)
        fulfillment = try? values.decode(String.self, forKey: .fulfillment)
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
