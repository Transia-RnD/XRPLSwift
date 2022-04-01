//
//  NFTokenCancelOffer.swift
//  AnyCodable
//
//  Created by Denis Angell on 3/20/22.
//

import Foundation

public class NFTokenCancelOffer: XRPTransaction {
    
    public init(
        wallet: XRPWallet,
        tokenOffers: [String]
    ) {
        let _fields: [String:Any] = [
            "TransactionType" : "NFTokenCancelOffer",
            "TokenOffers": tokenOffers
        ]
        
        super.init(wallet: wallet, fields: _fields)
    }
}
