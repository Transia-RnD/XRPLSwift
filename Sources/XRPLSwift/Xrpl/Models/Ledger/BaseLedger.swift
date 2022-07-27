//
//  File.swift
//  
//
//  Created by Denis Angell on 7/27/22.
//

import Foundation

//import { Transaction, TransactionMetadata } from '../transactions'

//import LedgerEntry from './LedgerEntry'

/**
 * A ledger is a block of transactions and shared state data. It has a unique
 * header that describes its contents using cryptographic hashes.
 *
 * @category Ledger Entries
 */
struct BaseLedger: Codable {
    /** The SHA-512Half of this ledger's state tree information. */
    var accountHash: String
    /** All the state information in this ledger. */
    var accountState: [LedgerEntry]
    /** A bit-map of flags relating to the closing of this ledger. */
    var closeFlags: Int
    /**
     * The approximate time this ledger version closed, as the number of seconds
     * since the Ripple Epoch of 2000-01-01 00:00:00. This value is rounded based
     * on the close_time_resolution.
     */
    var closeTime: Int
    /**
     * The approximate time this ledger was closed, in human-readable format.
     * Always uses the UTC time zone.
     */
    var closeTimeHuman: String
    /**
     * An integer in the range [2,120] indicating the maximum number of seconds
     * by which the close_time could be rounded.
     */
    var closeTimeResolution: Int
    /** Whether or not this ledger has been closed. */
    var aclosed: Bool
    /**
     * The SHA-512Half of this ledger version. This serves as a unique identifier
     * for this ledger and all its contents.
     */
    var ledgerHash: String
    /**
     * The ledger index of the ledger. Some API methods display this as a quoted
     * integer; some display it as a native JSON number.
     */
    var ledgerIndex: String
    /** The approximate time at which the previous ledger was closed. */
    var parentCloseTime: Int
    /**
     * Unique identifying hash of the ledger that came immediately before this
     * one.
     */
    var parentHash: String
    /** Total number of XRP drops in the network, as a quoted integer. */
    var totalCoins: String
    /** Hash of the transaction information included in this ledger, as hex. */
    var transactionHash: String
    /**
     * Transactions applied in this ledger version. By default, members are the
     * transactions' identifying Hash strings. If the request specified expand as
     * true, members are full representations of the transactions instead, in
     * either JSON or binary depending on whether the request specified binary
     * as true.
     */
    //    var transactions?: Array<Transaction & { metaData?: TransactionMetadata }>
    var transactions: [BaseTransaction]?
}
