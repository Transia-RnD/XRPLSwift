//
//  PaymentChannelClaim.swift
//  AnyCodable
//
//  Created by Denis Angell on 2/19/22.
//
import Foundation

public class PaymentChannelClaim: Transaction {
    
    public init(
        from wallet: Wallet,
        channel: String,
        balance: Amount? = nil,
        amount: Amount? = nil,
        signature: String? = nil,
        publicKey: String? = nil,
        sourceTag : UInt32? = nil
    ) {
        
        // dictionary containing partial transaction fields
        var _fields: [String:Any] = [
            "TransactionType": "PaymentChannelClaim",
            "Channel": channel,
        ]
        
        if amount != nil {
            _fields["Amount"] = String(amount!.drops)
        }
        /*
        The cumulative amount of XRP that has been authorized to deliver by the
        attached claim signature. Required unless closing the channel.
        */
        
        if balance != nil {
            _fields["Balance"] = String(balance!.drops)
        }
        /*
        The cumulative amount of XRP to have delivered through this channel after
        processing this claim. Required unless closing the channel.
        */
        
        if signature != nil {
            _fields["Signature"] = signature
        }
        /*
        The signature of the claim, as hexadecimal. This signature must be
        verifiable for the this channel and the given ``public_key`` and ``amount``
        values. May be omitted if closing the channel or if the sender of this
        transaction is the source address of the channel; required otherwise.
        */
        
        if publicKey != nil {
            _fields["PublicKey"] = publicKey
        }
        /*
        The public key that should be used to verify the attached signature. Must
        match the `PublicKey` that was provided when the channel was created.
        Required if ``signature`` is provided.
        */
        
        if let sourceTag = sourceTag {
            _fields["SourceTag"] = sourceTag
        }
        
        super.init(wallet: wallet, fields: _fields)
    }

}
