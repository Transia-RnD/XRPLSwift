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
}
