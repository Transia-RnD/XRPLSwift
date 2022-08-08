//
//  File.swift
//
//
//  Created by Denis Angell on 7/30/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/methods/ledgerCurrent.ts

import Foundation


/**
 * The ledger_current method returns the unique identifiers of the current
 * in-progress ledger. Expects a response in the form of a {@link
 * LedgerCurrentResponse}.
 *
 * @example
 * ```ts
 * const ledgerCurrent: LedgerCurrentRequest = {
 *   "command": "ledger_current"
 * }
 * ```
 *
 * @category Requests
 */
public class LedgerCurrentRequest: BaseRequest {
//    let command: String = "ledger_current"
    public init(
        // Base
        id: Int? = nil,
        apiVersion: Int? = nil
    ) {
        super.init(id: id, command: "ledger_current", apiVersion: apiVersion)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    override public func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
}

/**
 * Response expected from a {@link LedgerCurrentRequest}.
 *
 * @category Responses
 */
public class LedgerCurrentResponse: Codable {
    public let ledgerCurrentIndex: Int
    
    enum CodingKeys: String, CodingKey {
        case ledgerCurrentIndex = "ledger_current_index"
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ledgerCurrentIndex = try values.decode(Int.self, forKey: .ledgerCurrentIndex)
        //        try super.init(from: decoder)
    }
}
