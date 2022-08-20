//
//  File.swift
//  
//
//  Created by Denis Angell on 7/27/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/ledger/Ledger.ts

import Foundation

/**
 * A ledger is a block of transactions and shared state data. It has a unique
 * header that describes its contents using cryptographic hashes.
 *
 * @category Ledger Entries
 */
public class BaseLedger: Codable {
    /** The SHA-512Half of this ledger's state tree information. */
    public let accountHash: String
    /** A bit-map of flags relating to the closing of this ledger. */
    public var closeFlags: Int
    /**
     * The approximate time this ledger version closed, as the number of seconds
     * since the Ripple Epoch of 2000-01-01 00:00:00. This value is rounded based
     * on the close_time_resolution.
     */
    public var closeTime: Int
    /**
     * The approximate time this ledger was closed, in human-readable format.
     * Always uses the UTC time zone.
     */
    public var closeTimeHuman: String
    /**
     * An integer in the range [2,120] indicating the maximum number of seconds
     * by which the close_time could be rounded.
     */
    public var closeTimeResolution: Int
    /** Whether or not this ledger has been closed. */
    public var closed: Bool
    /**
     * The SHA-512Half of this ledger version. This serves as a unique identifier
     * for this ledger and all its contents.
     */
    public var ledgerHash: String
    /**
     * The ledger index of the ledger. Some API methods display this as a quoted
     * integer; some display it as a native JSON number.
     */
    public var ledgerIndex: String
    /** The approximate time at which the previous ledger was closed. */
    public var parentCloseTime: Int
    /**
     * Unique identifying hash of the ledger that came immediately before this
     * one.
     */
    public var parentHash: String
    /** Total number of XRP drops in the network, as a quoted integer. */
    public var totalCoins: String
    /** Hash of the transaction information included in this ledger, as hex. */
    public var transactionHash: String
    /**
     * Transactions applied in this ledger version. By default, members are the
     * transactions' identifying Hash strings. If the request specified expand as
     * true, members are full representations of the transactions instead, in
     * either JSON or binary depending on whether the request specified binary
     * as true.
     */
    //    var transactions?: Array<Transaction & { metaData?: TransactionMetadata }>
    public var transactions: [BaseTransaction]?
    /** All the state information in this ledger. */
    public var accountState: [LedgerEntry]?

    enum CodingKeys: String, CodingKey {
        case accountHash = "account_hash"
        case accountState = "account_state"
        case closeFlags = "close_flags"
        case closeTime = "close_time"
        case closeTimeHuman = "close_time_human"
        case closeTimeResolution = "close_time_resolution"
        case closed = "closed"
        case ledgerHash = "ledger_hash"
        case ledgerIndex = "ledger_index"
        case parentCloseTime = "parent_close_time"
        case parentHash = "parent_hash"
        case totalCoins = "total_coins"
        case transactionHash = "transaction_hash"
        case transactions = "transactions"
    }

//    required public init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        accountHash = try values.decode(String.self, forKey: .accountHash)
//        ledgerHash = try values.decode(String.self, forKey: .ledgerHash)
//        ledgerIndex = try values.decode(Int.self, forKey: .ledgerIndex)
//        validated = try values.decode(Bool.self, forKey: .validated)
//    }
}
