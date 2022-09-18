//
//  NoRippleCheck.swift
//
//
//  Created by Denis Angell on 7/30/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/methods/norippleCheck.ts

import Foundation

/**
 The `noripple_check` command provides a quick way to check the status of th
 default ripple field for an account and the No Ripple flag of its trust
 lines, compared with the recommended settings. Expects a response in the form
 of an {@link NoRippleCheckResponse}.
 *
 @example
 ```ts
 const noRipple: NoRippleCheckRequest = {
   "id": 0,
   "command": "noripple_check",
   "account": "r9cZA1mLK5R5Am25ArfXFmqgNwjZgnfk59",
    "role": "gateway",
   "ledger_index": "current",
   "limit": 2,
   "transactions": true
 }
 ```
 */
public class NoRippleCheckRequest: BaseRequest {
    /// A unique identifier for the account, most commonly the account's address.
    public let account: String
    /**
     Whether the address refers to a gateway or user. Recommendations depend on
     the role of the account. Issuers must have Default Ripple enabled and must
     disable No Ripple on all trust lines. Users should have Default Ripple
     disabled, and should enable No Ripple on all trust lines.
     */
    //     public let role: "gateway" | "user"
    public let role: String
    /**
     If true, include an array of suggested transactions, as JSON objects,
     that you can sign and submit to fix the problems. Defaults to false.
     */
    public let transactions: Bool?
    /**
     The maximum number of trust line problems to include in the results.
     Defaults to 300.
     */
    public let limit: Int?
    /// A 20-byte hex string for the ledger version to use.
    public let ledgerHash: String?
    /**
     The ledger index of the ledger to use, or a shortcut string to choose a
     ledger automatically.
     */
    public let ledgerIndex: LedgerIndex?

    enum CodingKeys: String, CodingKey {
        case account = "account"
        case role = "role"
        case transactions = "transactions"
        case limit = "limit"
        case ledgerHash = "ledger_hash"
        case ledgerIndex = "ledger_index"
    }

    public init(
        // Required
        account: String,
        role: String,
        // Base
        id: Int? = nil,
        apiVersion: Int? = nil,
        // Optional
        transactions: Bool? = nil,
        limit: Int? = nil,
        ledgerHash: String? = nil,
        ledgerIndex: LedgerIndex? = nil
    ) {
        // Required
        self.account = account
        self.role = role
        // Optional
        self.transactions = transactions
        self.limit = limit
        self.ledgerHash = ledgerHash
        self.ledgerIndex = ledgerIndex
        super.init(id: id, command: "noripple_check", apiVersion: apiVersion)
    }

    override public init(_ json: [String: AnyObject]) throws {
        let decoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(NoRippleCheckRequest.self, from: data)
        // Required
        self.account = decoded.account
        self.role = decoded.role
        // Optional
        self.transactions = decoded.transactions
        self.limit = decoded.limit
        self.ledgerHash = decoded.ledgerHash
        self.ledgerIndex = decoded.ledgerIndex
        try super.init(json)
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        account = try values.decode(String.self, forKey: .account)
        role = try values.decode(String.self, forKey: .role)
        transactions = try values.decodeIfPresent(Bool.self, forKey: .transactions)
        limit = try values.decodeIfPresent(Int.self, forKey: .limit)
        ledgerHash = try values.decodeIfPresent(String.self, forKey: .ledgerHash)
        ledgerIndex = try values.decodeIfPresent(LedgerIndex.self, forKey: .ledgerIndex)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try values.encode(account, forKey: .account)
        try values.encode(role, forKey: .role)
        if let transactions = transactions { try values.encode(transactions, forKey: .transactions) }
        if let limit = limit { try values.encode(limit, forKey: .limit) }
        if let ledgerHash = ledgerHash { try values.encode(ledgerHash, forKey: .ledgerHash) }
        if let ledgerIndex = ledgerIndex { try values.encode(ledgerIndex, forKey: .ledgerIndex) }
    }
}

/**
 Response expected by a {@link NoRippleCheckRequest}.
 */
public class NoRippleCheckResponse: Codable {
    /// The ledger index of the ledger used to calculate these results.
    public let ledgerCurrentIndex: Int
    /**
     Array of strings with human-readable descriptions of the problems.
     This includes up to one entry if the account's Default Ripple setting is
     not as recommended, plus up to limit entries for trust lines whose no
     ripple setting is not as recommended.
     */
    public let problems: [String]
    /**
     If the request specified transactions as true, this is an array of JSON
     objects, each of which is the JSON form of a transaction that should fix
     one of the described problems. The length of this array is the same as
     the problems array, and each entry is intended to fix the problem
     described at the same index into that array.
     */
    public let transactions: [Transaction]

    enum CodingKeys: String, CodingKey {
        case ledgerCurrentIndex = "ledger_current_index"
        case problems = "problems"
        case transactions = "transactions"
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ledgerCurrentIndex = try values.decode(Int.self, forKey: .ledgerCurrentIndex)
        problems = try values.decode([String].self, forKey: .problems)
        transactions = try values.decode([Transaction].self, forKey: .transactions)
        //        try super.init(from: decoder)
    }

    func toJson() throws -> [String: AnyObject] {
        let data = try JSONEncoder().encode(self)
        let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        return jsonResult as! [String: AnyObject]
    }
}
