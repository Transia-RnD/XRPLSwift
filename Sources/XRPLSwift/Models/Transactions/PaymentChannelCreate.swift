//
//  PaymentChannelCreate.swift
//  AnyCodable
//
//  Created by Denis Angell on 2/19/22.
//
import Foundation

public class PaymentChannelCreate: Transaction {
    
    public init(
        from wallet: Wallet,
        to address: Address,
        amount: Amount,
        settleDelay: Int,
        cancelAfter: Int? = nil,
        sourceTag : UInt32? = nil
    ) {
        
        // dictionary containing partial transaction fields
        var _fields: [String:Any] = [
            "TransactionType": "PaymentChannelCreate",
            "SettleDelay": settleDelay,
            "PublicKey": wallet.publicKey,
            "Amount": String(amount.drops),
            "Destination": address.rAddress,
        ]
        
        if let cancelAfter = cancelAfter {
            assert(cancelAfter > settleDelay)
            _fields["CancelAfter"] = cancelAfter
        }
        
        if let destinationTag = address.tag {
            _fields["DestinationTag"] = destinationTag
        }
        
        if let sourceTag = sourceTag {
            _fields["SourceTag"] = sourceTag
        }
        
        super.init(wallet: wallet, fields: _fields)
    }

}
