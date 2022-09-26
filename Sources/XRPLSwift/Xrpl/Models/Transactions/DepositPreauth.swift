//
//  DepositPreauth.swift
//
//
//  Created by Denis Angell on 7/31/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/transactions/depositPreauth.ts

import Foundation

/**
 Represents a [DepositPreauth](https://xrpl.org/depositpreauth.html) transaction,
 A DepositPreauth transaction gives another account pre-approval to deliver
 payments to the sender of this transaction. This is only useful if the sender
 of this transaction is using (or plans to use) Deposit Authorization.
 */
public class DepositPreauth: BaseTransaction {
    /// The XRP Ledger address of the sender to preauthorize.
    public let authorize: String?

    /**
     The XRP Ledger address of a sender whose preauthorization should be.
     revoked.
     */
    public let unauthorize: String?

    enum CodingKeys: String, CodingKey {
        case authorize = "Authorize"
        case unauthorize = "Unauthorize"
    }

    public init(
        authorize: String? = nil,
        unauthorize: String? = nil
    ) {
        self.authorize = authorize
        self.unauthorize = unauthorize
        super.init(account: "", transactionType: "DepositPreauth")
    }

    override public init(json: [String: AnyObject]) throws {
        let decoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(DepositPreauth.self, from: data)
        self.authorize = decoded.authorize
        self.unauthorize = decoded.unauthorize
        try super.init(json: json)
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        authorize = try values.decodeIfPresent(String.self, forKey: .authorize)
        unauthorize = try values.decodeIfPresent(String.self, forKey: .unauthorize)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        if let authorize = authorize { try values.encode(authorize, forKey: .authorize) }
        if let unauthorize = unauthorize { try values.encode(unauthorize, forKey: .unauthorize) }
    }
}

/**
 Verify the form and type of an DepositPreauth at runtime.
 - parameters:
    - tx: An DepositPreauth Transaction.
 - throws:
 When the DepositPreauth is Malformed.
 */
public func validateDepositPreauth(tx: [String: AnyObject]) throws {
    try validateBaseTransaction(common: tx)

    if tx["Authorize"] != nil && tx["Unauthorize"] != nil {
        throw ValidationError("DepositPreauth: can't provide both Authorize and Unauthorize fields")
    }

    if tx["Authorize"] == nil && tx["Unauthorize"] == nil {
        throw ValidationError("DepositPreauth: must provide either Authorize or Unauthorize field")
    }

    if tx["Authorize"] != nil {
        if !(tx["Authorize"] is String) {
            throw ValidationError("DepositPreauth: Authorize must be a string")
        }
        if (tx["Account"] as! String) == (tx["Authorize"] as! String) {
            throw ValidationError("DepositPreauth: Account can't preauthorize its own address")
        }
    }

    if tx["Unauthorize"] != nil {
        if !(tx["Unauthorize"] is String) {
            throw ValidationError("DepositPreauth: Unauthorize must be a string")
        }
        if (tx["Account"] as! String) == (tx["Unauthorize"] as! String) {
            throw ValidationError("DepositPreauth: Account can't unauthorize its own address")
        }
    }
}
