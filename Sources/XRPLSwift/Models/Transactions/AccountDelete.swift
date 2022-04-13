//
//  AccountDelete.swift
//  AnyCodable
//
//  Created by Mitch Lang on 2/4/20.
//

import Foundation

public class AccountDelete: Transaction {
    
    public init(from wallet: Wallet, to address: Address) {
        var _fields: [String:Any] = [
            "TransactionType": "AccountDelete",
            "Destination": address
        ]
        
        if let tag = address.tag {
            _fields["DestinationTag"] = tag
        }
        
        super.init(wallet: wallet, fields: _fields)
    }

}
