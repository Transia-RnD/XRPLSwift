//
//  SetRegularKey.swift
//  
//
//  Created by Denis Angell on 6/15/22.
//

import Foundation

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/models/transactions/set_regular_key.py

public class SetRegularKey: Transaction {
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
        wallet: Wallet,
        regularKey: String,
    ) {
        
        self.regularKey = regularKey
        
        // TODO: Write into using variables on model not fields. (Serialize Later in Tx)
        // Sets the fields for the tx
        let _fields: [String:Any] = [
            "TransactionType": TransactionType.SetRegularKey.rawValue,
            "RegularKey": regularKey,
        ]
        
        super.init(wallet: wallet, fields: _fields)
    }
    
}
