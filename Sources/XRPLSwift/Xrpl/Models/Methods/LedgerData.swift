//
//  LedgerData.swift
//
//
//  Created by Denis Angell on 7/30/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/methods/ledgerData.ts

import AnyCodable
import Foundation

/**
 * The `ledger_data` method retrieves contents of the specified ledger. You can
 * iterate through several calls to retrieve the entire contents of a single
 * ledger version.
 *
 * @example
 * ```swift
 * let ledgerDataRequest: LedgerDataRequest(
 *   id: 2,
 *   ledgerHash: "842B57C1CC0613299A686D3E9F310EC0422C84D3911E5056389AA7E5808A93C8",
 *   limit: 5,
 *   binary: true
 * )
 * ```
 *
 * @category Requests
 */
public class LedgerDataRequest: BaseRequest {
    //    let command: String = "ledger_data"
    /** A 20-byte hex string for the ledger version to use. */
    let ledgerHash: String?
    /**
     * The ledger index of the ledger to use, or a shortcut string to choose a
     * ledger automatically.
     */
    let ledgerIndex: LedgerIndex?
    /**
     * If set to true, return ledger objects as hashed hex strings instead of
     * JSON.
     */
    let binary: Bool?
    /**
     * Limit the number of ledger objects to retrieve. The server is not required
     * to honor this value.
     */
    let limit: Int?
    /**
     * Value from a previous paginated response. Resume retrieving data where
     * that response left off.
     */
    let marker: AnyCodable?

    enum CodingKeys: String, CodingKey {
        case ledgerHash = "ledger_hash"
        case ledgerIndex = "ledger_index"
        case binary = "binary"
        case limit = "limit"
        case marker = "marker"
    }

    public init(
        // Base
        id: Int? = nil,
        apiVersion: Int? = nil,
        // Optional
        ledgerHash: String? = nil,
        ledgerIndex: LedgerIndex? = nil,
        binary: Bool? = nil,
        limit: Int? = nil,
        marker: AnyCodable? = nil
    ) {
        // Optional
        self.ledgerHash = ledgerHash
        self.ledgerIndex = ledgerIndex
        self.binary = binary
        self.limit = limit
        self.marker = marker
        super.init(id: id, command: "ledger_data", apiVersion: apiVersion)
    }

    override public init(_ json: [String: AnyObject]) throws {
        let decoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(LedgerDataRequest.self, from: data)
        self.ledgerHash = decoded.ledgerHash
        self.ledgerIndex = decoded.ledgerIndex
        self.binary = decoded.binary
        self.limit = decoded.limit
        self.marker = decoded.marker
        try super.init(json)
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ledgerHash = try values.decodeIfPresent(String.self, forKey: .ledgerHash)
        ledgerIndex = try values.decodeIfPresent(LedgerIndex.self, forKey: .ledgerIndex)
        binary = try? values.decodeIfPresent(Bool.self, forKey: .binary)
        limit = try? values.decodeIfPresent(Int.self, forKey: .limit)
        marker = try? values.decodeIfPresent(AnyCodable.self, forKey: .marker)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        if let ledgerHash = ledgerHash { try values.encode(ledgerHash, forKey: .ledgerHash) }
        if let ledgerIndex = ledgerIndex { try values.encode(ledgerIndex, forKey: .ledgerIndex) }
        if let binary = binary { try values.encode(binary, forKey: .binary) }
        if let limit = limit { try values.encode(limit, forKey: .limit) }
        if let marker = marker { try values.encode(marker, forKey: .marker) }
    }
}

// type LabeledLedgerEntry = { ledgerEntryType: String } & LedgerEntry

public struct State: Codable {
    let data: String
    let index: String
}

// type State = { index: String } & (BinaryLedgerEntry | LabeledLedgerEntry)

/**
 * The response expected from a {@link LedgerDataRequest}.
 *
 * @category Responses
 */
public class LedgerDataResponse: Codable {
    /**
     * Array of JSON objects containing data from the ledger's state tree,
     * as defined below.
     */
    public let state: [State]
    /** Unique identifying hash of this ledger version. */
    public let ledgerHash: String
    /** The ledger index of this ledger version. */
    public let ledgerIndex: Int
    /**
     * Server-defined value indicating the response is paginated. Pass this to
     * the next call to resume where this call left off.
     */
    public let marker: AnyCodable?
    public let validated: Bool?

    enum CodingKeys: String, CodingKey {
        case state = "state"
        case ledgerHash = "ledger_hash"
        case ledgerIndex = "ledger_index"
        case marker = "marker"
        case validated = "validated"
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        state = try values.decode([State].self, forKey: .state)
        ledgerHash = try values.decode(String.self, forKey: .ledgerHash)
        ledgerIndex = try values.decode(Int.self, forKey: .ledgerIndex)
        marker = try values.decode(AnyCodable.self, forKey: .marker)
        validated = try values.decode(Bool.self, forKey: .validated)
        //        try super.init(from: decoder)
    }

    func toJson() throws -> [String: AnyObject] {
        let data = try JSONEncoder().encode(self)
        let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        return jsonResult as! [String: AnyObject]
    }
}
