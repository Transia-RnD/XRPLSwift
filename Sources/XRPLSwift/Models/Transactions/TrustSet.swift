//
//  TrustSet.swift
//  AnyCodable
//
//  Created by Mitch Lang on 2/4/20.
//

import Foundation

public class TrustSet: Transaction {
    
    public init(from wallet: Wallet, to address: Address, symbol: String, initialValue: Amount) {
        let _fields: [String:Any] = [
            "TransactionType": "TrustSet",
            "LimitAmount": [
                "currency": symbol,
                "value": initialValue.toXrp().clean,
                "issuer": address.rAddress
            ],
            "Flags": UInt64(131072),
        ]
        
        super.init(wallet: wallet, fields: _fields)
    }

}
