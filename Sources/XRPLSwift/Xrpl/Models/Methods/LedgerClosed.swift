//
//  LedgerClosed.swift
//
//
//  Created by Denis Angell on 7/30/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/methods/ledgerClosed.ts

import Foundation

/**
 The ledger_closed method returns the unique identifiers of the most recently
 closed ledger. Expects a response in the form of a {@link
 LedgerClosedResponse}.
 *
 @example
 *
 ```ts
 const ledgerClosed: LedgerClosedRequest = {
 "command": "ledger_closed"
 }
 ```
 */
public class LedgerClosedRequest: BaseRequest {
    //    let command: String = "ledger_closed"
    public init(
        // Base
        id: Int? = nil,
        apiVersion: Int? = nil
    ) {
        super.init(id: id, command: "ledger_closed", apiVersion: apiVersion)
    }

    override public init(_ json: [String: AnyObject]) throws {
        try super.init(json)
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
}

/**
 The response expected from a {@link LedgerClosedRequest}.
 */
public class LedgerClosedResponse: Codable {
    public let ledgerHash: String
    public let ledgerIndex: Int

    enum CodingKeys: String, CodingKey {
        case ledgerHash = "ledger_hash"
        case ledgerIndex = "ledger_index"
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ledgerHash = try values.decode(String.self, forKey: .ledgerHash)
        ledgerIndex = try values.decode(Int.self, forKey: .ledgerIndex)
        //        try super.init(from: decoder)
    }

    func toJson() throws -> [String: AnyObject] {
        let data = try JSONEncoder().encode(self)
        let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        return jsonResult as! [String: AnyObject]
    }
}
