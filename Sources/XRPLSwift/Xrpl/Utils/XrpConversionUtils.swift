//
//  XrpConversion.swift
//  
//
//  Created by Denis Angell on 9/4/22.
//

import BigInt
import Foundation

// swiftlint:disable:next identifier_name
let DROPS_PER_XRP: Double = 1000000.0
// swiftlint:disable:next identifier_name
let MAX_FRACTION_LENGTH: Int = 6
// swiftlint:disable:next identifier_name
// let BASE_TEN: Int = 10
// swiftlint:disable:next identifier_name
let SANITY_CHECK: String = "/^-?[0-9.]+$/u"

/**
 * Convert Drops to XRP.
 *
 * @param dropsToConvert - Drops to convert to XRP. This can be a string, number, or BigNumber.
 * @returns Amount in XRP.
 * @throws When drops amount is invalid.
 * @category Utilities
 */
public func dropsToXrp(_ dropsToConvert: Any) throws -> String {
    /*
     * Converting to BigNumber and then back to string should remove any
     * decimal point followed by zeros, e.g. '1.00'.
     * Important: specify base BASE_10 to avoid exponential notation, e.g. '1e-7'.
     */
    let drops = String(BigInt(dropsToConvert as! Double), radix: BASE_TEN)

    // check that the value is valid and actually a number
    if dropsToConvert is String && !drops.isNumber {
        throw ValidationError("dropsToXrp: invalid value '\(dropsToConvert)', should be a BigNumber or string-encoded number.")
    }

    // drops are only whole units
    if drops.contains(where: { $0 == "." }) {
        throw ValidationError("dropsToXrp: value '\(drops)' has too many decimal places.")
    }

    /*
     * This should never happen; the value has already been
     * validated above. This just ensures BigNumber did not do
     * something unexpected.
     */
    //  if (!SANITY_CHECK.exec(drops)) {
    //          throw ValidationError.validation(
    //      "dropsToXrp: failed sanity check -" +
    //        " value '${drops}'," +
    //        " does not match (^-?[0-9]+$).",
    //    )
    //  }

    return String(BigInt(drops)! / BigInt(DROPS_PER_XRP), radix: BASE_10)
}

/**
 * Convert an amount in XRP to an amount in drops.
 *
 * @param xrpToConvert - Amount in XRP.
 * @returns Amount in drops.
 * @throws When amount in xrp is invalid.
 * @category Utilities
 */
public func xrpToDrops(_ xrpToConvert: Any) throws -> String {
    // Important: specify base BASE_TEN to avoid exponential notation, e.g. '1e-7'.
    let xrp = String(BigInt(xrpToConvert as! Double), radix: BASE_TEN)

    // check that the value is valid and actually a number
    if xrpToConvert is String && !xrp.isNumber {
        throw ValidationError(
            "xrpToDrops: invalid value '${xrpToConvert}', should be a BigNumber or string-encoded number."
        )
    }

    /*
     * This should never happen; the value has already been
     * validated above. This just ensures BigNumber did not do
     * something unexpected.
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

    let fraction = components[1] != nil ? String(components[1]) : "0"
    if fraction.count > MAX_FRACTION_LENGTH {
        throw ValidationError("xrpToDrops: value '${xrp}' has too many decimal places.")
    }

    return String(BigInt(xrp)! * BigInt(DROPS_PER_XRP), radix: BASE_TEN)
}
