//
//  File.swift
//
//
//  Created by Denis Angell on 7/27/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/methods/ledger.ts

import AnyCodable
import Foundation

public class LedgerRequest: BaseRequest {
    /// A 20-byte hex string for the ledger version to use.
    public var ledgerHash: String?
    /**
     The ledger index of the ledger to use, or a shortcut string to choose a
     ledger automatically.
     */
    public var ledgerIndex: LedgerIndex?
    /**
     Admin required If true, return full information on the entire ledger.
     Ignored if you did not specify a ledger version. Defaults to false.
     */
    public var full: Bool?
    /**
     Admin required. If true, return information on accounts in the ledger.
     Ignored if you did not specify a ledger version. Defaults to false.
     */
    public var accounts: Bool?
    /**
     If true, return information on transactions in the specified ledger
     version. Defaults to false. Ignored if you did not specify a ledger
     version.
     */
    public var transactions: Bool?
    /**
     Provide full JSON-formatted information for transaction/account
     information instead of only hashes. Defaults to false. Ignored unless you
     request transactions, accounts, or both.
     */
    public var expand: Bool?
    /**
     If true, include owner_funds field in the metadata of OfferCreate
     transactions in the response. Defaults to false. Ignored unless
     transactions are included and expand is true.
     */
    public var ownerFunds: Bool?
    /**
     If true, and transactions and expand are both also true, return
     transaction information in binary format (hexadecimal string) instead of
     JSON format.
     */
    public var binary: Bool?
    /**
     If true, and the command is requesting the current ledger, includes an
     array of queued transactions in the results.
     */
    public var queue: Bool?

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
        self.ledgerHash = ledgerHash
        self.ledgerIndex = ledgerIndex
        self.full = full
        self.accounts = accounts
        self.transactions = transactions
        self.expand = expand
        self.ownerFunds = ownerFunds
        self.binary = binary
        self.queue = queue
        super.init(id: id, command: "ledger", apiVersion: apiVersion)
    }

    override public init(_ json: [String: AnyObject]) throws {
        let decoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(LedgerRequest.self, from: data)
        self.ledgerHash = decoded.ledgerHash
        self.ledgerIndex = decoded.ledgerIndex
        self.full = decoded.full
        self.accounts = decoded.accounts
        self.transactions = decoded.transactions
        self.expand = decoded.expand
        self.ownerFunds = decoded.ownerFunds
        self.binary = decoded.binary
        self.queue = decoded.queue
        try super.init(json)
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ledgerHash = try values.decodeIfPresent(String.self, forKey: .ledgerHash)
        ledgerIndex = try values.decodeIfPresent(LedgerIndex.self, forKey: .ledgerIndex)
        full = try values.decodeIfPresent(Bool.self, forKey: .full)
        accounts = try? values.decodeIfPresent(Bool.self, forKey: .accounts)
        transactions = try? values.decodeIfPresent(Bool.self, forKey: .transactions)
        expand = try? values.decodeIfPresent(Bool.self, forKey: .expand)
        ownerFunds = try? values.decodeIfPresent(Bool.self, forKey: .ownerFunds)
        binary = try? values.decodeIfPresent(Bool.self, forKey: .binary)
        queue = try? values.decodeIfPresent(Bool.self, forKey: .queue)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        if let ledgerHash = ledgerHash { try values.encode(ledgerHash, forKey: .ledgerHash) }
        if let ledgerIndex = ledgerIndex { try values.encode(ledgerIndex, forKey: .ledgerIndex) }
        if let full = full { try values.encode(full, forKey: .full) }
        if let accounts = accounts { try values.encode(accounts, forKey: .accounts) }
        if let transactions = transactions { try values.encode(transactions, forKey: .transactions) }
        if let expand = expand { try values.encode(expand, forKey: .expand) }
        if let ownerFunds = ownerFunds { try values.encode(ownerFunds, forKey: .ownerFunds) }
        if let binary = binary { try values.encode(binary, forKey: .binary) }
        if let queue = queue { try values.encode(queue, forKey: .queue) }
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

    public required init(from decoder: Decoder) throws {
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
    var aaccountState: [LedgerEntry]?
    var ttransactions: [BaseTransaction]?
}

enum LOQueueData: Codable {
    case data
    case string
}

public struct Result {
    var ledgerHash: String
    /// The Ledger Index of this ledger.
    var ledgerIndex: Int
    /**
     If true, this is a validated ledger version. If omitted or set to false,
     this ledger's data is not final.
     */
    var queueData: [LedgerQueueData]?
    //    var queueData: Array<LedgerQueueData | string>?
    /**
     Array of objects describing queued transactions, in the same order as
     the queue. If the request specified expand as true, members contain full
     representations of the transactions, in either JSON or binary depending
     on whether the request specified binary as true.
     */
    var validated: Bool?
}

/**
 Response expected from a {@link LedgerRequest}.
 */
public class LedgerResponse: Codable {
    var ledger: BaseLedger
    var ledgerHash: String
    /// The Ledger Index of this ledger.
    var ledgerIndex: Int
    /**
     If true, this is a validated ledger version. If omitted or set to false,
     this ledger's data is not final.
     */
    //    var queueData: Array<LedgerQueueData | string>?
    //    var queueData: [rQueueData]?
    /**
     Array of objects describing queued transactions, in the same order as
     the queue. If the request specified expand as true, members contain full
     representations of the transactions, in either JSON or binary depending
     on whether the request specified binary as true.
     */
    var validated: Bool?

    enum CodingKeys: String, CodingKey {
        case ledger = "ledger"
        case ledgerHash = "ledger_hash"
        case ledgerIndex = "ledger_index"
        case validated = "validated"
        //        case queueData = "queue_data"
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ledger = try values.decode(BaseLedger.self, forKey: .ledger)
        ledgerHash = try values.decode(String.self, forKey: .ledgerHash)
        ledgerIndex = try values.decode(Int.self, forKey: .ledgerIndex)
        validated = try values.decodeIfPresent(Bool.self, forKey: .validated)
        //        queueData = try values.decode([rQueueData].self, forKey: .queueData)
        //        try super.init(from: decoder)
    }

    func toJson() throws -> [String: AnyObject] {
        let data = try JSONEncoder().encode(self)
        let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        return jsonResult as! [String: AnyObject]
    }
}
