//
//  LedgerSpaces.swift
//  
//
//  Created by Denis Angell on 8/6/22.
//

import Foundation

/**
 * XRP Ledger namespace prefixes.
 *
 * The XRP Ledger is a key-value store. In order to avoid name collisions,
 * names are partitioned into namespaces.
 *
 * Each namespace is just a single character prefix.
 *
 * See [LedgerNameSpace enum](https://github.com/ripple/rippled/blob/master/src/ripple/protocol/LedgerFormats.h#L100).
 */
public enum LedgerSpaces: String {
    case account = "a"
    case dirNode = "d"
    case generatorMap = "g"
    case rippleState = "r"
    // Entry for an offer.
    case offer = "o"
    // Directory of things owned by an account.
    case ownerDir = "O"
    // Directory of order books.
    case bookDir = "B"
    case contract = "c"
    case skipList = "s"
    case escrow = "u"
    case amendment = "f"
    case feeSettings = "e"
    case ticket = "T"
    case signerList = "S"
    case paychan = "x"
    case check = "C"
    case depositPreauth = "p"

    public init(_ string: String) {
        switch string {
        case "account":
            self = .account
        case "dirNode":
            self = .dirNode
        case "generatorMap":
            self = .generatorMap
        case "rippleState":
            self = .rippleState
        case "offer":
            self = .offer
        case "ownerDir":
            self = .ownerDir
        case "bookDir":
            self = .bookDir
        case "contract":
            self = .contract
        case "skipList":
            self = .skipList
        case "escrow":
            self = .escrow
        case "amendment":
            self = .amendment
        case "feeSettings":
            self = .feeSettings
        case "ticket":
            self = .ticket
        case "signerList":
            self = .signerList
        case "paychan":
            self = .paychan
        case "check":
            self = .check
        case "depositPreauth":
            self = .depositPreauth
        default:
            // TODO: Why?
            self = .account
        }
    }
}
