//
//  OfferCreate.swift
//  AnyCodable
//
//  Created by Denis Angell on 3/20/22.
//

import Foundation

public class OfferCreate: Transaction {
    
    public init(
        wallet: Wallet,
        takerGets: Amount,
        takerPays: Amount,
        expiration: Int? = nil,
        offerSequence: Int? = nil
    ) {
        let _fields: [String:Any] = [
            "TransactionType" : "NFTokenCancelOffer",
            "TakerGets": takerGets,
            "TakerPays": takerPays,
        ]
        
//        if let expiration = expiration {
//            _fields["Expiration"] = expiration
//        }
//        
//        if let offerSequence = offerSequence {
//            _fields["OfferSequence"] = offerSequence
//        }
        
        super.init(wallet: wallet, fields: _fields)
    }
}
