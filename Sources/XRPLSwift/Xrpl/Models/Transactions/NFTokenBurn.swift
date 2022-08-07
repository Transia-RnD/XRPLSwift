//
//  NFTokenBurn.swift
//  AnyCodable
//
//  Created by Denis Angell on 3/20/22.
//

import Foundation

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/transactions/NFTokenBurn.ts


/**
The NFTokenBurn transaction is used to remove an NFToken object from the
NFTokenPage in which it is being held, effectively removing the token from
the ledger ("burning" it).
If this operation succeeds, the corresponding NFToken is removed. If this
operation empties the NFTokenPage holding the NFToken or results in the
consolidation, thus removing an NFTokenPage, the owner’s reserve requirement
is reduced by one.
*/
public class NFTokenBurn: BaseTransaction {
    
//    public var account: String
    /**
    Identifies the AccountID that submitted this transaction. The account must
    be the present owner of the token or, if the lsfBurnable flag is set
    on the NFToken, either the issuer account or an account authorized by the
    issuer (i.e. MintAccount). This field is required.
    :meta hide-value:
    */

    public let nftokenId: String
    /**
    Identifies the NFToken to be burned. This field is required.
    :meta hide-value:
    */

    public let owner: String?
    /**
    Indicates which account currently owns the token if it is different than
    Account. Only used to burn tokens which have the lsfBurnable flag enabled
    and are not owned by the signing account.
    */
    
    public init(
        account: String,
        nftokenId: String,
        owner: String? = nil
    ) {
//        self.account = account
        self.nftokenId = nftokenId
        self.owner = owner
        super.init(account: account, transactionType: "NFTokenBurn")
    }
    
    enum CodingKeys: String, CodingKey {
        case account = "Account"
        case nftokenId = "NFTokenId"
        case owner = "Owner"
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
//        account = try values.decode(String.self, forKey: .account)
        nftokenId = try values.decode(String.self, forKey: .nftokenId)
        owner = try? values.decode(String.self, forKey: .owner)
        try super.init(from: decoder)
    }
    
    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
//        try values.encode(account, forKey: .account)
        try values.encode(nftokenId, forKey: .nftokenId)
        if let owner = owner { try values.encode(owner, forKey: .owner) }
    }
}