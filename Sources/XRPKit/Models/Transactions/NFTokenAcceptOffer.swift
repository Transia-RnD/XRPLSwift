//
//  NFTokenAcceptOffer.swift
//  AnyCodable
//
//  Created by Denis Angell on 3/20/22.
//

import Foundation

public class NFTokenAcceptOffer: XRPTransaction {
    
    public init(
        wallet: XRPWallet,
        sellOffer: String?,
        buyOffer: String?,
        brokerFee: String?
    ) {
        var _fields: [String:Any] = [
            "TransactionType" : "NFTokenAcceptOffer"
        ]
        if let sellOffer = sellOffer {
            _fields["SellOffer"] = sellOffer
        }
        
        if let buyOffer = buyOffer {
            _fields["BuyOffer"] = buyOffer
        }
        
        if let brokerFee = brokerFee {
            _fields["BrokerFee"] = brokerFee
        }
        
        super.init(wallet: wallet, fields: _fields)
    }
}
