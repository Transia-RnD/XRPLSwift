////
////  SetHook.swift
////  AnyCodable
////
////  Created by Mitch Lang on 2/10/20.
////  Updated by Denis Angell on 6/4/22.
////
//
//import Foundation
//
//// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/models/transactions/set_hook.py
//
//public enum HookFlag: UInt32 {
//    case asfAccountTxId = 5
//}
//
//public class SetHook: BaseTransaction {
//    /*
//    Represents an `SetHook transaction <https://xrpl.org/accountset.html>`_,
//    which modifies the properties of an account in the XRP Ledger.
//    */
//    
//    public var stateKey: String?
//    /*
//    Add a state key
//    <https://xrpl.org/sethook.html#accountset-flags>`_
//    */
//    
//    public var namespace: String?
//    /*
//    Set the namespace of the hook. Must be hex-encoded. You can
//    use `xrpl.utils.str_to_hex` to convert a UTF-8 string to hex.
//    */
//    
//
//    public init(
//        wallet: Wallet,
//        stateKey: String?,
//        namespace: String?
//    ) {
//        self.stateKey = stateKey
//        self.namespace = namespace
//        
//        // TODO: Write into using variables on model not fields. (Serialize Later in Tx)
//        // Sets the fields for the tx
//        var _fields: [String:Any] = [
//            "TransactionType" : TransactionType.SetHook.rawValue
//        ]
//        
//        super.init(account: "", transactionType: "SetHook")
//    }
//    
//    enum CodingKeys: String, CodingKey {
//        case channel = "Channel"
//        case amount = "Amount"
//        case expiration = "Expiration"
//    }
//    
//    required public init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        channel = try values.decode(String.self, forKey: .channel)
//        amount = try values.decode(rAmount.self, forKey: .amount)
//        expiration = try? values.decode(Int.self, forKey: .expiration)
//        try super.init(from: decoder)
//    }
//    
//    override public func encode(to encoder: Encoder) throws {
//        var values = encoder.container(keyedBy: CodingKeys.self)
//        try super.encode(to: encoder)
//        try values.encode(channel, forKey: .channel)
//        try values.encode(amount, forKey: .amount)
//        if let expiration = expiration { try values.encode(expiration, forKey: .expiration) }
//    }
//    
//    
//}
