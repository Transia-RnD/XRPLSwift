//
//  DepositPreauth.swift
//
//
//  Created by Denis Angell on 7/31/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/transactions/depositPreauth.ts

import Foundation


/**
 Represents a `CheckCreate <https://xrpl.org/checkcreate.html>`_ transaction,
 which creates a Check object. A Check object is a deferred payment
 that can be cashed by its intended destination. The sender of this
 transaction is the sender of the Check.
 */
public class DepositPreauth: BaseTransaction {
    
    /**
     The address of the `account
     <https://xrpl.org/accounts.html>`_ that can cash the Check. This field is
     required.
     */
    public let authorize: String?
    
    /**
     Maximum amount of source token the Check is allowed to debit the
     sender, including transfer fees on non-XRP tokens. The Check can only
     credit the destination with the same token (from the same issuer, for
     non-XRP tokens). This field is required.
     :meta hide-value:
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
    
    public override init(json: [String: AnyObject]) throws {
        let decoder: JSONDecoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let r = try decoder.decode(DepositPreauth.self, from: data)
        self.authorize = r.authorize
        self.unauthorize = r.unauthorize
        try super.init(json: json)
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        authorize = try? values.decode(String.self, forKey: .authorize)
        unauthorize = try? values.decode(String.self, forKey: .unauthorize)
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
 * Verify the form and type of a DepositPreauth at runtime.
 *
 * @param tx - A DepositPreauth Transaction.
 * @throws When the DepositPreauth is malformed.
 */
public func validateDepositPreauth(tx: [String: AnyObject]) throws -> Void {
    try validateBaseTransaction(common: tx)
    
    if tx["Authorize"] != nil && tx["Unauthorize"] != nil {
        throw ValidationError.decoding("DepositPreauth: can't provide both Authorize and Unauthorize fields")
    }
    
    if tx["Authorize"] == nil && tx["Unauthorize"] == nil {
        throw ValidationError.decoding("DepositPreauth: must provide either Authorize or Unauthorize field")
    }
    
    if tx["Authorize"] != nil {
        if !(tx["Authorize"] is String) {
            throw ValidationError.decoding("DepositPreauth: Authorize must be a string")
        }
        if (tx["Account"] as! String) == (tx["Authorize"] as! String) {
            throw ValidationError.decoding("DepositPreauth: Account can't preauthorize its own address")
        }
    }
    
    if tx["Unauthorize"] != nil {
        if !(tx["Unauthorize"] is String) {
            throw ValidationError.decoding("DepositPreauth: Unauthorize must be a string")
        }
        if (tx["Account"] as! String) == (tx["Unauthorize"] as! String) {
            throw ValidationError.decoding("DepositPreauth: Account can't unauthorize its own address")
        }
    }
}
