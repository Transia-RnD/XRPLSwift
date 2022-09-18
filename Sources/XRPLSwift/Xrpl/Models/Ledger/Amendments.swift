//
//  Amendments.swift
//  
//
//  Created by Denis Angell on 7/30/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/ledger/Amendments.ts

import Foundation

/**
 The Majority object type contains an amendment and close time
 */
open class Majority: Codable {
    /// The Amendment ID of the pending amendment.
    let amendment: String
    /**
     The `close_time` field of the ledger version where this amendment most
     recently gained a majority.
     */
    let closeTime: Int

    enum CodingKeys: String, CodingKey {
        case amendment = "Amendment"
        case closeTime = "CloseTime"
    }
}

/**
 The Amendments object type contains a list of Amendments that are currently
 active.
 */
open class Amendments: Codable {
    var ledgerEntryType: String = "Amendments"
    /**
     Array of 256-bit amendment IDs for all currently-enabled amendments. If
     omitted, there are no enabled amendments.
     */
    let amendments: [String]?
    /**
     Array of objects describing the status of amendments that have majority
     support but are not yet enabled. If omitted, there are no pending
     amendments with majority support.
     */
    let majorities: [Majority]?
    /**
     A bit-map of boolean flags. No flags are defined for the Amendments object
     type, so this value is always 0.
     */
    var flags: Int = 0

    enum CodingKeys: String, CodingKey {
        case amendments = "Amendments"
        case majorities = "Majorities"
        case flags = "Flags"
    }
}
