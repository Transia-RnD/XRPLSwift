//
//  SetHook.swift
//  AnyCodable
//
//  Created by Mitch Lang on 2/10/20.
//  Updated by Denis Angell on 6/4/22.
//

import Foundation

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/models/transactions/set_hook.py

public enum AccountSetFlag: UInt32 {
    case asfAccountTxId = 5
    case asfDefaultRipple = 8
    case asfDepositAuth = 9
    case asfDisableMaster = 4
}

public class SetHook: Transaction {
    /*
    Represents an `SetHook transaction <https://xrpl.org/accountset.html>`_,
    which modifies the properties of an account in the XRP Ledger.
    */
    
    public var stateKey: String?
    /*
    Add a state key
    <https://xrpl.org/sethook.html#accountset-flags>`_
    */
    
    public var txnID: Int?
    /*
    Enable a specific `AccountSet Flag
    <https://xrpl.org/sethook.html#accountset-flags>`_
    */
    
    public var namespace: String?
    /*
    Set the namespace of the hook. Must be hex-encoded. You can
    use `xrpl.utils.str_to_hex` to convert a UTF-8 string to hex.
    */
    

    public init(
        wallet: Wallet,
        clearFlag: AccountSetFlag?,
        setFlag: AccountSetFlag?,
        domain: String?,
        emailHash: String?,
        messageKey: Int?,
        transferRate: Int?,
        tickSize: Int?,
        nfTokenMinter: String?
    ) {
        self.clearFlag = clearFlag
        self.setFlag = setFlag
        self.domain = domain
        self.emailHash = emailHash
        self.messageKey = messageKey
        self.transferRate = transferRate
        self.tickSize = tickSize
        self.nfTokenMinter = nfTokenMinter
        
        // TODO: Write into using variables on model not fields. (Serialize Later in Tx)
        // Sets the fields for the tx
        var _fields: [String:Any] = [
            "TransactionType" : TransactionType.SetHook.rawValue
        ]

        
        super.init(wallet: wallet, fields: _fields)
    }
}
