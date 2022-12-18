//
//  AccountRoot.swift
//
//
//  Created by Denis Angell on 7/30/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/ledger/AccountRoot.ts

import Foundation

public enum AccountRootFlags: Int, CaseIterable {
    /// The account has used its free SetRegularKey transaction.
    case lsfPasswordSpent = 0x00010000
    /// Requires incoming payments to specify a Destination Tag.
    case lsfRequireDestTag = 0x00020000
    /// This account must individually approve other users for those users to hold this account's issued currencies.
    case lsfRequireAuth = 0x00040000
    /// Client applications should not send XRP to this account. Not enforced by rippled.
    case lsfDisallowXRP = 0x00080000
    /// Disallows use of the master key to sign transactions for this account.
    case lsfDisableMaster = 0x00100000
    /// This address cannot freeze trust lines connected to it. Once enabled, cannot be disabled.
    case lsfNoFreeze = 0x00200000
    /// All assets issued by this address are frozen.
    case lsfGlobalFreeze = 0x00400000
    /// Enable rippling on this addresses's trust lines by default. Required for issuing addresses; discouraged for others.
    case lsfDefaultRipple = 0x00800000
    /// This account can only receive funds from transactions it sends, and from preauthorized accounts.(It has DepositAuth enabled.)
    case lsfDepositAuth = 0x01000000
}

/**
 The AccountRoot object type describes a single account, its settings, and XRP balance.
 */
public class AccountRoot: BaseLedgerEntry {
    public var ledgerEntryType: String = "AccountRoot"
    /// The identifying (classic) address of this account.
    public var account: String
    /// The account's current XRP balance in drops, represented as a string.
    public var balance: String
    /// A bit-map of boolean flags enabled for this account.
    public var flags: Int
    /**
     The number of objects this account owns in the ledger, which contributes
     to its owner reserve.
     */
    public var ownerCount: Int
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
    /// The sequence number of the next valid transaction for this account.
    public var sequence: Int
    /**
     The identifying hash of the transaction most recently sent by this
     account. This field must be enabled to use the AccountTxnID transaction
     field. To enable it, send an AccountSet transaction with the.
     `asfAccountTxnID` flag enabled.
     */
    public var accountTxnId: String?
    /**
     A domain associated with this account. In JSON, this is the hexadecimal
     for the ASCII representation of the domain.
     */
    public var domain: String?
    /// The md5 hash of an email address.
    public var emailHash: String?
    /**
     A public key that may be used to send encrypted messages to this account
     in JSON, uses hexadecimal.
     */
    public var messageKey: String?
    /**
     The address of a key pair that can be used to sign transactions for this
     account instead of the master key. Use a SetRegularKey transaction to
     change this value.
     */
    public var regularKey: String?
    /**
     How many Tickets this account owns in the ledger. This is updated
     automatically to ensure that the account stays within the hard limit of 250.
     Tickets at a time.
     */
    public var ticketCount: Int?
    /**
     How many significant digits to use for exchange rates of Offers involving
     currencies issued by this address. Valid values are 3 to 15, inclusive.
     */
    public var tickSize: Int?
    /**
     A transfer fee to charge other users for sending currency issued by this
     account to each other.
     */
    public var transferRate: Int?

    enum CodingKeys: String, CodingKey {
        case ledgerEntryType = "LedgerEntryType"
        case account = "Account"
        case balance = "Balance"
        case flags = "Flags"
        case ownerCount = "OwnerCount"
        case previousTxnId = "PreviousTxnID"
        case previousTxnLgrSeq = "PreviousTxnLgrSeq"
        case sequence = "Sequence"
        case accountTxnId = "AccountTxnId"
        case domain = "Domain"
        case emailHash = "EmailHash"
        case messageKey = "MessageKey"
        case regularKey = "RegularKey"
        case ticketCount = "TicketCount"
        case tickSize = "TickSize"
        case transferRate = "TransferRate"
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        account = try values.decode(String.self, forKey: .account)
        balance = try values.decode(String.self, forKey: .balance)
        flags = try values.decode(Int.self, forKey: .flags)
        ownerCount = try values.decode(Int.self, forKey: .ownerCount)
        previousTxnId = try values.decode(String.self, forKey: .previousTxnId)
        previousTxnLgrSeq = try values.decode(Int.self, forKey: .previousTxnLgrSeq)
        sequence = try values.decode(Int.self, forKey: .sequence)
        accountTxnId = try values.decodeIfPresent(String.self, forKey: .accountTxnId)
        domain = try values.decodeIfPresent(String.self, forKey: .domain)
        emailHash = try values.decodeIfPresent(String.self, forKey: .emailHash)
        messageKey = try values.decodeIfPresent(String.self, forKey: .messageKey)
        regularKey = try values.decodeIfPresent(String.self, forKey: .regularKey)
        ticketCount = try values.decodeIfPresent(Int.self, forKey: .ticketCount)
        tickSize = try values.decodeIfPresent(Int.self, forKey: .tickSize)
        transferRate = try values.decodeIfPresent(Int.self, forKey: .transferRate)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try values.encode(ledgerEntryType, forKey: .ledgerEntryType)
        try values.encode(account, forKey: .account)
        try values.encode(balance, forKey: .balance)
        try values.encode(flags, forKey: .flags)
        try values.encode(ownerCount, forKey: .ownerCount)
        try values.encode(previousTxnId, forKey: .previousTxnId)
        try values.encode(previousTxnLgrSeq, forKey: .previousTxnLgrSeq)
        try values.encode(sequence, forKey: .sequence)
        if let accountTxnId = accountTxnId { try values.encode(accountTxnId, forKey: .accountTxnId) }
        if let domain = domain { try values.encode(domain, forKey: .domain) }
        if let emailHash = emailHash { try values.encode(emailHash, forKey: .emailHash) }
        if let messageKey = messageKey { try values.encode(messageKey, forKey: .messageKey) }
        if let regularKey = regularKey { try values.encode(regularKey, forKey: .regularKey) }
        if let ticketCount = ticketCount { try values.encode(ticketCount, forKey: .ticketCount) }
        if let tickSize = tickSize { try values.encode(tickSize, forKey: .tickSize) }
        if let transferRate = transferRate { try values.encode(transferRate, forKey: .transferRate) }
    }

    func toJson() throws -> [String: AnyObject] {
        let data = try JSONEncoder().encode(self)
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        guard let jsonResult = jsonObject as? [String: AnyObject] else {
            throw BinaryCodecErrors.unknownError(error: "Invalid JSON Cast")
        }
        return jsonResult
    }
}
