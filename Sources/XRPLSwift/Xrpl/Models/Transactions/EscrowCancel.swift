//
//  EscrowCancel.swift
//  AnyCodable
//
//  Created by Mitch Lang on 2/5/20.
//

import Foundation

public class EscrowCancel: Transaction {
    
    public init(using wallet: Wallet, owner: String, offerSequence: UInt32) {
        
        // dictionary containing partial transaction fields
        let _fields: [String:Any] = [
            "TransactionType": "EscrowCancel",
            "OfferSequence": offerSequence,
            "Owner": owner,
        ]
        
        super.init(wallet: wallet, fields: _fields)
    }

}
