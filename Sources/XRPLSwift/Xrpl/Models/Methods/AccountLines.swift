//
//  AccountLines.swift
//
//
//  Created by Denis Angell on 7/30/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/methods/accountLines.ts

import AnyCodable
import Foundation

public class Trustline: Codable {
    /// The unique Address of the counterparty to this trust line.
    public let account: String
    /**
     Representation of the numeric balance currently held against this line. A
     positive balance means that the perspective account holds value; a negative
     Balance means that the perspective account owes value.
     */
    public let balance: String
    /// A Currency Code identifying what currency this trust line can hold.
    public let currency: String
    /**
     The maximum amount of the given currency that this account is willing to
     owe the peer account.
     */
    public let limit: String
    /**
     The maximum amount of currency that the issuer account is willing to owe
     the perspective account.
     */
    public let limitPeer: String
    /**
     Rate at which the account values incoming balances on this trust line, as
     a ratio of this value per 1 billion units. (For example, a value of 500
     million represents a 0.5:1 ratio.) As a special case, 0 is treated as a
     1:1 ratio.
     */
    public let qualityIn: Int
    /**
     Rate at which the account values outgoing balances on this trust line, as
     a ratio of this value per 1 billion units. (For example, a value of 500
     million represents a 0.5:1 ratio.) As a special case, 0 is treated as a 1:1
     ratio.
     */
    public let qualityOut: Int
    /**
     If true, this account has enabled the No Ripple flag for this trust line.
     If present and false, this account has disabled the No Ripple flag, but,
     because the account also has the Default Ripple flag enabled, that is not
     considered the default state. If omitted, the account has the No Ripple
     flag disabled for this trust line and Default Ripple disabled.
     */
    public let noRipple: Bool?
    /**
     If true, the peer account has enabled the No Ripple flag for this trust
     line. If present and false, this account has disabled the No Ripple flag,
     but, because the account also has the Default Ripple flag enabled, that is
     not considered the default state. If omitted, the account has the No Ripple
     flag disabled for this trust line and Default Ripple disabled.
     */
    public let noRipplePeer: Bool?
    /// If true, this account has authorized this trust line. The default is false.
    public let authorized: Bool?
    /// If true, the peer account has authorized this trust line. The default is false.
    public let peerAuthorized: Bool?
    /// If true, this account has frozen this trust line. The default is false.
    public let freeze: Bool?
    /**
     If true, the peer account has frozen this trust line. The default is
     false.
     */
    public let freezePeer: Bool?
}

/**
 The account_lines method returns information about an account's trust lines,
  including balances in all non-XRP currencies and assets. All information
 retrieved is relative to a particular version of the ledger. Expects an
 {@link AccountLinesResponse}.
 *
 @category Requests
 */
public class AccountLinesRequest: BaseRequest {
    /// A unique identifier for the account, most commonly the account's Address.
    public let account: String
    /// A 20-byte hex string for the ledger version to use.
    public let ledgerHash: String?
    /**
     The ledger index of the ledger to use, or a shortcut string to choose a
     ledger automatically.
     */
    public let ledgerIndex: LedgerIndex?
    /**
     The Address of a second account. If provided, show only lines of trust
     connecting the two accounts.
     */
    public let peer: Int?
    /**
     Limit the number of trust lines to retrieve. The server is not required to
     honor this value. Must be within the inclusive range 10 to 400.
     */
    public let limit: Int?
    /**
     Value from a previous paginated response. Resume retrieving data where
     that response left off.
     */
    public let marker: AnyCodable?

    enum CodingKeys: String, CodingKey {
        case account = "account"
        case ledgerHash = "ledger_hash"
        case ledgerIndex = "ledger_index"
        case peer = "peer"
        case limit = "limit"
        case marker = "marker"
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
        peer: Int? = nil,
        limit: Int? = nil,
        marker: AnyCodable? = nil
    ) {
        // Required
        self.account = account
        // Optional
        self.ledgerHash = ledgerHash
        self.ledgerIndex = ledgerIndex
        self.peer = peer
        self.limit = limit
        self.marker = marker
        super.init(id: id, command: "account_lines", apiVersion: apiVersion)
    }

    override public init(_ json: [String: AnyObject]) throws {
        let decoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(AccountLinesRequest.self, from: data)
        self.account = decoded.account
        self.ledgerHash = decoded.ledgerHash
        self.ledgerIndex = decoded.ledgerIndex
        self.peer = decoded.peer
        self.limit = decoded.limit
        self.marker = decoded.marker
        try super.init(json)
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        account = try values.decode(String.self, forKey: .account)
        ledgerHash = try values.decodeIfPresent(String.self, forKey: .ledgerHash)
        ledgerIndex = try values.decodeIfPresent(LedgerIndex.self, forKey: .ledgerIndex)
        peer = try? values.decodeIfPresent(Int.self, forKey: .peer)
        limit = try? values.decodeIfPresent(Int.self, forKey: .limit)
        marker = try? values.decodeIfPresent(AnyCodable.self, forKey: .marker)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try values.encode(account, forKey: .account)
        if let ledgerHash = ledgerHash { try values.encode(ledgerHash, forKey: .ledgerHash) }
        if let ledgerIndex = ledgerIndex { try values.encode(ledgerIndex, forKey: .ledgerIndex) }
        if let peer = peer { try values.encode(peer, forKey: .peer) }
        if let limit = limit { try values.encode(limit, forKey: .limit) }
        if let marker = marker { try values.encode(marker, forKey: .marker) }
    }
}

/**
 Response expected from an {@link AccountLinesRequest}.
 */
open class AccountLinesResponse: Codable {
    /**
     Unique Address of the account this request corresponds to. This is the
     "perspective account" for purpose of the trust lines.
     */
    public let account: String
    /**
     Array of trust line objects. If the number of trust lines is large, only
     returns up to the limit at a time.
     */
    public let lines: [Trustline]
    /**
     The ledger index of the current open ledger, which was used when
     retrieving this information.
     */
    public let ledgerCurrentIndex: Int?
    /**
     The ledger index of the ledger version that was used when retrieving
     this data.
     */
    public let ledgerIndex: Int?
    /**
     The identifying hash the ledger version that was used when retrieving
     this data.
     */
    public let ledgerHash: String?
    /**
     Server-defined value indicating the response is paginated. Pass this to
     the next call to resume where this call left off. Omitted when there are
     No additional pages after this one.
     */
    public let marker: AnyCodable?

    enum CodingKeys: String, CodingKey {
        case account = "account"
        case lines = "lines"
        case ledgerCurrentIndex = "ledger_current_index"
        case ledgerIndex = "ledger_index"
        case ledgerHash = "ledger_hash"
        case marker = "marker"
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        account = try values.decode(String.self, forKey: .account)
        lines = try values.decode([Trustline].self, forKey: .lines)
        ledgerCurrentIndex = try values.decodeIfPresent(Int.self, forKey: .ledgerCurrentIndex)
        ledgerIndex = try values.decodeIfPresent(Int.self, forKey: .ledgerIndex)
        ledgerHash = try values.decodeIfPresent(String.self, forKey: .ledgerHash)
        marker = try values.decodeIfPresent(AnyCodable.self, forKey: .marker)
//        try super.init(from: decoder)
    }

    func toJson() throws -> [String: AnyObject] {
        let data = try JSONEncoder().encode(self)
        let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        return jsonResult as! [String: AnyObject]
    }
}
