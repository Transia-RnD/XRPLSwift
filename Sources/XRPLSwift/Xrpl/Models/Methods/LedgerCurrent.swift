//
//  File.swift
//
//
//  Created by Denis Angell on 7/30/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/methods/ledgerCurrent.ts

import Foundation

/**
 The ledger_current method returns the unique identifiers of the current
 in-progress ledger. Expects a response in the form of a {@link
 LedgerCurrentResponse}.
 *
 @example
 ```ts
 const ledgerCurrent: LedgerCurrentRequest = {
 "command": "ledger_current"
 }
 ```
 */
public class LedgerCurrentRequest: BaseRequest {
    public init(
        // Base
        id: Int? = nil,
        apiVersion: Int? = nil
    ) {
        super.init(id: id, command: "ledger_current", apiVersion: apiVersion)
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
 Response expected from a {@link LedgerCurrentRequest}.
 */
public class LedgerCurrentResponse: Codable {
    public var ledgerCurrentIndex: Int

    enum CodingKeys: String, CodingKey {
        case ledgerCurrentIndex = "ledger_current_index"
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ledgerCurrentIndex = try values.decode(Int.self, forKey: .ledgerCurrentIndex)
        //        try super.init(from: decoder)
    }

    func toJson() throws -> [String: AnyObject] {
        let data = try JSONEncoder().encode(self)
        let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        return jsonResult as! [String: AnyObject]
    }
}
