//
//  DepositPreauth.swift
//  
//
//  Created by Denis Angell on 7/30/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/ledger/DepositPreauth.ts

import Foundation


/**
 * A DepositPreauth object tracks a preauthorization from one account to
 * another. DepositPreauth transactions create these objects.
 *
 * @category Ledger Entries
 */
open class DepositPreauth_: BaseLedgerEntry {
    public var ledgerEntryType: String = "DepositPreauth"
    /** The account that granted the preauthorization. */
    public let account: String
    /** The account that received the preauthorization. */
    public let authorize: String
    /**
     * A bit-map of boolean flags. No flags are defined for DepositPreauth
     * objects, so this value is always 0.
     */
    public var flags: Int = 0
    /**
     * A hint indicating which page of the sender's owner directory links to this
     * object, in case the directory consists of multiple pages.
     */
    public let ownerNode: String
    /**
     * The identifying hash of the transaction that most recently modified this
     * object.
     */
    public let previousTxnId: String
    /**
     * The index of the ledger that contains the transaction that most recently
     * modified this object.
     */
    public let previousTxnLgrSeq: Int
    
    enum CodingKeys: String, CodingKey {
        case account = "Account"
        case authorize = "Authorize"
        case flags = "Flags"
        case ownerNode = "OwnerNode"
        case previousTxnId = "PreviousTxnID"
        case previousTxnLgrSeq = "PreviousTxnLgrSeq"
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        account = try values.decode(String.self, forKey: .account)
        authorize = try values.decode(String.self, forKey: .authorize)
        flags = try values.decode(Int.self, forKey: .flags)
        ownerNode = try values.decode(String.self, forKey: .ownerNode)
        previousTxnId = try values.decode(String.self, forKey: .previousTxnId)
        previousTxnLgrSeq = try values.decode(Int.self, forKey: .previousTxnLgrSeq)
        try super.init(from: decoder)
    }
}
