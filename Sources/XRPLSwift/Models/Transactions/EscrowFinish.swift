//
//  EscrowFinish.swift
//  AnyCodable
//
//  Created by Mitch Lang on 2/5/20.
//

import Foundation
import NIO

public class EscrowFinish: Transaction {
    
    public init(using wallet: Wallet, owner: String, offerSequence: UInt32) {
        
        // dictionary containing partial transaction fields
        let _fields: [String:Any] = [
            "TransactionType": "EscrowFinish",
            "OfferSequence": offerSequence,
            "Owner": owner,
        ]
        
        super.init(wallet: wallet, fields: _fields)
    }
    
}
