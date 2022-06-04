//
//  NFTokenBurn.swift
//  AnyCodable
//
//  Created by Denis Angell on 3/20/22.
//

import Foundation

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/models/transactions/nftoken_burn.py

public class NFTokenBurn: Transaction {
    
    /*
    The NFTokenBurn transaction is used to remove an NFToken object from the
    NFTokenPage in which it is being held, effectively removing the token from
    the ledger ("burning" it).
    If this operation succeeds, the corresponding NFToken is removed. If this
    operation empties the NFTokenPage holding the NFToken or results in the
    consolidation, thus removing an NFTokenPage, the owner’s reserve requirement
    is reduced by one.
    */

    public var account: Address
    /*
    Identifies the AccountID that submitted this transaction. The account must
    be the present owner of the token or, if the lsfBurnable flag is set
    on the NFToken, either the issuer account or an account authorized by the
    issuer (i.e. MintAccount). This field is required.
    :meta hide-value:
    */

    public var nftokenId: String
    /*
    Identifies the NFToken to be burned. This field is required.
    :meta hide-value:
    */

    public var owner: String?
    /*
    Indicates which account currently owns the token if it is different than
    Account. Only used to burn tokens which have the lsfBurnable flag enabled
    and are not owned by the signing account.
    */
    
    public init(
        from wallet: Wallet,
        account: Address,
        nftokenId: String,
        owner: String? = nil
    ) {
        self.account = account
        self.nftokenId = nftokenId
        self.owner = owner
        
        // TODO: Write into using variables on model not fields. (Serialize Later in Tx)
        // Sets the fields for the tx
        let _fields: [String:Any] = [
            "TransactionType" : TransactionType.NFTokenBurn.rawValue,
            "nftoken_id": nftokenId
        ]
        
        super.init(wallet: wallet, fields: _fields)
    }
}
