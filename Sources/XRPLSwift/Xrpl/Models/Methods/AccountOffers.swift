//
//  AccountOffers.swift
//
//
//  Created by Denis Angell on 7/30/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/methods/accountOffers.ts

import AnyCodable
import Foundation

/**
 The account_offers method retrieves a list of offers made by a given account
 that are outstanding as of a particular ledger version. Expects a response in
 the form of a {@link AccountOffersResponse}.
 */
public class AccountOffersRequest: BaseRequest {
    /// A unique identifier for the account, most commonly the account's Address.
    public var account: String
    /// A 20-byte hex string identifying the ledger version to use.
    public var ledgerHash: String?
    /**
     The ledger index of the ledger to use, or "current", "closed", or
     "validated" to select a ledger dynamically.
     */
    public var ledgerIndex: LedgerIndex?
    /**
     Limit the number of transactions to retrieve. The server is not required
     to honor this value. Must be within the inclusive range 10 to 400.
     */
    public var limit: Int?
    /**
     Value from a previous paginated response. Resume retrieving data where
     that response left off.
     */
    public var marker: AnyCodable?
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
        case limit = "limit"
        case marker = "marker"
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
        limit: Int? = nil,
        marker: AnyCodable? = nil,
        strict: Bool? = nil
    ) {
        // Required
        self.account = account
        // Optional
        self.ledgerHash = ledgerHash
        self.ledgerIndex = ledgerIndex
        self.limit = limit
        self.marker = marker
        self.strict = strict
        super.init(id: id, command: "account_offers", apiVersion: apiVersion)
    }

    override public init(_ json: [String: AnyObject]) throws {
        let decoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(AccountOffersRequest.self, from: data)
        // Required
        self.account = decoded.account
        // Optional
        self.ledgerHash = decoded.ledgerHash
        self.ledgerIndex = decoded.ledgerIndex
        self.limit = decoded.limit
        self.marker = decoded.marker
        self.strict = decoded.strict
        try super.init(json)
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        account = try values.decode(String.self, forKey: .account)
        ledgerHash = try values.decodeIfPresent(String.self, forKey: .ledgerHash)
        ledgerIndex = try values.decodeIfPresent(LedgerIndex.self, forKey: .ledgerIndex)
        limit = try? values.decodeIfPresent(Int.self, forKey: .limit)
        marker = try? values.decodeIfPresent(AnyCodable.self, forKey: .marker)
        strict = try? values.decodeIfPresent(Bool.self, forKey: .strict)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try values.encode(account, forKey: .account)
        if let ledgerHash = ledgerHash { try values.encode(ledgerHash, forKey: .ledgerHash) }
        if let ledgerIndex = ledgerIndex { try values.encode(ledgerIndex, forKey: .ledgerIndex) }
        if let limit = limit { try values.encode(limit, forKey: .limit) }
        if let marker = marker { try values.encode(marker, forKey: .marker) }
        if let strict = strict { try values.encode(strict, forKey: .strict) }
    }
}

public class AccountOffer: Codable {
    /// Options set for this offer entry as bit-flags.
    public var flags: Int
    /// Sequence number of the transaction that created this entry.
    public var seq: Int
    /**
     The amount the account placing this Offer receives.
     */
    public var takerGets: Amount
    /**
     The amount the account placing this Offer pays.
     */
    public var takerPays: Amount
    /**
     The exchange rate of the Offer, as the ratio of the original taker_pays
     divided by the original taker_gets. When executing offers, the offer with
     the most favorable (lowest) quality is consumed first; offers with the same
     quality are executed from oldest to newest.
     */
    public var quality: String
    /**
     A time after which this offer is considered unfunded, as the number of
     seconds since the Ripple Epoch. See also: Offer Expiration.
     */
    public var expiration: Int?

    enum CodingKeys: String, CodingKey {
        case flags = "flags"
        case seq = "seq"
        case takerGets = "taker_gets"
        case takerPays = "taker_pays"
        case quality = "quality"
        case expiration = "expiration"
    }
}

/**
 Response expected from an {@link AccountOffersRequest}.
 */
public class AccountOffersResponse: Codable {
    /// Unique Address identifying the account that made the offers.
    public var account: String
    /**
     Array of objects, where each object represents an offer made by this
     account that is outstanding as of the requested ledger version. If the
     number of offers is large, only returns up to limit at a time.
     */
    public var offers: [AccountOffer]?
    /**
     The ledger index of the current in-progress ledger version, which was
     used when retrieving this data.
     */
    public var ledgerCurrentIndex: Int?
    /**
     The identifying hash of the ledger version that was used when retrieving
     this data.
     */
    public var ledgerHash: String?
    /**
     The ledger index of the ledger version that was used when retrieving
     this data, as requested.
     */
    public var ledgerIndex: Int?
    /**
     Server-defined value indicating the response is paginated. Pass this to
     the next call to resume where this call left off. Omitted when there are
     no pages of information after this one.
     */
    public var marker: AnyCodable?

    enum CodingKeys: String, CodingKey {
        case account = "account"
        case offers = "offers"
        case ledgerCurrentIndex = "ledger_current_index"
        case ledgerHash = "ledger_hash"
        case ledgerIndex = "ledger_index"
        case marker = "marker"
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        account = try values.decode(String.self, forKey: .account)
        offers = try values.decode([AccountOffer].self, forKey: .offers)
        ledgerCurrentIndex = try values.decodeIfPresent(Int.self, forKey: .ledgerCurrentIndex)
        ledgerHash = try values.decodeIfPresent(String.self, forKey: .ledgerHash)
        ledgerIndex = try values.decodeIfPresent(Int.self, forKey: .ledgerIndex)
        marker = try values.decodeIfPresent(AnyCodable.self, forKey: .marker)
        //        try super.init(from: decoder)
    }

    func toJson() throws -> [String: AnyObject] {
        let data = try JSONEncoder().encode(self)
        let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        return jsonResult as! [String: AnyObject]
    }
}
