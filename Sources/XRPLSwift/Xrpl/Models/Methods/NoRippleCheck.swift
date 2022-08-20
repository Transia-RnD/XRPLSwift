////
////  File.swift
////  
////
////  Created by Denis Angell on 7/30/22.
////
//
//// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/methods/norippleCheck.ts
//
// import Foundation
//
/// **
// * The `noripple_check` command provides a quick way to check the status of th
// * default ripple field for an account and the No Ripple flag of its trust
// * lines, compared with the recommended settings. Expects a response in the form
// * of an {@link NoRippleCheckResponse}.
// *
// * @example
// * ```ts
// * const noRipple: NoRippleCheckRequest = {
// *   "id": 0,
// *   "command": "noripple_check",
// *   "account": "r9cZA1mLK5R5Am25ArfXFmqgNwjZgnfk59",
// *    "role": "gateway",
// *   "ledger_index": "current",
// *   "limit": 2,
// *   "transactions": true
// * }
// * ```
// *
// * @category Requests
// */
// open class NoRippleCheckRequest: BaseRequest {
//    let command: String = "noripple_check"
//  /** A unique identifier for the account, most commonly the account's address. */
//    let account: String
//  /**
//   * Whether the address refers to a gateway or user. Recommendations depend on
//   * the role of the account. Issuers must have Default Ripple enabled and must
//   * disable No Ripple on all trust lines. Users should have Default Ripple
//   * disabled, and should enable No Ripple on all trust lines.
//   */
//    let role: 'gateway' | 'user'
//  /**
//   * If true, include an array of suggested transactions, as JSON objects,
//   * that you can sign and submit to fix the problems. Defaults to false.
//   */
//    let transactions?: Bool
//  /**
//   * The maximum number of trust line problems to include in the results.
//   * Defaults to 300.
//   */
//    let limit?: Int
//  /** A 20-byte hex string for the ledger version to use. */
//    let ledger_hash?: String
//  /**
//   * The ledger index of the ledger to use, or a shortcut string to choose a
//   * ledger automatically.
//   */
//    let ledger_index?: LedgerIndex
// }
//
/// **
// * Response expected by a {@link NoRippleCheckRequest}.
// *
// * @category Responses
// */
// open class NoRippleCheckResponse: BaseResponse {
//  result: {
//    /** The ledger index of the ledger used to calculate these results. */
//    ledger_current_index: Int
//    /**
//     * Array of strings with human-readable descriptions of the problems.
//     * This includes up to one entry if the account's Default Ripple setting is
//     * not as recommended, plus up to limit entries for trust lines whose no
//     * ripple setting is not as recommended.
//     */
//    problems: [String]
//    /**
//     * If the request specified transactions as true, this is an array of JSON
//     * objects, each of which is the JSON form of a transaction that should fix
//     * one of the described problems. The length of this array is the same as
//     * the problems array, and each entry is intended to fix the problem
//     * described at the same index into that array.
//     */
//    transactions: Array<Transaction & ResponseOnlyTxInfo>
//  }
