//
//  File.swift
//
//
//  Created by Denis Angell on 7/27/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/methods/ledger.ts

import Foundation
import AnyCodable

public class LedgerRequest: BaseRequest {

    /** A 20-byte hex string for the ledger version to use. */
    var ledgerHash: String?
    /**
     * The ledger index of the ledger to use, or a shortcut string to choose a
     * ledger automatically.
     */
    var ledgerIndex: LedgerIndex?
    /**
     * Admin required If true, return full information on the entire ledger.
     * Ignored if you did not specify a ledger version. Defaults to false.
     */
    var full: Bool?
    /**
     * Admin required. If true, return information on accounts in the ledger.
     * Ignored if you did not specify a ledger version. Defaults to false.
     */
    var accounts: Bool?
    /**
     * If true, return information on transactions in the specified ledger
     * version. Defaults to false. Ignored if you did not specify a ledger
     * version.
     */
    var transactions: Bool?
    /**
     * Provide full JSON-formatted information for transaction/account
     * information instead of only hashes. Defaults to false. Ignored unless you
     * request transactions, accounts, or both.
     */
    var expand: Bool?
    /**
     * If true, include owner_funds field in the metadata of OfferCreate
     * transactions in the response. Defaults to false. Ignored unless
     * transactions are included and expand is true.
     */
    var ownerFunds: Bool?
    /**
     * If true, and transactions and expand are both also true, return
     * transaction information in binary format (hexadecimal string) instead of
     * JSON format.
     */
    var binary: Bool?
    /**
     * If true, and the command is requesting the current ledger, includes an
     * array of queued transactions in the results.
     */
    var queue: Bool?

    enum CodingKeys: String, CodingKey {
        case ledgerHash = "ledger_hash"
        case ledgerIndex = "ledger_index"
        case full = "full"
        case accounts = "accounts"
        case transactions = "transactions"
        case expand = "expand"
        case ownerFunds = "owner_funds"
        case binary = "binary"
        case queue = "queue"
    }

    init( id: Int? = nil, apiVersion: Int? = nil ) { super.init(id: id, command: "ledger", apiVersion: apiVersion) }

    init(
        id: Int? = nil,
        apiVersion: Int? = nil,
        ledgerHash: String? = nil,
        ledgerIndex: LedgerIndex? = nil,
        full: Bool? = nil,
        accounts: Bool? = nil,
        transactions: Bool? = nil,
        expand: Bool? = nil,
        ownerFunds: Bool? = nil,
        binary: Bool? = nil,
        queue: Bool? = nil
    ) {
        super.init(id: id, command: "ledger", apiVersion: apiVersion)
        self.ledgerHash = ledgerHash
        self.full = full
        self.accounts = accounts
        self.transactions = transactions
        self.expand = expand
        self.ownerFunds = ownerFunds
    }

    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}

class ModifiedMetadata: TransactionMetadata {
    var ownerFunds: String

    init(
        ownerFunds: String,
        affectedNodes: [Node]? = nil,
        transactionResult: String,
        transactionIndex: Int
    ) {
        self.ownerFunds = ownerFunds
        super.init(
            affectedNodes: affectedNodes,
            transactionResult: transactionResult,
            transactionIndex: transactionIndex
        )
    }

    required public init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}

struct ModifiedOfferCreateTransaction {
    var transaction: BaseTransaction
    var metadata: ModifiedMetadata
}

public enum LedgerQueueTx: Codable {
    case metadata(TransactionAndMetadata)
    //    case modified(ModifiedOfferCreateTransaction)
    case json([String: String])
    func get() -> Any? {
        switch self {
        case .metadata(let metadata):
            return metadata
            //        case .modified(let modified):
            //            return modified
        case .json(let json):
            return json
        }
    }

    func value() -> String? {
        switch self {
        case .metadata:
            return "metadata"
            //        case .modified:
            //            return "modified"
        case .json:
            return "json"
        }
    }
}

struct LedgerQueueData {
    var account: String
    var tx: LedgerQueueTx
    var retriesRemaining: Int
    var preflightResult: String
    var lastResult: String?
    var authChange: Bool?
    var fee: String?
    var feeLevel: String?
    var maxSpendDrops: String?
}

class BinaryLedger: BaseLedger {
    public var aaccountState: [LedgerEntry]?
    public var ttransactions: [BaseTransaction]?
}

enum LOQueueData: Codable {
    case data
    case string
}

public struct Result {
    var ledgerHash: String
    /** The Ledger Index of this ledger. */
    var ledgerIndex: Int
    /**
     * If true, this is a validated ledger version. If omitted or set to false,
     * this ledger's data is not final.
     */
    //    var queueData: Array<LedgerQueueData | string>?
    var queueData: [LedgerQueueData]?
    /**
     * Array of objects describing queued transactions, in the same order as
     * the queue. If the request specified expand as true, members contain full
     * representations of the transactions, in either JSON or binary depending
     * on whether the request specified binary as true.
     */
    var validated: Bool?
}

/**
 * Response expected from a {@link LedgerRequest}.
 *
 * @category Responses
 */
public class LedgerResponse: Codable {
    var ledger: BaseLedger

    var ledgerHash: String
    /** The Ledger Index of this ledger. */
    var ledgerIndex: Int
    /**
     * If true, this is a validated ledger version. If omitted or set to false,
     * this ledger's data is not final.
     */
    //    var queueData: Array<LedgerQueueData | string>?
//    var queueData: [rQueueData]?
    /**
     * Array of objects describing queued transactions, in the same order as
     * the queue. If the request specified expand as true, members contain full
     * representations of the transactions, in either JSON or binary depending
     * on whether the request specified binary as true.
     */
    var validated: Bool?

    enum CodingKeys: String, CodingKey {
        case ledger = "ledger"
        case ledgerHash = "ledger_hash"
        case ledgerIndex = "ledger_index"
        case validated = "validated"
//        case queueData = "queue_data"
    }

    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ledger = try values.decode(BaseLedger.self, forKey: .ledger)
        ledgerHash = try values.decode(String.self, forKey: .ledgerHash)
        ledgerIndex = try values.decode(Int.self, forKey: .ledgerIndex)
        validated = try values.decode(Bool.self, forKey: .validated)
//        queueData = try values.decode([rQueueData].self, forKey: .queueData)
//        try super.init(from: decoder)
    }
}
