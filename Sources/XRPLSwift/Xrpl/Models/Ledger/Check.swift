//
//  Check.swift
//
//
//  Created by Denis Angell on 7/30/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/ledger/Check.ts

import Foundation

/**
 A Check object describes a check, similar to a paper personal check, which
 can be cashed by its destination to get money from its sender.
 */
public class Check: BaseLedgerEntry {
    public var ledgerEntryType: String = "Check"
    /// The sender of the Check. Cashing the Check debits this address's balance.
    public var account: String
    /**
     The intended recipient of the Check. Only this address can cash the Check,
     using a CheckCash transaction.
     */
    public var destination: String
    /**
     A bit-map of boolean flags. No flags are defined for Checks, so this value
     is always 0.
     */
    public var flags: Int
    /**
     A hint indicating which page of the sender's owner directory links toty this
     object, in case the directory consists of multiple pages.
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
     The maximum amount of currency this Check can debit the sender. If the
     Check is successfully cashed, the destination is credited in the same
     currency for up to this amount.
     */
    public var sendMax: Amount
    /// The sequence number of the CheckCreate transaction that created this check.
    public var sequence: Int
    /**
     A hint indicating which page of the destination's owner directory links to
     this object, in case the directory consists of multiple pages.
     */
    public var destinationNode: String?
    /**
     An arbitrary tag to further specify the destination for this Check, such
     as a hosted recipient at the destination address.
     */
    public var destinationTag: Int?
    /// Indicates the time after which this Check is considered expired.
    public var expiration: Int?
    /**
     Arbitrary 256-bit hash provided by the sender as a specific reason or
     identifier for this Check.
     */
    public var invoiceId: String?
    /**
     An arbitrary tag to further specify the source for this Check, such as a
     hosted recipient at the sender's address.
     */
    public var sourceTag: Int?

    enum CodingKeys: String, CodingKey {
        case account = "Account"
        case destination = "Destination"
        case flags = "Flags"
        case ownerNode = "OwnerNode"
        case previousTxnId = "PreviousTxnID"
        case previousTxnLgrSeq = "PreviousTxnLgrSeq"
        case sendMax = "SendMax"
        case sequence = "Sequence"
        case destinationNode = "DestinationNode"
        case destinationTag = "DestinationTag"
        case expiration = "Expiration"
        case invoiceId = "InvoiceID"
        case sourceTag = "SourceTag"
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        account = try values.decode(String.self, forKey: .account)
        destination = try values.decode(String.self, forKey: .destination)
        flags = try values.decode(Int.self, forKey: .flags)
        ownerNode = try values.decode(String.self, forKey: .ownerNode)
        previousTxnId = try values.decode(String.self, forKey: .previousTxnId)
        previousTxnLgrSeq = try values.decode(Int.self, forKey: .previousTxnLgrSeq)
        sendMax = try values.decode(Amount.self, forKey: .sendMax)
        sequence = try values.decode(Int.self, forKey: .sequence)
        destinationNode = try? values.decode(String.self, forKey: .destinationNode)
        destinationTag = try? values.decode(Int.self, forKey: .destinationTag)
        expiration = try? values.decode(Int.self, forKey: .expiration)
        invoiceId = try? values.decode(String.self, forKey: .invoiceId)
        sourceTag = try? values.decode(Int.self, forKey: .sourceTag)
        try super.init(from: decoder)
    }
}
