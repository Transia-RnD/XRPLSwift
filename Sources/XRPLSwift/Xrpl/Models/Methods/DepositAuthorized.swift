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
    public let ledgerIndex: rLedgerIndex?
    
    enum CodingKeys: String, CodingKey {
        case sourceAccount = "sourceAccount"
        case destinationAccount = "destinationAccount"
        case ledgerHash = "ledgerHash"
        case ledgerIndex = "ledgerIndex"
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
        ledgerIndex: rLedgerIndex? = nil
    ) {
        // Required
        self.sourceAccount = sourceAccount
        self.destinationAccount = destinationAccount
        self.ledgerHash = ledgerHash
        self.ledgerIndex = ledgerIndex
        super.init(id: id, command: "channel_verify", apiVersion: apiVersion)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
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
    /** The source account specified in the request. */
    public let sourceAccount: String
    /** If true, the information comes from a validated ledger version. */
    public let validated: Bool?
    
    enum CodingKeys: String, CodingKey {
        case depositAuthorized = "depositAuthorized"
        case destinationAccount = "destinationAccount"
        case ledgerHash = "ledgerHash"
        case ledgerIndex = "ledgerIndex"
        case ledgerCurrentIndex = "ledgerCurrentIndex"
        case sourceAccount = "sourceAccount"
        case validated = "validated"
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        depositAuthorized = try values.decode(Bool.self, forKey: .depositAuthorized)
        destinationAccount = try values.decode(String.self, forKey: .destinationAccount)
        ledgerHash = try values.decode(String.self, forKey: .ledgerHash)
        ledgerIndex = try values.decode(Int.self, forKey: .ledgerIndex)
        ledgerCurrentIndex = try values.decode(Int.self, forKey: .ledgerCurrentIndex)
        sourceAccount = try values.decode(String.self, forKey: .sourceAccount)
        validated = try values.decode(Bool.self, forKey: .validated)
        //        try super.init(from: decoder)
    }
    
}
