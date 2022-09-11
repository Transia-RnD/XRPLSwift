//
//  DepositAuthorized.swift
//
//
//  Created by Denis Angell on 7/30/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/methods/depositAuthorized.ts

import Foundation

/**
 * The deposit_authorized command indicates whether one account is authorized to
 * send payments directly to another. Expects a response in the form of a {@link
 * DepositAuthorizedResponse}.
 *
 * @category Requests
 */
public class DepositAuthorizedRequest: BaseRequest {
    //    public let command: String = "deposit_authorized"
    /** The sender of a possible payment. */
    public let sourceAccount: String
    /** The recipient of a possible payment. */
    public let destinationAccount: String
    /** A 20-byte hex string for the ledger version to use. */
    public let ledgerHash: String?
    /**
     * The ledger index of the ledger to use, or a shortcut string to choose a
     * ledger automatically.
     */
    public let ledgerIndex: LedgerIndex?

    enum CodingKeys: String, CodingKey {
        case sourceAccount = "source_account"
        case destinationAccount = "destination_account"
        case ledgerHash = "ledger_hash"
        case ledgerIndex = "ledger_index"
    }

    public init(
        // Required
        sourceAccount: String,
        destinationAccount: String,
        // Base
        id: Int? = nil,
        apiVersion: Int? = nil,
        // Optional
        ledgerHash: String? = nil,
        ledgerIndex: LedgerIndex? = nil
    ) {
        // Required
        self.sourceAccount = sourceAccount
        self.destinationAccount = destinationAccount
        // Optional
        self.ledgerHash = ledgerHash
        self.ledgerIndex = ledgerIndex
        super.init(id: id, command: "deposit_authorized", apiVersion: apiVersion)
    }

    override public init(_ json: [String: AnyObject]) throws {
        let decoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(DepositAuthorizedRequest.self, from: data)
        // Required
        self.sourceAccount = decoded.sourceAccount
        self.destinationAccount = decoded.destinationAccount
        // Optional
        self.ledgerHash = decoded.ledgerHash
        self.ledgerIndex = decoded.ledgerIndex
        try super.init(json)
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        sourceAccount = try values.decode(String.self, forKey: .sourceAccount)
        destinationAccount = try values.decode(String.self, forKey: .destinationAccount)
        ledgerHash = try values.decodeIfPresent(String.self, forKey: .ledgerHash)
        ledgerIndex = try values.decodeIfPresent(LedgerIndex.self, forKey: .ledgerIndex)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try values.encode(sourceAccount, forKey: .sourceAccount)
        try values.encode(destinationAccount, forKey: .destinationAccount)
        if let ledgerHash = ledgerHash { try values.encode(ledgerHash, forKey: .ledgerHash) }
        if let ledgerIndex = ledgerIndex { try values.encode(ledgerIndex, forKey: .ledgerIndex) }
    }
}

/**
 * Expected response from a {@link DepositAuthorizedRequest}.
 *
 * @category Responses
 */
public class DepositAuthorizedResponse: Codable {
    /**
     * Whether the specified source account is authorized to send payments
     * directly to the destination account. If true, either the destination
     * account does not require Deposit Authorization or the source account is
     * preauthorized.
     */
    public let depositAuthorized: Bool
    /** The source account specified in the request. */
    public let sourceAccount: String
    /** The destination account specified in the request. */
    public let destinationAccount: String
    /**
     * The identifying hash of the ledger that was used to generate this
     * Response.
     */
    public let ledgerHash: String?
    /**
     * The ledger index of the ledger version that was used to generate this
     * Response.
     */
    public let ledgerIndex: Int?
    /**
     * The ledger index of the current in-progress ledger version, which was
     * used to generate this response.
     */
    public let ledgerCurrentIndex: Int?
    /** If true, the information comes from a validated ledger version. */
    public let validated: Bool?

    enum CodingKeys: String, CodingKey {
        case depositAuthorized = "deposit_authorized"
        case sourceAccount = "source_account"
        case destinationAccount = "destination_account"
        case ledgerHash = "ledger_hash"
        case ledgerIndex = "ledger_index"
        case ledgerCurrentIndex = "ledger_current_index"
        case validated = "validated"
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        depositAuthorized = try values.decode(Bool.self, forKey: .depositAuthorized)
        sourceAccount = try values.decode(String.self, forKey: .sourceAccount)
        destinationAccount = try values.decode(String.self, forKey: .destinationAccount)
        ledgerHash = try values.decodeIfPresent(String.self, forKey: .ledgerHash)
        ledgerIndex = try values.decodeIfPresent(Int.self, forKey: .ledgerIndex)
        ledgerCurrentIndex = try values.decodeIfPresent(Int.self, forKey: .ledgerCurrentIndex)
        validated = try values.decodeIfPresent(Bool.self, forKey: .validated)
        //        try super.init(from: decoder)
    }

    func toJson() throws -> [String: AnyObject] {
        let data = try JSONEncoder().encode(self)
        let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        return jsonResult as! [String: AnyObject]
    }
}
