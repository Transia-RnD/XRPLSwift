//
//  CheckCancel.swift
//
//
//  Created by Denis Angell on 7/31/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/transactions/checkCancel.ts

import Foundation

/**
 Represents a [CheckCancel](https://xrpl.org/checkcancel.html) transaction,
 which cancels an unredeemed Check, removing it from the ledger
 without sending any money. The source or the destination of the check
 can cancel a Check at any time using this transaction type. If the
 Check has expired, any address can cancel it.
 */
public class CheckCancel: BaseTransaction {
    /**
     The ID of the [Check ledger object](https://xrpl.org/check.html) to cash, as a 64-character
     hexadecimal string. This field is required.
     :meta hide-value:
     */
    public let checkId: String

    enum CodingKeys: String, CodingKey {
        case checkId = "CheckID"
    }

    public init(checkId: String) {
        self.checkId = checkId
        super.init(account: "", transactionType: "AccountSet")
    }

    override public init(json: [String: AnyObject]) throws {
        let decoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(CheckCancel.self, from: data)
        self.checkId = decoded.checkId
        try super.init(json: json)
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        checkId = try values.decode(String.self, forKey: .checkId)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try values.encode(checkId, forKey: .checkId)
    }
}

/**
 Verify the form and type of an CheckCancel at runtime.
 - parameters:
 - tx: An CheckCancel Transaction.
 - throws:
 When the CheckCancel is Malformed.
 */
public func validateCheckCancel(tx: [String: AnyObject]) throws {
    try validateBaseTransaction(common: tx)

    guard let checkId = tx["CheckID"] as? String, !checkId.isEmpty else {
        throw ValidationError("CheckCancel: invalid CheckID")
    }
}
