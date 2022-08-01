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
    
    public var regularKey: String
    /*
     The classic address derived from the key pair to authorize for this
     account. If omitted, removes any existing regular key pair from the
     account. Must not match the account's master key pair.
     */
    
    public init(
        regularKey: String
    ) {
        
        self.regularKey = regularKey
        
        // TODO: Write into using variables on model not fields. (Serialize Later in Tx)
        // Sets the fields for the tx
        let _fields: [String:Any] = [
            "TransactionType": "TransactionType.SetRegularKey.rawValue",
            "RegularKey": regularKey,
        ]
        
        super.init(account: "", transactionType: "SetRegularKey")
    }
    
    enum CodingKeys: String, CodingKey {
        case regularKey = "RegularKey"
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        regularKey = try values.decode(String.self, forKey: .regularKey)
        try super.init(from: decoder)
    }
    
    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try values.encode(regularKey, forKey: .regularKey)
    }
    
}
