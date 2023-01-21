//
//  LEFeeSettings.swift
//
//
//  Created by Denis Angell on 7/30/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/ledger/FeeSettings.ts

import Foundation

/**
 The FeeSettings object type contains the current base transaction cost and
 reserve amounts as determined by fee voting.
 */
public class LEFeeSettings: BaseLedgerEntry {
    public var ledgerEntryType: String = "FeeSettings"
    public var flags: Int

    /**
     The transaction cost of the "reference transaction" in drops of XRP as
     hexadecimal.
     */
    public var baseFee: String
    /// The BaseFee translated into "fee units".
    public var referenceFeeUnits: Int
    /// The base reserve for an account in the XRP Ledger, as drops of XRP.
    public var reserveBase: Int
    /// The incremental owner reserve for owning objects, as drops of XRP.
    public var reserveIncrement: Int
    /**
     A bit-map of boolean flags for this object. No flags are defined for this
     type.
     */

    enum CodingKeys: String, CodingKey {
        case flags = "Flags"
        case baseFee = "BaseFee"
        case referenceFeeUnits = "ReferenceFeeUnits"
        case reserveBase = "ReserveBase"
        case reserveIncrement = "ReserveIncrement"
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        flags = try values.decode(Int.self, forKey: .flags)
        baseFee = try values.decode(String.self, forKey: .baseFee)
        referenceFeeUnits = try values.decode(Int.self, forKey: .referenceFeeUnits)
        reserveBase = try values.decode(Int.self, forKey: .reserveBase)
        reserveIncrement = try values.decode(Int.self, forKey: .reserveIncrement)
        try super.init(from: decoder)
    }

    override public init(json: [String: AnyObject]) throws {
        let decoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(LEFeeSettings.self, from: data)
        flags = decoded.flags
        baseFee = decoded.baseFee
        referenceFeeUnits = decoded.referenceFeeUnits
        reserveBase = decoded.reserveBase
        reserveIncrement = decoded.reserveIncrement
        try super.init(json: json)
    }
}
