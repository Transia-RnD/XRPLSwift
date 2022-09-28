//
//  DirectoryNode.swift
//
//
//  Created by Denis Angell on 7/30/22.
//

import Foundation

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/ledger/DirectoryNode.ts

/**
 The DirectoryNode object type provides a list of links to other objects in
 the ledger's state tree.
 */
open class DirectoryNode: BaseLedgerEntry {
    var ledgerEntryType: String = "DirectoryNode"
    /**
     A bit-map of boolean flags enabled for this directory. Currently, the
     protocol defines no flags for DirectoryNode objects.
     */
    var flags: Int
    /// The ID of root object for this directory.
    let rootIndex: String
    /// The contents of this Directory: an array of IDs of other objects.
    let indexes: [String]
    /**
     If this Directory consists of multiple pages, this ID links to the next
     object in the chain, wrapping around at the end.
     */
    let indexNext: Int?
    /**
     If this Directory consists of multiple pages, this ID links to the
     previous object in the chain, wrapping around at the beginning.
     */
    let indexPrevious: Int?
    /// The address of the account that owns the objects in this directory.
    let owner: String?
    /**
     The currency code of the TakerPays amount from the offers in this
     directory.
     */
    let takerPaysCurrency: String?
    /// The issuer of the TakerPays amount from the offers in this directory.
    let takerPaysIssuer: String?
    /**
     The currency code of the TakerGets amount from the offers in this
     directory.
     */
    let takerGetsCurrency: String?
    /// The issuer of the TakerGets amount from the offers in this directory.
    let takerGetsIssuer: String?

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        flags = try values.decode(Int.self, forKey: .flags)
        rootIndex = try values.decode(String.self, forKey: .rootIndex)
        indexes = try values.decode([String].self, forKey: .indexes)
        indexNext = try values.decode(Int.self, forKey: .indexNext)
        indexPrevious = try values.decode(Int.self, forKey: .indexPrevious)
        owner = try values.decode(String.self, forKey: .owner)
        takerPaysCurrency = try values.decode(String.self, forKey: .takerPaysCurrency)
        takerPaysIssuer = try values.decode(String.self, forKey: .takerPaysIssuer)
        takerGetsCurrency = try values.decode(String.self, forKey: .takerGetsCurrency)
        takerGetsIssuer = try values.decode(String.self, forKey: .takerGetsIssuer)
        try super.init(from: decoder)
    }

    enum CodingKeys: String, CodingKey {
        case flags = "Flags"
        case rootIndex = "RootIndex"
        case indexes = "Indexes"
        case indexNext = "IndexNext"
        case indexPrevious = "IndexPrevious"
        case owner = "Owner"
        case takerPaysCurrency = "TakerPaysCurrency"
        case takerPaysIssuer = "TakerPaysIssuer"
        case takerGetsCurrency = "TakerGetsCurrency"
        case takerGetsIssuer = "TakerGetsIssuer"
    }
}
