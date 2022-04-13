//
//  OfferCancel.swift
//  AnyCodable
//
//  Created by Denis Angell on 3/20/22.
//

import Foundation

public class OfferCancel: Transaction {
    
    public init(
        wallet: Wallet,
        offerSequence: Int
    ) {
        let _fields: [String:Any] = [
            "TransactionType" : "NFTokenCancelOffer",
            "offerSequence": offerSequence
        ]
        
        super.init(wallet: wallet, fields: _fields)
    }
}
