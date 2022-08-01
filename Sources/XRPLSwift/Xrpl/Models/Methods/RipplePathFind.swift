////
////  File.swift
////  
////
////  Created by Denis Angell on 7/30/22.
////
//
//// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/methods/ripplePathFind.ts
//
//import Foundation
//
//
//struct SourceCurrencyAmount {
//    let currency: String
//    let issuer?: String
//}
//
///**
// * The `ripple_path_find` method is a simplified version of the path_find method
// * that provides a single response with a payment path you can use right away.
// * Expects a response in the form of a {@link RipplePathFindResponse}.
// *
// * @category Requests
// */
//open class RipplePathFindRequest: BaseRequest {
//    let command: String = "ripple_path_find"
//  /** Unique address of the account that would send funds in a transaction. */
//    let source_account: String
//  /** Unique address of the account that would receive funds in a transaction. */
//    let destination_account: String
//  /**
//   * Currency Amount that the destination account would receive in a
//   * transaction.
//   */
//    let destination_amount: Amount
//  /**
//   * Currency Amount that would be spent in the transaction. Cannot be used
//   * with `source_currencies`.
//   */
//    let send_max?: Amount
//  /**
//   * Array of currencies that the source account might want to spend. Each
//   * entry in the array should be a JSON object with a mandatory currency field
//   * and optional issuer field, like how currency amounts are specified.
//   */
//    let source_currencies?: SourceCurrencyAmount
//  /** A 20-byte hex string for the ledger version to use. */
//    let ledger_hash?: String
//  /**
//   * The ledger index of the ledger to use, or a shortcut string to choose a
//   * ledger automatically.
//   */
//    let ledger_index?: LedgerIndex
//}
//
//struct PathOption {
//  /** Array of arrays of objects defining payment paths. */
//    let paths_computed: Path[]
//  /**
//   * Currency amount that the source would have to send along this path for the
//   * destination to receive the desired amount.
//   */
//    let source_amount: Amount
//}
//
///**
// * Response expected from a {@link RipplePathFindRequest}.
// *
// * @category Responses
// */
//open class RipplePathFindResponse: BaseResponse {
//  result: {
//    /**
//     * Array of objects with possible paths to take, as described below. If
//     * empty, then there are no paths connecting the source and destination
//     * accounts.
//     */
//      let alternatives: PathOption[]
//    /** Unique address of the account that would receive a payment transaction. */
//      let destination_account: String
//    /**
//     * Array of strings representing the currencies that the destination
//     * accepts, as 3-letter codes like "USD" or as 40-character hex like
//     * "015841551A748AD2C1F76FF6ECB0CCCD00000000".
//     */
//      let destination_currencies: [String]
//      let destination_amount: Amount
//      let full_reply?: Bool
//      let id?: Int | String
//      let ledger_current_index?: Int
//      let source_account: String
//      let validated: boolean
//  }
//}
