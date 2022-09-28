//
//  Offer.swift
//
//
//  Created by Denis Angell on 7/30/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/ledger/Offer.ts

import Foundation

open class Offer: BaseLedgerEntry {
    var ledgerEntryType: String = "Offer"
    /// A bit-map of boolean flags enabled for this Offer.
    let flags: Int
    /// The address of the account that placed this Offer.
    let account: String
    /**
     The Sequence value of the OfferCreate transaction that created this Offer
     object. Used in combination with the Account to identify this Offer.
     */
    let sequence: Int
    /// The remaining amount and type of currency requested by the Offer creator.
    let takerPays: Amount
    /**
     The remaining amount and type of currency being provided by the Offer
     creator.
     */
    let takerGets: Amount
    /// The ID of the Offer Directory that links to this Offer.
    let bookDirectory: String
    /**
     A hint indicating which page of the Offer Directory links to this object,
     in case the directory consists of multiple pages.
     */
    let bookNode: String
    /**
     A hint indicating which page of the Owner Directory links to this object,
     in case the directory consists of multiple pages.
     */
    let ownerNode: String
    /**
     The identifying hash of the transaction that most recently modified this
     object.
     */
    let previousTxnId: String
    /**
     The index of the ledger that contains the transaction that most recently
     modified this object.
     */
    let previousTxnLgrSeq: Int
    /// The time this Offer expires, in seconds since the Ripple Epoch.
    let expiration: Int?

    enum CodingKeys: String, CodingKey {
        case flags = "Flags"
        case account = "Account"
        case sequence = "Sequence"
        case takerPays = "TakerPays"
        case takerGets = "TakerGets"
        case bookDirectory = "BookDirectory"
        case bookNode = "BookNode"
        case ownerNode = "OwnerNode"
        case previousTxnId = "PreviousTxnID"
        case previousTxnLgrSeq = "PreviousTxnLgrSeq"
        case expiration = "Expiration"
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        flags = try values.decode(Int.self, forKey: .flags)
        account = try values.decode(String.self, forKey: .account)
        sequence = try values.decode(Int.self, forKey: .sequence)
        takerPays = try values.decode(Amount.self, forKey: .takerPays)
        takerGets = try values.decode(Amount.self, forKey: .takerGets)
        bookDirectory = try values.decode(String.self, forKey: .bookDirectory)
        bookNode = try values.decode(String.self, forKey: .bookNode)
        ownerNode = try values.decode(String.self, forKey: .ownerNode)
        previousTxnId = try values.decode(String.self, forKey: .previousTxnId)
        previousTxnLgrSeq = try values.decode(Int.self, forKey: .previousTxnLgrSeq)
        expiration = try? values.decode(Int.self, forKey: .expiration)
        try super.init(from: decoder)
    }
}

public enum OfferFlags: Int {
    case lsfPassive = 0x00010000
    case lsfSell = 0x00020000
}
