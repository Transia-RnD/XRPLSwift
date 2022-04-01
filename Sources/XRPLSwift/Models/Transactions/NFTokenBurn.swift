//
//  NFTokenBurn.swift
//  AnyCodable
//
//  Created by Denis Angell on 3/20/22.
//

import Foundation

public class NFTokenBurn: XRPTransaction {
    
    public init(
        wallet: XRPWallet,
        tokenId: String
    ) {
        let _fields: [String:Any] = [
            "TransactionType" : "NFTokenBurn",
            "tokenid": tokenId
        ]
        
        super.init(wallet: wallet, fields: _fields)
    }
}
