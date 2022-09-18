//
//  File.swift
//  
//
//  Created by Denis Angell on 9/17/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/utils/flags.ts

import Foundation

/**
 Convert an AccountRoot Flags number into an interface for easy interpretation.
 - parameters:
 - flags: A number which is the bitwise and of all enabled AccountRootFlagsInterface.
 - returns:
 An interface with all flags as booleans.
 */
public func parseAccountRootFlags(
    flags: Int
) -> [AccountRootFlags: Bool] {
    var flagsInterface: [AccountRootFlags: Bool] = [:]
    AccountRootFlags.allCases.forEach { flag in
        if isFlagEnabled(flags: flags, checkFlag: flag.rawValue) {
            flagsInterface[flag] = true
        }
    }
    return flagsInterface
}

/**
 Sets a transaction"s flags to its numeric representation.
 - parameters:
 - tx: A transaction to set its flags to its numeric representation.
 */
public func setTransactionFlagsToNumber(tx: inout [String: AnyObject]) throws {
    if tx["Flags"] == nil {
        tx["Flags"] = 0 as AnyObject
        return
    }
    if tx["Flags"] is Int {
        return
    }

    // swiftlint:disable:next force_cast
    switch tx["TransactionType"] as! String {
    case "AccountSet":
        // swiftlint:disable:next force_cast
        tx["Flags"] = try convertAccountSetFlagsToNumber(flags: tx["Flags"] as! [AccountSetTfFlags]) as AnyObject
        return
    case "OfferCreate":
        // swiftlint:disable:next force_cast
        tx["Flags"] = try convertOfferCreateFlagsToNumber(flags: tx["Flags"] as! [OfferCreateFlags]) as AnyObject
        return
    case "PaymentChannelClaim":
        // swiftlint:disable:next force_cast
        tx["Flags"] = try convertPaymentChannelClaimFlagsToNumber(flags: tx["Flags"] as! [PaymentChannelClaimFlag]) as AnyObject
        return
    case "Payment":
        // swiftlint:disable:next force_cast
        tx["Flags"] = try convertPaymentTransactionFlagsToNumber(flags: tx["Flags"] as! [PaymentFlags]) as AnyObject
        return
    case "TrustSet":
        // swiftlint:disable:next force_cast
        tx["Flags"] = try convertTrustSetFlagsToNumber(flags: tx["Flags"] as! [TrustSetFlag]) as AnyObject
        return
    default:
        tx["Flags"] = 0 as AnyObject
    }
}

func convertAccountSetFlagsToNumber(
    flags: [AccountSetTfFlags]
) throws -> Int {
    let interface = flags.interface
    return try interface.keys.reduce(0) { resultFlags, flag in
        if AccountSetTfFlags(rawValue: flag.rawValue) == nil {
            throw ValidationError("flag \(flag) does not exist in flagEnum: \(AccountSetTfFlags.self)")
        }
        // swiftlint:disable:next force_unwrapping
        return interface[flag]! == true
        ? resultFlags | flag.rawValue : resultFlags
    }
}

func convertOfferCreateFlagsToNumber(
  flags: [OfferCreateFlags]
) throws -> Int {
    let interface = flags.interface
    return try interface.keys.reduce(0) { resultFlags, flag in
        if OfferCreateFlags(rawValue: flag.rawValue) == nil {
            throw ValidationError("flag \(flag) does not exist in flagEnum: \(OfferCreateFlags.self)")
        }
        // swiftlint:disable:next force_unwrapping
        return interface[flag]! == true
        ? resultFlags | flag.rawValue : resultFlags
    }
}

func convertPaymentChannelClaimFlagsToNumber(
  flags: [PaymentChannelClaimFlag]
) throws -> Int {
    let interface = flags.interface
    return try interface.keys.reduce(0) { resultFlags, flag in
        if PaymentChannelClaimFlag(rawValue: flag.rawValue) == nil {
            throw ValidationError("flag \(flag) does not exist in flagEnum: \(PaymentChannelClaimFlag.self)")
        }
        // swiftlint:disable:next force_unwrapping
        return interface[flag]! == true
        ? resultFlags | flag.rawValue : resultFlags
    }
}

func convertPaymentTransactionFlagsToNumber(
  flags: [PaymentFlags]
) throws -> Int {
    let interface = flags.interface
    return try interface.keys.reduce(0) { resultFlags, flag in
        if PaymentFlags(rawValue: flag.rawValue) == nil {
            throw ValidationError("flag \(flag) does not exist in flagEnum: \(PaymentFlags.self)")
        }
        // swiftlint:disable:next force_unwrapping
        return interface[flag]! == true
        ? resultFlags | flag.rawValue : resultFlags
    }
}

func convertTrustSetFlagsToNumber(
    flags: [TrustSetFlag]
) throws -> Int {
    let interface = flags.interface
    return try interface.keys.reduce(0) { resultFlags, flag in
        if TrustSetFlag(rawValue: flag.rawValue) == nil {
            throw ValidationError("flag \(flag) does not exist in flagEnum: \(TrustSetFlag.self)")
        }
        // swiftlint:disable:next force_unwrapping
        return interface[flag]! == true
        ? resultFlags | flag.rawValue : resultFlags
    }
}
