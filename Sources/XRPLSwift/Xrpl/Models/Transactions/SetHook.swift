//
//  SetHook.swift
//  AnyCodable
//
//  Created by Mitch Lang on 2/10/20.
//  Updated by Denis Angell on 6/4/22.
//

import Foundation

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/models/transactions/set_hook.py

public enum HookFlag: UInt32 {
    case asfAccountTxId = 5
}

public class SetHook: Transaction {
    /*
    Represents an `SetHook transaction <https://xrpl.org/accountset.html>`_,
    which modifies the properties of an account in the XRP Ledger.
    */
    
    public var stateKey: String?
    /*
    Add a state key
    <https://xrpl.org/sethook.html#accountset-flags>`_
    */
    
    public var namespace: String?
    /*
    Set the namespace of the hook. Must be hex-encoded. You can
    use `xrpl.utils.str_to_hex` to convert a UTF-8 string to hex.
    */
    

    public init(
        wallet: Wallet,
        stateKey: String?,
        namespace: String?
    ) {
        self.stateKey = stateKey
        self.namespace = namespace
        
        // TODO: Write into using variables on model not fields. (Serialize Later in Tx)
        // Sets the fields for the tx
        var _fields: [String:Any] = [
            "TransactionType" : TransactionType.SetHook.rawValue
        ]

        
        super.init(wallet: wallet, fields: _fields)
    }
}
