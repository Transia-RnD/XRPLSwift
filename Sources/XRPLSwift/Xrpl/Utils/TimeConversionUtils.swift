//
//  TimeConversionUtils.swift
//
//
//  Created by Denis Angell on 9/9/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/utils/timeConversion.ts

import Foundation

/// Convert a ripple timestamp to a unix timestamp.
///
/// - Parameter rpepoch: (seconds since 1/1/2000 GMT).
/// - Returns: Milliseconds since unix epoch.
func rippleTimeToUnixTime(_ rpepoch: Int) -> Int {
    // swiftlint:disable:next identifier_name
    let RIPPLE_EPOCH_DIFF: Int = 0x386d4380
    return (rpepoch + RIPPLE_EPOCH_DIFF) * 1000
}

/// Convert a unix timestamp to a ripple timestamp.
///
/// - Parameter timestamp: (ms since unix epoch).
/// - Returns: Seconds since Ripple Epoch (1/1/2000 GMT).
func unixTimeToRippleTime(_ timestamp: Int) -> Int {
    // swiftlint:disable:next identifier_name
    let RIPPLE_EPOCH_DIFF: Int = 0x386d4380
    return Int(round(Double(timestamp) / 1000)) - RIPPLE_EPOCH_DIFF
}

/// Convert a ripple timestamp to an Iso8601 timestamp.
///
/// - Parameter rippleTime: Is the number of seconds since Ripple Epoch (1/1/2000 GMT).
/// - Returns: Iso8601 international standard date format.
func rippleTimeToISOTime(_ rippleTime: Int) -> String {
    return Date(timeIntervalSince1970: TimeInterval(rippleTimeToUnixTime(rippleTime))).description
}

/// Convert an ISO8601 timestmap to a ripple timestamp.
///
/// - Parameter iso8601: International standard date format.
/// - Returns: Seconds since ripple epoch (1/1/2000 GMT).
func isoTimeToRippleTime(_ iso8601: String) -> Int {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    let date = formatter.date(from: iso8601)
    return unixTimeToRippleTime(Int((date ?? Date()).timeIntervalSince1970 * 1000))
}

/// Convert an ISO8601 timestmap to a ripple timestamp.
///
/// - Parameter iso8601: International standard date format.
/// - Returns: Seconds since ripple epoch (1/1/2000 GMT).
func isoTimeToRippleTime(_ iso8601: Date) -> Int {
    return unixTimeToRippleTime(Int(iso8601.timeIntervalSince1970 * 1000))
}
