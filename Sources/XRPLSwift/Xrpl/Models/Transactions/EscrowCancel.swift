//
//  EscrowCancel.swift
//  AnyCodable
//
//  Created by Mitch Lang on 2/5/20.
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
    
    
    public init(owner: String, offerSequence: Int) {
        self.owner = owner
        self.offerSequence = offerSequence
        super.init(account: "", transactionType: "EscrowCancel")
    }
    
    enum CodingKeys: String, CodingKey {
        case owner = "owner"
        case offerSequence = "offerSequence"
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
