//
//  BaseLedger.swift
//
//
//  Created by Denis Angell on 7/27/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/ledger/Ledger.ts

import Foundation

/**
 A ledger is a block of transactions and shared state data. It has a unique
 header that describes its contents using cryptographic hashes.
 */
public class BaseLedger: Codable {
    /// The SHA-512Half of this ledger's state tree information.
    public var accountHash: String
    /// A bit-map of flags relating to the closing of this ledger.
    public var closeFlags: Int
    /**
     The approximate time this ledger version closed, as the number of seconds
     since the Ripple Epoch of 2000-01-01 00:00:00. This value is rounded based
     on the close_time_resolution.
     */
    public var closeTime: Int
    /**
     The approximate time this ledger was closed, in human-readable format.
     Always uses the UTC time zone.
     */
    public var closeTimeHuman: String
    /**
     An integer in the range [2,120] indicating the maximum number of seconds
     by which the close_time could be rounded.
     */
    public var closeTimeResolution: Int
    /// Whether or not this ledger has been closed.
    public var closed: Bool
    /**
     The SHA-512Half of this ledger version. This serves as a unique identifier
     for this ledger and all its contents.
     */
    public var ledgerHash: String
    /**
     The ledger index of the ledger. Some API methods display this as a quoted
     integer; some display it as a native JSON number.
     */
    public var ledgerIndex: String
    /// The approximate time at which the previous ledger was closed.
    public var parentCloseTime: Int
    /**
     Unique identifying hash of the ledger that came immediately before this
     one.
     */
    public var parentHash: String
    /// Total number of XRP drops in the network, as a quoted integer.
    public var totalCoins: String
    /// Hash of the transaction information included in this ledger, as hex.
    public var transactionHash: String
    /**
     Transactions applied in this ledger version. By default, members are the
     transactions' identifying Hash strings. If the request specified expand as
     true, members are full representations of the transactions instead, in
     either JSON or binary depending on whether the request specified binary
     as true.
     */
    // TODO: transactions need to append the metadata
    //    var transactions?: Array<Transaction & { metaData?: TransactionMetadata }>
    public var transactions: [BaseLedgerWrapper]?
    /// All the state information in this ledger.
    public var accountState: [LedgerEntry]?

    enum CodingKeys: String, CodingKey {
        case accountHash = "account_hash"
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
        case accountState = "account_state"
    }

    public init(json: [String: AnyObject]) throws {
        let decoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(BaseLedger.self, from: data)
        accountHash = decoded.accountHash
        closeFlags = decoded.closeFlags
        closeTime = decoded.closeTime
        closeTimeHuman = decoded.closeTimeHuman
        closeTimeResolution = decoded.closeTimeResolution
        closed = decoded.closed
        ledgerHash = decoded.ledgerHash
        ledgerIndex = decoded.ledgerIndex
        parentCloseTime = decoded.parentCloseTime
        parentHash = decoded.parentHash
        totalCoins = decoded.totalCoins
        transactionHash = decoded.transactionHash
        transactions = decoded.transactions
        accountState = decoded.accountState
    }
}

public enum BaseLedgerWrapper: Codable {
    case string(String)
    case transaction(BaseTransaction)
}
extension BaseLedgerWrapper {
    enum CodingError: Error {
        case decoding(String)
    }
    public init(from decoder: Decoder) throws {
        if let value = try? String(from: decoder) {
            self = .string(value)
            return
        }
        if let value = try? BaseTransaction(from: decoder) {
            self = .transaction(value)
            return
        }
        throw CodingError.decoding("Invalid BaseLedgerWrapper: BaseLedgerWrapper should be string or dict")
    }

    public init(_ json: [String: AnyObject]) throws {
        self = .transaction(try BaseTransaction(json: json))
    }

    public init(_ string: String) throws {
        self = .string(string)
    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .string(let string):
            try string.encode(to: encoder)
        case .transaction(let tx):
            try tx.encode(to: encoder)
        }
    }
}
