//
//  SignerList.swift
//
//
//  Created by Denis Angell on 7/30/22.
//

// // https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/ledger/SignorList.ts

import Foundation

public class BaseSignerEntry: Codable {
    public var account: String
    public var signerWeight: Int

    enum CodingKeys: String, CodingKey {
        case account = "Account"
        case signerWeight = "SignerWeight"
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        account = try values.decode(String.self, forKey: .account)
        signerWeight = try values.decode(Int.self, forKey: .signerWeight)
    }
}

public class SignerEntry: Codable {
    public var signerEntry: BaseSignerEntry
    enum CodingKeys: String, CodingKey {
        case signerEntry = "SignerEntry"
    }
}

/**
 The SignerList object type represents a list of parties that, as a group,
 are authorized to sign a transaction in place of an individual account. You
 can create, replace, or remove a signer list using a SignerListSet
 transaction.
 */
public class SignerList: BaseLedgerEntry {
    public var ledgerEntryType: String = "SignerList"
    /**
     A bit-map of Boolean flags enabled for this signer list. For more
     information, see SignerList Flags.
     */
    public var flags: Int
    /**
     The identifying hash of the transaction that most recently modified this
     object.
     */
    public var previousTxnId: String
    /**
     The index of the ledger that contains the transaction that most recently
     modified this object.
     */
    public var previousTxnLgrSeq: Int
    /**
     A hint indicating which page of the owner directory links to this object,
     in case the directory consists of multiple pages.
     */
    public var ownerNode: String
    /**
     An array of Signer Entry objects representing the parties who are part of
     this signer list.
     */
    public var signerEntries: [SignerEntry]
    /**
     An ID for this signer list. Currently always set to 0. If a future
     amendment allows multiple signer lists for an account, this may change.
     */
    public var signerListId: Int
    /**
     A target number for signer weights. To produce a valid signature for the
     owner of this SignerList, the signers must provide valid signatures whose
     weights sum to this value or more.
     */
    public var signerQuorum: Int

    enum CodingKeys: String, CodingKey {
        case flags = "Flags"
        case previousTxnId = "PreviousTxnID"
        case previousTxnLgrSeq = "PreviousTxnLgrSeq"
        case ownerNode = "OwnerNode"
        case signerEntries = "SignerEntries"
        case signerListId = "SignerListID"
        case signerQuorum = "SignerQuorum"
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        flags = try values.decode(Int.self, forKey: .flags)
        previousTxnId = try values.decode(String.self, forKey: .previousTxnId)
        previousTxnLgrSeq = try values.decode(Int.self, forKey: .previousTxnLgrSeq)
        ownerNode = try values.decode(String.self, forKey: .ownerNode)
        signerEntries = try values.decode([SignerEntry].self, forKey: .signerEntries)
        signerListId = try values.decode(Int.self, forKey: .signerListId)
        signerQuorum = try values.decode(Int.self, forKey: .signerQuorum)
        try super.init(from: decoder)
    }
}

public enum SignerListFlags: Int {
    // True, uses only one OwnerCount
    case lsfOneOwnerCount = 0x00010000
}
