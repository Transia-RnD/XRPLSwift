//
//  LEEscrow.swift
//
//
//  Created by Denis Angell on 7/30/22.
//

import Foundation

/**
 The Escrow object type represents a held payment of XRP waiting to be
 executed or canceled.
 */
public class LEEscrow: BaseLedgerEntry {
    public var ledgerEntryType: String = "Escrow"
    /**
     The address of the owner (sender) of this held payment. This is the
     account that provided the XRP, and gets it back if the held payment is
     canceled.
     */
    public var account: String
    /**
     The destination address where the XRP is paid if the held payment is
     successful.
     */
    public var destination: String
    /// The amount of XRP, in drops, to be delivered by the held payment.
    public var amount: String
    /**
     A bit-map of boolean flags. No flags are defined for the Escrow type, so
     this value is always 0.
     */
    public var flags: Int
    /**
     A hint indicating which page of the owner directory links to this object,
     in case the directory consists of multiple pages.
     */
    public var ownerNode: String
    /**
     The identifying hash of the transaction that most recently modified this
     object.
     */
    public var previousTxnId: String
    /**
     The index of the ledger that contains the transaction that most recently
     modified this object.
     */
    public var previousTxnLgrSeq: Int
    /**
     A PREIMAGE-SHA-256 crypto-condition, as hexadecimal. If present, the
     EscrowFinish transaction must contain a fulfillment that satisfies this
     condition.
     */
    public var condition: String?
    /**
     The time after which this Escrow is considered expired.
     */
    public var cancelAfter: Int?
    /**
     The time, in seconds, since the Ripple Epoch, after which this held payment
     can be finished. Any EscrowFinish transaction before this time fails.
     */
    public var finishAfter: Int?
    /**
     An arbitrary tag to further specify the source for this held payment, such
     as a hosted recipient at the owner's address.
     */
    public var sourceTag: Int?
    /**
     An arbitrary tag to further specify the destination for this held payment,
     such as a hosted recipient at the destination address.
     */
    public var destinationTag: Int?
    /**
     A hint indicating which page of the destination's owner directory links to
     this object, in case the directory consists of multiple pages.
     */
    public var destinationNode: String?

    enum CodingKeys: String, CodingKey {
        case account = "Account"
        case destination = "Destination"
        case amount = "Amount"
        case flags = "Flags"
        case ownerNode = "OwnerNode"
        case previousTxnId = "PreviousTxnID"
        case previousTxnLgrSeq = "PreviousTxnLgrSeq"
        case condition = "Condition"
        case cancelAfter = "CancelAfter"
        case finishAfter = "FinishAfter"
        case sourceTag = "SourceTag"
        case destinationTag = "DestinationTag"
        case destinationNode = "DestinationNode"
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        account = try values.decode(String.self, forKey: .account)
        destination = try values.decode(String.self, forKey: .destination)
        amount = try values.decode(String.self, forKey: .amount)
        flags = try values.decode(Int.self, forKey: .flags)
        ownerNode = try values.decode(String.self, forKey: .ownerNode)
        previousTxnId = try values.decode(String.self, forKey: .previousTxnId)
        previousTxnLgrSeq = try values.decode(Int.self, forKey: .previousTxnLgrSeq)
        condition = try? values.decode(String.self, forKey: .condition)
        cancelAfter = try? values.decode(Int.self, forKey: .cancelAfter)
        finishAfter = try? values.decode(Int.self, forKey: .finishAfter)
        sourceTag = try? values.decode(Int.self, forKey: .sourceTag)
        destinationTag = try? values.decode(Int.self, forKey: .destinationTag)
        destinationNode = try? values.decode(String.self, forKey: .destinationNode)
        try super.init(from: decoder)
    }

    override public init(json: [String: AnyObject]) throws {
        let decoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(LEEscrow.self, from: data)
        account = decoded.account
        destination = decoded.destination
        amount = decoded.amount
        flags = decoded.flags
        ownerNode = decoded.ownerNode
        previousTxnId = decoded.previousTxnId
        previousTxnLgrSeq = decoded.previousTxnLgrSeq
        condition = decoded.condition
        cancelAfter = decoded.cancelAfter
        finishAfter = decoded.finishAfter
        sourceTag = decoded.sourceTag
        destinationTag = decoded.destinationTag
        destinationNode = decoded.destinationNode
        try super.init(json: json)
    }
}
