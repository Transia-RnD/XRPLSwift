//
//  NFTokenCreateOffer.swift
//  AnyCodable
//
//  Created by Denis Angell on 3/20/22.
//

import Foundation

public enum NFTokenCreateOfferFlag: UInt32 {
    case tfSellToken = 1
}

public class NFTokenCreateOffer: Transaction {
    
    public init(
        wallet: Wallet,
        tokenId: String,
        amount: Int,
        owner: String?,
        expiration: Int?,
        destination: String?
    ) {
        var _fields: [String:Any] = [
            "TransactionType" : "NFTokenCreateOffer",
            "tokenid": tokenId
        ]
        
        // TODO: Use Switchable Amount XRP/Currency
//        if let amount = amount {
//            _fields["Amount"] = amount
//        }
        
        if let owner = owner {
            _fields["Owner"] = owner
        }
        
        if let expiration = expiration {
            _fields["Expiration"] = expiration
        }
        
        if let destination = destination {
            _fields["Destination"] = destination
        }
        
        super.init(wallet: wallet, fields: _fields)
    }
}
