//
//  File.swift
//
//
//  Created by Denis Angell on 7/30/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/methods/submitMultisigned.ts

import Foundation

/**
 * The `submit_multisigned` command applies a multi-signed transaction and sends
 * it to the network to be included in future ledgers. Expects a response in the
 * form of a {@link SubmitMultisignedRequest}.
 *
 * @category Requests
 */
public class SubmitMultisignedRequest: BaseRequest {
//    let command: String = "submit_multisigned"
    /**
     * Transaction in JSON format with an array of Signers. To be successful, the
     * weights of the signatures must be equal or higher than the quorum of the.
     * {@link SignerList}.
     */
    public let txJson: Transaction
    /**
     * If true, and the transaction fails locally, do not retry or relay the
     * transaction to other servers.
     */
    public let failHard: Bool?

    enum CodingKeys: String, CodingKey {
        case txJson = "tx_json"
        case failHard = "fail_hard"
    }

    public init(
        // Required
        txJson: Transaction,
        // Base
        id: Int? = nil,
        apiVersion: Int? = nil,
        // Optional
        failHard: Bool? = nil
    ) {
        // Required
        self.txJson = txJson
        // Optional
        self.failHard = failHard
        super.init(id: id, command: "submit_multisigned", apiVersion: apiVersion)
    }

    required public init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }

    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try values.encode(txJson, forKey: .txJson)
        if let failHard = failHard { try values.encode(failHard, forKey: .failHard) }
    }
}

/**
 * Response expected from a {@link SubmitMultisignedRequest}.
 *
 * @category Responses
 */
public class SubmitMultisignedResponse: Codable {
    /**
     * Code indicating the preliminary result of the transaction, for example.
     * `tesSUCCESS` .
     */
    public let engineResult: String
    /**
     * Numeric code indicating the preliminary result of the transaction,
     * directly correlated to `engine_result`.
     */
    public let engineResultCode: Int
    /** Human-readable explanation of the preliminary transaction result. */
    public let engineResultMessage: String
    /** The complete transaction in hex string format. */
    public let txBlob: String
    /** The complete transaction in JSON format. */
//    public let tx_json: Transaction & { hash: String? }
    public let txJson: Transaction

    enum CodingKeys: String, CodingKey {
        case engineResult = "engine_result"
        case engineResultCode = "engine_result_code"
        case engineResultMessage = "engine_result_message"
        case txBlob = "tx_blob"
        case txJson = "tx_json"
    }

    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        engineResult = try values.decode(String.self, forKey: .engineResult)
        engineResultCode = try values.decode(Int.self, forKey: .engineResultCode)
        engineResultMessage = try values.decode(String.self, forKey: .engineResultMessage)
        txBlob = try values.decode(String.self, forKey: .txBlob)
        txJson = try values.decode(Transaction.self, forKey: .txJson)
        //        try super.init(from: decoder)
    }
}
