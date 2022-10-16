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
public class Majority: Codable {
    /// The Amendment ID of the pending amendment.
    public var amendment: String
    /**
     The `closeTime` field of the ledger version where this amendment most
     recently gained a majority.
     */
    public var closeTime: Int

    enum CodingKeys: String, CodingKey {
        case amendment = "Amendment"
        case closeTime = "CloseTime"
    }
}

/**
 The Amendments object type contains a list of Amendments that are currently
 active.
 */
public class Amendments: Codable {
    public var ledgerEntryType: String = "Amendments"
    /**
     Array of 256-bit amendment IDs for all currently-enabled amendments. If
     omitted, there are no enabled amendments.
     */
    public var amendments: [String]?
    /**
     Array of objects describing the status of amendments that have majority
     support but are not yet enabled. If omitted, there are no pending
     amendments with majority support.
     */
    public var majorities: [Majority]?
    /**
     A bit-map of boolean flags. No flags are defined for the Amendments object
     type, so this value is always 0.
     */
    public var flags: Int = 0

    enum CodingKeys: String, CodingKey {
        case amendments = "Amendments"
        case majorities = "Majorities"
        case flags = "Flags"
    }
}
