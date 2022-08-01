//
//  AccountCurrencies.swift
//
//
//  Created by Denis Angell on 7/30/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/methods/accountCurrencies.ts

import Foundation

/**
 * The `account_currencies` command retrieves a list of currencies that an
 * account can send or receive, based on its trust lines. Expects an
 * {@link AccountCurrenciesResponse}.
 *
 * @category Requests
 */
public class AccountCurrenciesRequest: BaseRequest {
//    let command: String = "account_currencies"
    /** A unique identifier for the account, most commonly the account's address. */
    public let account: String
    /** A 20-byte hex string for the ledger version to use. */
    public let ledgerHash: String?
    /**
     * The ledger index of the ledger to use, or a shortcut string to choose a
     * ledger automatically.
     */
    public let ledgerIndex: rLedgerIndex?
    /**
     * If true, then the account field only accepts a public key or XRP Ledger
     * address. Otherwise, account can be a secret or passphrase (not
     * recommended). The default is false.
     */
    public let strict: Bool?
    
    enum CodingKeys: String, CodingKey {
        case account = "account"
        case ledgerHash = "ledger_hash"
        case ledgerIndex = "ledger_index"
        case strict = "strict"
    }
    
    public init(
        // Required
        account: String,
        // Base
        id: Int? = nil,
        apiVersion: Int? = nil,
        // Optional
        ledgerHash: String? = nil,
        ledgerIndex: rLedgerIndex? = nil,
        strict: Bool? = nil
    ) {
        // Required
        self.account = account
        // Optional
        self.ledgerHash = ledgerHash
        self.ledgerIndex = ledgerIndex
        self.strict = strict
        super.init(id: id, command: "account_currencies", apiVersion: apiVersion)
    }

    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try values.encode(account, forKey: .account)
        if let ledgerHash = ledgerHash { try values.encode(ledgerHash, forKey: .ledgerHash) }
        if let ledgerIndex = ledgerIndex { try values.encode(ledgerIndex, forKey: .ledgerIndex) }
        if let strict = strict { try values.encode(strict, forKey: .strict) }
    }
}

/**
 * The expected response from an {@link AccountCurrenciesRequest}.
 *
 * @category Responses
 */
public class AccountCurrenciesResponse: Codable {
    /**
     * The identifying hash of the ledger version used to retrieve this data,
     * as hex.
     */
    public let ledgerHash: String?
    /** The ledger index of the ledger version used to retrieve this data. */
    public let ledgerIndex: Int
    /** Array of Currency Codes for currencies that this account can receive. */
    public let receiveCurrencies: [String]
    /** Array of Currency Codes for currencies that this account can send. */
    public let sendCurrencies: [String]
    /** If true, this data comes from a validated ledger. */
    public let validated: Bool
    
    enum CodingKeys: String, CodingKey {
        case ledgerHash = "ledger_hash"
        case ledgerIndex = "ledger_index"
        case receiveCurrencies = "receive_currencies"
        case sendCurrencies = "send_currencies"
        case validated = "validated"
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ledgerHash = try values.decode(String.self, forKey: .ledgerHash)
        ledgerIndex = try values.decode(Int.self, forKey: .ledgerIndex)
        receiveCurrencies = try values.decode([String].self, forKey: .receiveCurrencies)
        sendCurrencies = try values.decode([String].self, forKey: .sendCurrencies)
        validated = try values.decode(Bool.self, forKey: .validated)
    }
}
