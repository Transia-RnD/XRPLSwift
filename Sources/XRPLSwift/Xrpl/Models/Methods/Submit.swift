//
//  Submit.swift
//
//
//  Created by Denis Angell on 7/30/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/methods/submit.ts

import Foundation

/**
 * The submit method applies a transaction and sends it to the network to be
 * confirmed and included in future ledgers. Expects a response in the form of a
 * {@link SubmitResponse}.
 *
 * @category Requests
 */
public class SubmitRequest: BaseRequest {
//    public let command: String = "submit"
    /** The complete transaction in hex string format. */
    public let txBlob: String
    /**
     * If true, and the transaction fails locally, do not retry or relay the
     * transaction to other servers. The default is false.
     */
    public let failHard: Bool?

    public init(
        txBlob: String,
        failHard: Bool? = nil
    ) {
        // Required
        self.txBlob = txBlob
        // Optional
        self.failHard = failHard
        super.init(command: "submit")
    }

    enum CodingKeys: String, CodingKey {
        case txBlob = "tx_blob"
        case failHard = "fail_hard"
    }
    
    override public init(_ json: [String: AnyObject]) throws {
        let decoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(SubmitRequest.self, from: data)
        // Required
        self.txBlob = decoded.txBlob
        // Optional
        self.failHard = decoded.failHard
        try super.init(json)
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        txBlob = try values.decode(String.self, forKey: .txBlob)
        failHard = try values.decode(Bool.self, forKey: .failHard)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try values.encode(txBlob, forKey: .txBlob)
        if let failHard = failHard { try values.encode(failHard, forKey: .failHard) }
    }
}

/**
 * Response expected from a {@link SubmitRequest}.
 *
 * @category Responses
 */
open class SubmitResponse: Codable {
    /**
     * Text result code indicating the preliminary result of the transaction,
     * for example `tesSUCCESS`.
     */
    public let engineResult: String
    /** Numeric version of the result code. */
    public let engineResultCode: Int
    /** Human-readable explanation of the transaction's preliminary result. */
    public let engineResultMessage: String
    /** The complete transaction in hex string format. */
    public let txBlob: String
    /** The complete transaction in JSON format. */
    public let txJson: Transaction
    /**
     * The value true indicates that the transaction was applied, queued,
     * broadcast, or kept for later. The value `false` indicates that none of
     * those happened, so the transaction cannot possibly succeed as long as you
     * do not submit it again and have not already submitted it another time.
     */
    public let accepted: Bool
    /**
     * The next Sequence Number available for the sending account after all
     * pending and queued transactions.
     */
    public let accountSequenceAvailable: Int
    /**
     * The next Sequence number for the sending account after all transactions
     * that have been provisionally applied, but not transactions in the queue.
     */
    public let accountSequenceNext: Int
    /**
     * The value true indicates that this transaction was applied to the open
     * ledger. In this case, the transaction is likely, but not guaranteed, to
     * be validated in the next ledger version.
     */
    public let applied: Bool
    /**
     * The value true indicates this transaction was broadcast to peer servers
     * in the peer-to-peer XRP Ledger network.
     */
    public let broadcast: Bool
    /**
     * The value true indicates that the transaction was kept to be retried
     * later.
     */
    public let kept: Bool
    /**
     * The value true indicates the transaction was put in the Transaction
     * Queue, which means it is likely to be included in a future ledger
     * version.
     */
    public let queued: Bool
    /**
     * The current open ledger cost before processing this transaction
     * transactions with a lower cost are likely to be queued.
     */
    public let openLedgerCost: String
    /**
     * The ledger index of the newest validated ledger at the time of
     * submission. This provides a lower bound on the ledger versions that the
     * transaction can appear in as a result of this request.
     */
    public let validatedLedgerIndex: Int

    enum CodingKeys: String, CodingKey {
        case engineResult = "engine_result"
        case engineResultCode = "engine_result_code"
        case engineResultMessage = "engine_result_message"
        case txBlob = "tx_blob"
        case txJson = "tx_json"
        case accepted = "accepted"
        case accountSequenceAvailable = "account_sequence_available"
        case accountSequenceNext = "account_sequence_next"
        case applied = "applied"
        case broadcast = "broadcast"
        case kept = "kept"
        case queued = "queued"
        case openLedgerCost = "open_ledger_cost"
        case validatedLedgerIndex = "validated_ledger_index"
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        engineResult = try values.decode(String.self, forKey: .engineResult)
        engineResultCode = try values.decode(Int.self, forKey: .engineResultCode)
        engineResultMessage = try values.decode(String.self, forKey: .engineResultMessage)
        txBlob = try values.decode(String.self, forKey: .txBlob)
        txJson = try values.decode(Transaction.self, forKey: .txJson)
        accepted = try values.decode(Bool.self, forKey: .accepted)
        accountSequenceAvailable = try values.decode(Int.self, forKey: .accountSequenceAvailable)
        accountSequenceNext = try values.decode(Int.self, forKey: .accountSequenceNext)
        applied = try values.decode(Bool.self, forKey: .applied)
        broadcast = try values.decode(Bool.self, forKey: .broadcast)
        kept = try values.decode(Bool.self, forKey: .kept)
        queued = try values.decode(Bool.self, forKey: .queued)
        openLedgerCost = try values.decode(String.self, forKey: .openLedgerCost)
        validatedLedgerIndex = try values.decode(Int.self, forKey: .validatedLedgerIndex)
//        try super.init(from: decoder)
    }
    
    func toJson() throws -> [String: AnyObject] {
        let data = try JSONEncoder().encode(self)
        let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        return jsonResult as! [String: AnyObject]
    }
}
