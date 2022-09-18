//
//  LedgerHashes.swift
//  
//
//  Created by Denis Angell on 7/30/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/ledger/LedgerHashes.ts

import Foundation

/**
 The LedgerHashes objects exist to make it possible to look up a previous
 ledger's hash with only the current ledger version and at most one lookup of
 a previous ledger version.
 */
open class LedgerHashes: BaseLedgerEntry {
    let ledgerEntryType: String = "LedgerHashes"
    /// The Ledger Index of the last entry in this object's Hashes array.
    let lastLedgerSequence: Int?
    /**
     An array of up to 256 ledger hashes. The contents depend on which sub-type
     of LedgerHashes object this is.
     */
    let hashes: [String]
    /**
     A bit-map of boolean flags for this object. No flags are defined for this
     type.
     */
    var flags: Int
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        flags = try values.decode(Int.self, forKey: .flags)

        lastLedgerSequence = try values.decode(Int.self, forKey: .lastLedgerSequence)
        hashes = try values.decode([String].self, forKey: .hashes)
        try super.init(from: decoder)
    }

    enum CodingKeys: String, CodingKey {
        case flags = "Flags"
        case lastLedgerSequence = "LastLedgerSequence"
        case hashes = "Hashes"
    }
}
