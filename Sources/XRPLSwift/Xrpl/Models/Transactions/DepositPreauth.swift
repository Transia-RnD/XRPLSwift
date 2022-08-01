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
    
    public init(
        authorize: String? = nil,
        unauthorize: String? = nil
    ) {
        
        self.authorize = authorize
        self.unauthorize = unauthorize
        super.init(account: "", transactionType: "DepositPreauth")
    }
    
    enum CodingKeys: String, CodingKey {
        case authorize = "Authorize"
        case unauthorize = "Unauthorize"
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        authorize = try values.decode(String.self, forKey: .authorize)
        unauthorize = try values.decode(String.self, forKey: .unauthorize)
        try super.init(from: decoder)
    }
    
    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        if let authorize = authorize { try values.encode(authorize, forKey: .authorize) }
        if let unauthorize = unauthorize { try values.encode(unauthorize, forKey: .unauthorize) }
    }
}
