//
//  SetRegularKey.swift
//
//
//  Created by Denis Angell on 6/15/22.
//

import Foundation

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/transactions/setRegularKey.ts

public class SetRegularKey: BaseTransaction {
    /*
     Represents a `SetRegularKey <https://xrpl.org/setregularkey.html>`_
     transaction, which assigns, changes, or removes a secondary "regular" key pair
     associated with an account.
     */

    public var regularKey: String?
    /*
     The classic address derived from the key pair to authorize for this
     account. If omitted, removes any existing regular key pair from the
     account. Must not match the account's master key pair.
     */

    enum CodingKeys: String, CodingKey {
        case regularKey = "RegularKey"
    }

    public init(regularKey: String? = nil) {
        self.regularKey = regularKey
        super.init(account: "", transactionType: "SetRegularKey")
    }

    public override init(json: [String: AnyObject]) throws {
        let decoder: JSONDecoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(SetRegularKey.self, from: data)
        self.regularKey = decoded.regularKey
        try super.init(json: json)
    }

    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        regularKey = try values.decodeIfPresent(String.self, forKey: .regularKey)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        if let regularKey = regularKey { try values.encode(regularKey, forKey: .regularKey) }
    }
}

/**
 * Verify the form and type of a SetRegularKey at runtime.
 *
 * @param tx - A SetRegularKey Transaction.
 * @throws When the SetRegularKey is malformed.
 */
public func validateSetRegularKey(tx: [String: AnyObject]) throws {
    try validateBaseTransaction(common: tx)

    if tx["RegularKey"] != nil && !(tx["RegularKey"] is String) {
        throw ValidationError.decoding("SetRegularKey: RegularKey must be a string")
    }
}
