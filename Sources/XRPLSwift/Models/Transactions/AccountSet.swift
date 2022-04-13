//
//  AccountSet.swift
//  AnyCodable
//
//  Created by Mitch Lang on 2/10/20.
//

import Foundation

public enum AccountSetFlag: UInt32 {
    case asfAccountTxId = 5
    case asfDefaultRipple = 8
    case asfDepositAuth = 9
    case asfDisableMaster = 4
    case asfDisallowXrp = 3
    case asfGlobalFreeze = 7
    case asfNoFreeze = 6
    case asfRequirAuth = 2
    case asfRequireDest = 1
    case asfAuthorizedMinter = 10
}

public class AccountSet: Transaction {
    
    public init(
        wallet: Wallet,
        set: AccountSetFlag?,
        clear: AccountSetFlag?,
        domain: String?,
        emailHash: String?,
        transferRate: Int?,
        tickSize: Int?,
        minter: String?
    ) {
        var _fields: [String:Any] = [
            "TransactionType" : "AccountSet"
        ]
        if let set = set {
            _fields["SetFlag"] = set.rawValue
        }
        if let clear = clear {
            _fields["ClearFlag"] = clear.rawValue
        }
        
        // TODO: Hex
        if let domain = domain {
            _fields["Domain"] = domain
        }
        
        // TODO: Hex
        if let emailHash = emailHash {
            _fields["EmailHash"] = emailHash
        }
        
        if let transferRate = transferRate {
            _fields["TransferRate"] = transferRate
        }
        
        if let tickSize = tickSize {
            _fields["TickSize"] = tickSize
        }
        
        if let minter = minter {
            _fields["Minter"] = minter
        }
        
        super.init(wallet: wallet, fields: _fields)
    }
}
