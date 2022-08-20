//
//  SetHook.swift
//  AnyCodable
//
//  Created by Mitch Lang on 2/10/20.
//  Updated by Denis Angell on 6/4/22.
//

import Foundation

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/models/transactions/set_hook.py

public enum HookFlag: UInt32 {
    case asfAccountTxId = 5
}

public class SetHook: BaseTransaction {
    /*
    Represents an `SetHook transaction <https://xrpl.org/accountset.html>`_,
    which modifies the properties of an account in the XRP Ledger.
    */

    public var stateKey: String?
    /*
    Add a state key
    <https://xrpl.org/sethook.html#accountset-flags>`_
    */

    public var namespace: String?
    /*
    Set the namespace of the hook. Must be hex-encoded. You can
    use `xrpl.utils.str_to_hex` to convert a UTF-8 string to hex.
    */

    enum CodingKeys: String, CodingKey {
        case stateKey = "StateKey"
        case namespace = "Namespace"
    }

    public init(
        stateKey: String? = nil,
        namespace: String? = nil
    ) {
        self.stateKey = stateKey
        self.namespace = namespace

        // TODO: Write into using variables on model not fields. (Serialize Later in Tx)
        // Sets the fields for the tx
        super.init(account: "", transactionType: "SetHook")
    }

    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        stateKey = try values.decode(String.self, forKey: .stateKey)
        namespace = try values.decode(String.self, forKey: .namespace)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try values.encode(stateKey, forKey: .stateKey)
        try values.encode(namespace, forKey: .namespace)
    }
}
