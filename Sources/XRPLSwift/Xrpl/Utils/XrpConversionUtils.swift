//
//  XrpConversion.swift
//
//
//  Created by Denis Angell on 9/4/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/utils/xrpConversion.ts

import BigInt
import Foundation

let DROPS_PER_XRP: Double = 1000000.0 // swiftlint:disable:this identifier_name
let MAX_FRACTION_LENGTH: Int = 6 // swiftlint:disable:this identifier_name
// let BASE_TEN: Int = 10 // swiftlint:disable:this identifier_name
let SANITY_CHECK: String = "/^-?[0-9.]+$/u" // swiftlint:disable:this identifier_name

/**
 Convert Drops to XRP.
 - parameters:
    - dropsToConvert: Drops to convert to XRP. This can be a string, number, or BigNumber.
 - returns:
 Amount in XRP.
 - throws:
 When drops amount is invalid.
 */
public func dropsToXrp(_ dropsToConvert: Any) throws -> String {
    /**
     Converting to BigNumber and then back to string should remove any
     decimal point followed by zeros, e.g. '1.00'.
     Important: specify base BASE_10 to avoid exponential notation, e.g. '1e-7'.
     */

    /// check that the value is valid and actually a number
    guard dropsToConvert is String, let drops = Decimal(string: dropsToConvert as! String)?.description else {
        throw ValidationError("dropsToXrp: invalid value '\(dropsToConvert)', should be a Decimal or string-encoded number.")
    }

    /// drops are only whole units
    if drops.contains(where: { $0 == "." }) {
        throw ValidationError("dropsToXrp: value '\(drops)' has too many decimal places.")
    }

    /**
     This should never happen; the value has already been
     validated above. This just ensures BigNumber did not do
     something unexpected.
     */
    //  if (!SANITY_CHECK.exec(drops)) {
    //          throw ValidationError.validation(
    //      "dropsToXrp: failed sanity check -" +
    //        " value '${drops}'," +
    //        " does not match (^-?[0-9]+$).",
    //    )
    //  }

    return String(describing: Decimal(string: drops)! / Decimal(DROPS_PER_XRP))
}

/**
 Convert an amount in XRP to an amount in drops.
 - parameters:
    - xrpToConvert: Amount in XRP.
 - returns:
 Amount in drops.
 - throws:
 When amount in xrp is invalid.
 */
public func xrpToDrops(_ xrpToConvert: Any) throws -> String {
    /// Important: specify base BASE_TEN to avoid exponential notation, e.g. '1e-7'.
    /// check that the value is valid and actually a number
    guard xrpToConvert is String, let xrp = Decimal(string: xrpToConvert as! String)?.description else {
        throw ValidationError("xrpToConvert: invalid value '\(xrpToConvert)', should be a Decimal or string-encoded number.")
    }

    /**
     This should never happen; the value has already been
     validated above. This just ensures BigNumber did not do
     something unexpected.
     */
    //  if (!SANITY_CHECK.exec(xrp)) {
    //    throw new ValidationError(
    //      `xrpToDrops: failed sanity check - value '${xrp}', does not match (^-?[0-9.]+$).`,
    //    )
    //  }

    let components = xrp.split(separator: ".")
    if components.count > 2 {
        throw ValidationError("xrpToDrops: failed sanity check - value '${xrp}' has too many decimal points.")
    }

    let fraction = components.count > 1 ? String(components[1]) : "0"
    if fraction.count > MAX_FRACTION_LENGTH {
        throw ValidationError("xrpToDrops: value '\(xrp)' has too many decimal places.")
    }

    return String(describing: Decimal(string: xrp)! * Decimal(DROPS_PER_XRP))
}
