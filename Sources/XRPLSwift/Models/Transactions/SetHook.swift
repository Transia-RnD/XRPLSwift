//
//  SetHook.swift
//  AnyCodable
//
//  Created by Mitch Lang on 2/4/20.
//

import Foundation

public class SetHook: Transaction {
    
    public init(on wallet: Wallet, binary: String) {
        let _fields: [String:Any] = [
            "TransactionType": "SetHook",
            "CreateCode": binary,
            "HookOn": UInt64("0000000000000000")
        ]
        super.init(wallet: wallet, fields: _fields)
    }

}
