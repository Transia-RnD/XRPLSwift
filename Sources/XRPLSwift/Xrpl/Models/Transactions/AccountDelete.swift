//
//  AccountDelete.swift
//  AnyCodable
//
//  Created by Mitch Lang on 2/4/20.
//  Updated by Denis Angell on 6/4/22.
//

import Foundation

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/models/transactions/account_delete.py

public class AccountDelete: Transaction {
    
    /*
    Represents an `AccountDelete transaction
    <https://xrpl.org/accountdelete.html>`_, which deletes an account and any
    objects it owns in the XRP Ledger, if possible, sending the account's remaining
    XRP to a specified destination account.
    See `Deletion of Accounts
    <https://xrpl.org/accounts.html#deletion-of-accounts>`_ for the requirements to
    delete an account.
    */
    
    public var destination: Address
    /*
    The address of the account to which to send any remaining XRP.
    This field is required.
    :meta hide-value:
    */
    public var destinationTag: Int?
    /*
    The `destination tag
    <https://xrpl.org/source-and-destination-tags.html>`_ at the
    ``destination`` account where funds should be sent.
    */
    
    public init(
        from wallet: Wallet,
        destination: Address,
        destinationTag: Int?
    ) {
        self.destination = destination
        self.destinationTag = destinationTag
        
        // TODO: Write into using variables on model not fields. (Serialize Later in Tx)
        // Sets the fields for the tx
        var _fields: [String:Any] = [
            "TransactionType": TransactionType.AccountDelete.rawValue,
            "Destination": destination
        ]
        
        if let dTag = destinationTag {
            _fields["DestinationTag"] = dTag
        }
        
        super.init(wallet: wallet, fields: _fields)
    }
}
