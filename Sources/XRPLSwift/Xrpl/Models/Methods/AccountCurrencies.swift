//
//  AccountCurrencies.swift
//
//
//  Created by Denis Angell on 7/30/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/methods/accountCurrencies.ts

import Foundation

/**
 The `account_currencies` command retrieves a list of currencies that an
 account can send or receive, based on its trust lines. Expects an
 {@link AccountCurrenciesResponse}.
 */
public class AccountCurrenciesRequest: BaseRequest {
    /// A unique identifier for the account, most commonly the account's address.
    public var account: String
    /// A 20-byte hex string for the ledger version to use.
    public var ledgerHash: String?
    /**
     The ledger index of the ledger to use, or a shortcut string to choose a
     ledger automatically.
     */
    public var ledgerIndex: LedgerIndex?
    /**
     If true, then the account field only accepts a public key or XRP Ledger
     address. Otherwise, account can be a secret or passphrase (not
     recommended). The default is false.
     */
    public var strict: Bool?

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
        ledgerIndex: LedgerIndex? = nil,
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

    override public init(_ json: [String: AnyObject]) throws {
        let decoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(AccountCurrenciesRequest.self, from: data)
        // Required
        self.account = decoded.account
        // Optional
        self.ledgerHash = decoded.ledgerHash
        self.ledgerIndex = decoded.ledgerIndex
        self.strict = decoded.strict
        try super.init(json)
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        account = try values.decode(String.self, forKey: .account)
        ledgerHash = try values.decodeIfPresent(String.self, forKey: .ledgerHash)
        ledgerIndex = try values.decodeIfPresent(LedgerIndex.self, forKey: .ledgerIndex)
        strict = try values.decodeIfPresent(Bool.self, forKey: .strict)
        try super.init(from: decoder)
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
 The expected response from an {@link AccountCurrenciesRequest}.
 */
public class AccountCurrenciesResponse: Codable {
    /**
     The identifying hash of the ledger version used to retrieve this data,
     as hex.
     */
    public var ledgerHash: String?
    /// The ledger index of the ledger version used to retrieve this data.
    public var ledgerIndex: Int
    /// Array of Currency Codes for currencies that this account can receive.
    public var receiveCurrencies: [String]
    /// Array of Currency Codes for currencies that this account can send.
    public var sendCurrencies: [String]
    /// If true, this data comes from a validated ledger.
    public var validated: Bool

    enum CodingKeys: String, CodingKey {
        case ledgerHash = "ledger_hash"
        case ledgerIndex = "ledger_index"
        case receiveCurrencies = "receive_currencies"
        case sendCurrencies = "send_currencies"
        case validated = "validated"
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ledgerHash = try values.decodeIfPresent(String.self, forKey: .ledgerHash)
        ledgerIndex = try values.decode(Int.self, forKey: .ledgerIndex)
        receiveCurrencies = try values.decode([String].self, forKey: .receiveCurrencies)
        sendCurrencies = try values.decode([String].self, forKey: .sendCurrencies)
        validated = try values.decode(Bool.self, forKey: .validated)
    }

    func toJson() throws -> [String: AnyObject] {
        let data = try JSONEncoder().encode(self)
        let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        return jsonResult as! [String: AnyObject]
    }
}
