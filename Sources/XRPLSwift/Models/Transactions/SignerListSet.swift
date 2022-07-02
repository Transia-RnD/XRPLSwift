//
//  SignerListSet.swift
//  AnyCodable
//
//  Created by Mitch Lang on 2/10/20.
//

import Foundation

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/models/transactions/signer_list_set.py

public struct SignerEntry {
    var Account: String
    var SignerWeight: Int
}

public class SignerListSet: Transaction {
    /*
    Represents a `SignerListSet <https://xrpl.org/signerlistset.html>`_
    transaction, which creates, replaces, or removes a list of signers that
    can be used to `multi-sign a transaction
    <https://xrpl.org/multi-signing.html>`_.
    */

    public var signerQuorum: UInt32
    /*
    This field is required.
    :meta hide-value:
    */
    public var signerEntries: [SignerEntry] = []
    
    public init(
        wallet: Wallet,
        signerQuorum: UInt32,
        signerEntries: [SignerEntry]
    ) {
        self.signerQuorum = signerQuorum
        self.signerEntries = signerEntries
        
        let signers = signerEntries.map { (signerEntry) -> NSDictionary in
            return NSDictionary(dictionary: [
                "SignerEntry" : NSDictionary(dictionary: [
                    "Account" : signerEntry.Account,
                    "SignerWeight" : signerEntry.SignerWeight,
                ])
            ])
        }
            
        // TODO: Write into using variables on model not fields. (Serialize Later in Tx)
        // Sets the fields for the tx
        let _fields: [String:Any] = [
            "TransactionType": "SignerListSet",
            "SignerQuorum": signerQuorum,
            "SignerEntries": signers
        ]
    
        super.init(wallet: wallet, fields: _fields)
    }

}
