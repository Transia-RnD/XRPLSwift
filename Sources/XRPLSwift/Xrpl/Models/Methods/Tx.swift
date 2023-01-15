//
//  Tx.swift
//
//
//  Created by Denis Angell on 7/30/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/methods/tx.ts

import Foundation

/**
 The tx method retrieves information on a single transaction, by its
 identifying hash. Expects a response in the form of a {@link TxResponse}.
 */
public class TxRequest: BaseRequest {
    public var transaction: String
    /**
     If true, return transaction data and metadata as binary serialized to
     hexadecimal strings. If false, return transaction data and metadata as.
     JSON. The default is false.
     */
    public var binary: Bool?
    /**
     Use this with max_ledger to specify a range of up to 1000 ledger indexes,
     starting with this ledger (inclusive). If the server cannot find the
     transaction, it confirms whether it was able to search all the ledgers in
     this range.
     */
    public var minLedger: Int?
    /**
     Use this with min_ledger to specify a range of up to 1000 ledger indexes,
     ending with this ledger (inclusive). If the server cannot find the
     transaction, it confirms whether it was able to search all the ledgers in
     the requested range.
     */
    public var maxLedger: Int?

    enum CodingKeys: String, CodingKey {
        case transaction = "transaction"
        case binary = "binary"
        case minLedger = "min_ledger"
        case maxLedger = "max_ledger"
    }

    public init(
        // Required
        transaction: String,
        // Base
        id: Int? = nil,
        apiVersion: Int? = nil,
        // Optional
        binary: Bool? = nil,
        minLedger: Int? = nil,
        maxLedger: Int? = nil
    ) {
        // Required
        self.transaction = transaction
        // Optional
        self.binary = binary
        self.minLedger = minLedger
        self.maxLedger = maxLedger
        super.init(id: id, command: "tx", apiVersion: apiVersion)
    }

    override public init(_ json: [String: AnyObject]) throws {
        let decoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(TxRequest.self, from: data)
        // Required
        self.transaction = decoded.transaction
        // Optional
        self.binary = decoded.binary
        self.minLedger = decoded.minLedger
        self.maxLedger = decoded.maxLedger
        try super.init(json)
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        transaction = try values.decode(String.self, forKey: .transaction)
        binary = try values.decodeIfPresent(Bool.self, forKey: .binary)
        minLedger = try? values.decodeIfPresent(Int.self, forKey: .minLedger)
        maxLedger = try? values.decodeIfPresent(Int.self, forKey: .maxLedger)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try values.encode(transaction, forKey: .transaction)
        if let binary = binary { try values.encode(binary, forKey: .binary) }
        if let minLedger = minLedger { try values.encode(minLedger, forKey: .minLedger) }
        if let maxLedger = maxLedger { try values.encode(maxLedger, forKey: .maxLedger) }
    }
}

/**
 Response expected from a {@link TxRequest}.
 *
 @category Responses
 */
open class TxResponse: Codable {
    /// The SHA-512 hash of the transaction.
    public var hash: String
    /// The ledger index of the ledger that includes this transaction.
    public var ledgerIndex: Int?
    /// Transaction metadata, which describes the results of the transaction.
    //    public var meta?: TransactionMetadata | String
    public var meta: TransactionMetadata?
    /**
     If true, this data comes from a validated ledger version; if omitted or.
     Set to false, this data is not final.
     */
    public var validated: Bool?
    /**
     This number measures the number of seconds since the "Ripple Epoch" of January 1, 2000 (00:00 UTC)
     */
    public var date: Int?
    /**
     If true, the server was able to search all of the specified ledger
     versions, and the transaction was in none of them. If false, the server did
     not have all of the specified ledger versions available, so it is not sure.
     If one of them might contain the transaction.
     */
    public var searchedAll: Bool?

    enum CodingKeys: String, CodingKey {
        case hash = "hash"
        case ledgerIndex = "ledger_index"
        case meta = "meta"
        case validated = "validated"
        case date = "date"
        case searchedAll = "searchedAll"
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        hash = try values.decode(String.self, forKey: .hash)
        ledgerIndex = try? values.decode(Int.self, forKey: .ledgerIndex)
        meta = try? values.decode(TransactionMetadata.self, forKey: .meta)
        validated = try? values.decode(Bool.self, forKey: .validated)
        date = try? values.decode(Int.self, forKey: .date)
        searchedAll = try? values.decode(Bool.self, forKey: .searchedAll)
        //        try super.init(from: decoder)
    }

    func toJson() throws -> [String: AnyObject] {
        let data = try JSONEncoder().encode(self)
        let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        return jsonResult as? [String: AnyObject] ?? [:]
    }
}
