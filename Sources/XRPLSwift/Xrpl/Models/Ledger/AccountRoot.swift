//
//  File.swift
//  
//
//  Created by Denis Angell on 7/30/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/ledger/AccountRoot.ts

import Foundation

/**
 Returns the X-Address representation of the data.
 - parameters:
 - classicAddress: The base58 encoding of the classic address.
 - tag: The destination tag.
 - isTest: Whether it is the test network or the main network.
 - returns:
 The X-Address representation of the data.
 - throws:
 XRPLAddressCodecException: If the classic address does not have enough bytes
 or the tag is invalid.
 */
public class AccountRoot: BaseLedger {
    public let ledgerEntryType: String = "AccountRoot"
    /** The identifying (classic) address of this account. */
    public let account: String
    /** The account's current XRP balance in drops, represented as a string. */
    public let balance: String
    /** A bit-map of boolean flags enabled for this account. */
    public let flags: Int
    /**
     * The number of objects this account owns in the ledger, which contributes
     * to its owner reserve.
     */
    public let ownerCount: Int
    /**
     * The identifying hash of the transaction that most recently modified this
     * object.
     */
    public let previousTxnId: String
    /**
     * The index of the ledger that contains the transaction that most recently
     * modified this object.
     */
    public let previousTxnLgrSeq: Int
    /** The sequence number of the next valid transaction for this account. */
    public let sequence: Int
    /**
     * The identifying hash of the transaction most recently sent by this
     * account. This field must be enabled to use the AccountTxnID transaction
     * field. To enable it, send an AccountSet transaction with the.
     * `asfAccountTxnID` flag enabled.
     */
    public let accountTxnId: String?
    /**
     * A domain associated with this account. In JSON, this is the hexadecimal
     * for the ASCII representation of the domain.
     */
    public let domain: String?
    /** The md5 hash of an email address. */
    public let emailHash: String?
    /**
     * A public key that may be used to send encrypted messages to this account
     * in JSON, uses hexadecimal.
     */
    public let messageKey: String?
    /**
     * The address of a key pair that can be used to sign transactions for this
     * account instead of the master key. Use a SetRegularKey transaction to
     * change this value.
     */
    public let regularKey: String?
    /**
     * How many Tickets this account owns in the ledger. This is updated
     * automatically to ensure that the account stays within the hard limit of 250.
     * Tickets at a time.
     */
    public let ticketCount: Int?
    /**
     * How many significant digits to use for exchange rates of Offers involving
     * currencies issued by this address. Valid values are 3 to 15, inclusive.
     */
    public let tickSize: Int?
    /**
     * A transfer fee to charge other users for sending currency issued by this
     * account to each other.
     */
    public let transferRate: Int?

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        account = try values.decode(String.self, forKey: .account)
        balance = try values.decode(String.self, forKey: .balance)
        flags = try values.decode(Int.self, forKey: .flags)
        ownerCount = try values.decode(Int.self, forKey: .ownerCount)
        previousTxnId = try values.decode(String.self, forKey: .previousTxnId)
        previousTxnLgrSeq = try values.decode(Int.self, forKey: .previousTxnLgrSeq)
        sequence = try values.decode(Int.self, forKey: .sequence)
        accountTxnId = try values.decode(String.self, forKey: .accountTxnId)
        domain = try values.decode(String.self, forKey: .domain)
        emailHash = try values.decode(String.self, forKey: .emailHash)
        messageKey = try values.decode(String.self, forKey: .messageKey)
        regularKey = try values.decode(String.self, forKey: .regularKey)
        ticketCount = try values.decode(Int.self, forKey: .ticketCount)
        tickSize = try values.decode(Int.self, forKey: .tickSize)
        transferRate = try values.decode(Int.self, forKey: .transferRate)
        try super.init(from: decoder)
    }

    enum CodingKeys: String, CodingKey {
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
}

enum AccountRootFlags: Int {
    /**
     * The account has used its free SetRegularKey transaction.
     */
    case lsfPasswordSpent = 0x00010000
    /**
     * Requires incoming payments to specify a Destination Tag.
     */
    case lsfRequireDestTag = 0x00020000
    /**
     * This account must individually approve other users for those users to hold this account's issued currencies.
     */
    case lsfRequireAuth = 0x00040000
    /**
     * Client applications should not send XRP to this account. Not enforced by rippled.
     */
    case lsfDisallowXRP = 0x00080000
    /**
     * Disallows use of the master key to sign transactions for this account.
     */
    case lsfDisableMaster = 0x00100000
    /**
     * This address cannot freeze trust lines connected to it. Once enabled, cannot be disabled.
     */
    case lsfNoFreeze = 0x00200000
    /**
     * All assets issued by this address are frozen.
     */
    case lsfGlobalFreeze = 0x00400000
    /**
     * Enable rippling on this addresses's trust lines by default. Required for issuing addresses; discouraged for others.
     */
    case lsfDefaultRipple = 0x00800000
    /**
     * This account can only receive funds from transactions it sends, and from preauthorized accounts.
     * (It has DepositAuth enabled.)
     */
    case lsfDepositAuth = 0x01000000
}
