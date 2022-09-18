//
//  FeeSettings.swift
//  
//
//  Created by Denis Angell on 7/30/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/ledger/FeeSettings.ts

import Foundation

/**
 The FeeSettings object type contains the current base transaction cost and
 reserve amounts as determined by fee voting.
 *
 @category Ledger Entries
 */
open class FeeSettings: BaseLedgerEntry {
    var ledgerEntryType: String = "FeeSettings"
    var flags: Int

    /**
     The transaction cost of the "reference transaction" in drops of XRP as
     hexadecimal.
     */
    let baseFee: String
    /// The BaseFee translated into "fee units".
    let referenceFeeUnits: Int
    /// The base reserve for an account in the XRP Ledger, as drops of XRP.
    let reserveBase: Int
    /// The incremental owner reserve for owning objects, as drops of XRP.
    let reserveIncrement: Int
    /**
     A bit-map of boolean flags for this object. No flags are defined for this
     type.
     */
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        flags = try values.decode(Int.self, forKey: .flags)
        baseFee = try values.decode(String.self, forKey: .baseFee)
        referenceFeeUnits = try values.decode(Int.self, forKey: .referenceFeeUnits)
        reserveBase = try values.decode(Int.self, forKey: .reserveBase)
        reserveIncrement = try values.decode(Int.self, forKey: .reserveIncrement)
        try super.init(from: decoder)
    }

    enum CodingKeys: String, CodingKey {
        case flags = "Flags"
        case baseFee = "BaseFee"
        case referenceFeeUnits = "ReferenceFeeUnits"
        case reserveBase = "ReserveBase"
        case reserveIncrement = "ReserveIncrement"
    }
}
