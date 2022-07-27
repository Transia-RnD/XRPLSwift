//
//  TrustSet.swift
//  AnyCodable
//
//  Created by Mitch Lang on 2/4/20.
//

import Foundation

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/models/transactions/trust_set.py

public enum TrustSetFlag: UInt32 {
    /*
    Transactions of the TrustSet type support additional values in the Flags field.
    This enum represents those options.
     */

    case tfSetAuth = 0x00010000
    /*
    Authorize the other party to hold
    `currency issued by this account <https://xrpl.org/tokens.html>`_.
    (No effect unless using the `asfRequireAuth AccountSet flag
    <https://xrpl.org/accountset.html#accountset-flags>`_.) Cannot be unset.
     */

    case tfSetNoRipple = 0x00020000
    /*
    Enable the No Ripple flag, which blocks
    `rippling <https://xrpl.org/rippling.html>`_ between two trust
    lines of the same currency if this flag is enabled on both.
    */

    case tfClearNoRipple = 0x00040000
    // Disable the No Ripple flag, allowing rippling on this trust line.

    case tfSetFreeze = 0x00100000
    // Freeze the trust line.

    case tfClearFreeze = 0x00200000
    // Unfreeze the trust line.
}

public class TrustSet: Transaction {
    /*
    Represents a TrustSet transaction on the XRP Ledger.
    Creates or modifies a trust line linking two accounts.
    `See TrustSet <https://xrpl.org/trustset.html>`_
    */

    public var limitAmount: IssuedCurrencyAmount
    /*
    This field is required.
    :meta hide-value:
    */

    public var qualityIn: Int?

    public var qualityOut: Int?
    
    public init(
        from wallet: Wallet,
        limitAmount: IssuedCurrencyAmount
    ) {
        self.limitAmount = limitAmount
        
        // TODO: Write into using variables on model not fields. (Serialize Later in Tx)
        // Sets the fields for the tx
        var _fields: [String:Any] = [
            "TransactionType": "TrustSet",
            "LimitAmount": [
                "currency": limitAmount.currency,
                "value": limitAmount.drops,
                "issuer": limitAmount.issuer
            ],
            "Flags": UInt64(131072),
        ]
        
        super.init(wallet: wallet, fields: _fields)
    }

}
