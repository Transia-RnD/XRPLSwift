//
//  PaymentChannelFund.swift
//  AnyCodable
//
//  Created by Denis Angell on 2/19/22.
//
import Foundation

public class PaymentChannelFund: XRPTransaction {
    
    public init(
        from wallet: XRPWallet,
        channel: String,
        amount: XRPAmount,
        expiration: Int? = nil,
        sourceTag : UInt32? = nil
    ) {
        
        // dictionary containing partial transaction fields
        var _fields: [String:Any] = [
            "TransactionType": "PaymentChannelFund",
            "Channel": channel,
            "Amount": String(amount.drops),
        ]
        
        if let sourceTag = sourceTag {
            _fields["SourceTag"] = sourceTag
        }
        
        super.init(wallet: wallet, fields: _fields)
    }

}
