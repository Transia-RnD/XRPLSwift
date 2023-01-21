//
//  LETicket.swift
//
//
//  Created by Denis Angell on 7/30/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/ledger/Ticket.ts

import Foundation

/**
 The Ticket object type represents a Ticket, which tracks an account sequence
 number that has been set aside for future use. You can create new tickets
 with a TicketCreate transaction.
 */
public class LETicket: BaseLedgerEntry {
    public var ledgerEntryType: String = "Ticket"
    /// The account that owns this Ticket.
    public var account: String
    /**
     A bit-map of Boolean flags enabled for this Ticket. Currently, there are
     no flags defined for Tickets.
     */
    public var flags: Int = 0
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
    /// The Sequence Number this Ticket sets aside.
    public var ticketSequence: Int

    enum CodingKeys: String, CodingKey {
        case account = "Account"
        case flags = "Flags"
        case ownerNode = "OwnerNode"
        case previousTxnId = "PreviousTxnID"
        case previousTxnLgrSeq = "PreviousTxnLgrSeq"
        case ticketSequence = "TicketSequence"
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        account = try values.decode(String.self, forKey: .account)
        flags = try values.decode(Int.self, forKey: .flags)
        ownerNode = try values.decode(String.self, forKey: .ownerNode)
        previousTxnId = try values.decode(String.self, forKey: .previousTxnId)
        previousTxnLgrSeq = try values.decode(Int.self, forKey: .previousTxnLgrSeq)
        ticketSequence = try values.decode(Int.self, forKey: .ticketSequence)
        try super.init(from: decoder)
    }

    override public init(json: [String: AnyObject]) throws {
        let decoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(LETicket.self, from: data)
        account = decoded.account
        flags = decoded.flags
        ownerNode = decoded.ownerNode
        previousTxnId = decoded.previousTxnId
        previousTxnLgrSeq = decoded.previousTxnLgrSeq
        ticketSequence = decoded.ticketSequence
        try super.init(json: json)
    }
}
