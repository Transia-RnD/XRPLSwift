//
//  TransactionEntry.swift
//
//
//  Created by Denis Angell on 7/30/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/methods/transactionEntry.ts

import Foundation

/**
 * The `transaction_entry` method retrieves information on a single transaction
 * from a specific ledger version. Expects a response in the form of a
 * {@link TransactionEntryResponse}.
 *
 * @category Requests
 */
public class TransactionEntryRequest: BaseRequest {
    //    let command: String = "transaction_entry"
    /** A 20-byte hex string for the ledger version to use. */
    public let ledgerHash: String?
    /**
     * The ledger index of the ledger to use, or a shortcut string to choose a
     * ledger automatically.
     */
    public let ledgerIndex: LedgerIndex?
    /** Unique hash of the transaction you are looking up. */
    public let txHash: String

    enum CodingKeys: String, CodingKey {
        case ledgerHash = "ledger_hash"
        case ledgerIndex = "ledger_index"
        case txHash = "tx_hash"
    }

    public init(
        // Required
        txHash: String,
        // Base
        id: Int? = nil,
        apiVersion: Int? = nil,
        // Optional
        ledgerHash: String? = nil,
        ledgerIndex: LedgerIndex? = nil
    ) {
        // Required
        self.txHash = txHash
        // Optional
        self.ledgerHash = ledgerHash
        self.ledgerIndex = ledgerIndex
        super.init(id: id, command: "transaction_entry", apiVersion: apiVersion)
    }

    required public init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }

    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try values.encode(txHash, forKey: .txHash)
        if let ledgerHash = ledgerHash { try values.encode(ledgerHash, forKey: .ledgerHash) }
        if let ledgerIndex = ledgerIndex { try values.encode(ledgerIndex, forKey: .ledgerIndex) }
    }
}

/**
 * Response expected from a {@link TransactionEntryRequest}.
 *
 * @category Responses
 */
public class TransactionEntryResponse: Codable {
    /**
     * The ledger index of the ledger version the transaction was found in;
     * this is the same as the one from the request.
     */
    public let ledgerIndex: Int
    /**
     * The identifying hash of the ledger version the transaction was found in;
     * this is the same as the one from the request.
     */
    public let ledgerHash: String
    /**
     * The transaction metadata, which shows the exact results of the
     * transaction in detail.
     */
    public let metadata: TransactionMetadata
    /** JSON representation of the Transaction object. */
//    public let txJson: Transaction + ResponseOnlyTxInfo
    public let txJson: Transaction

    enum CodingKeys: String, CodingKey {
        case ledgerHash = "ledger_hash"
        case ledgerIndex = "ledger_index"
        case metadata = "metadata"
        case txJson = "tx_json"
    }

    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ledgerIndex = try values.decode(Int.self, forKey: .ledgerIndex)
        ledgerHash = try values.decode(String.self, forKey: .ledgerHash)
        metadata = try values.decode(TransactionMetadata.self, forKey: .metadata)
        txJson = try values.decode(Transaction.self, forKey: .txJson)
//        try super.init(from: decoder)
    }
}
