////
////  File.swift
////  
////
////  Created by Denis Angell on 7/30/22.
////
//
//// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/methods/ledgerData.ts
//
//import Foundation
//
//
///**
// * The `ledger_data` method retrieves contents of the specified ledger. You can
// * iterate through several calls to retrieve the entire contents of a single
// * ledger version.
// *
// * @example
// * ```ts
// * const ledgerData: LedgerDataRequest = {
// *   "id": 2,
// *   "ledger_hash": "842B57C1CC0613299A686D3E9F310EC0422C84D3911E5056389AA7E5808A93C8",
// *   "command": "ledger_data",
// *   "limit": 5,
// *   "binary": true
// * }
// * ```
// *
// * @category Requests
// */
//open class LedgerDataRequest: BaseRequest {
//    let command: String = "ledger_data"
//  /** A 20-byte hex string for the ledger version to use. */
//    let ledger_hash?: String
//  /**
//   * The ledger index of the ledger to use, or a shortcut string to choose a
//   * ledger automatically.
//   */
//    let ledger_index?: LedgerIndex
//  /**
//   * If set to true, return ledger objects as hashed hex strings instead of
//   * JSON.
//   */
//    let binary?: Bool
//  /**
//   * Limit the number of ledger objects to retrieve. The server is not required
//   * to honor this value.
//   */
//    let limit?: Int
//  /**
//   * Value from a previous paginated response. Resume retrieving data where
//   * that response left off.
//   */
//    let marker?: Any
//}
//
////type LabeledLedgerEntry = { ledgerEntryType: String } & LedgerEntry
//
//struct BinaryLedgerEntry {
//    let data: String
//}
//
////type State = { index: String } & (BinaryLedgerEntry | LabeledLedgerEntry)
//
///**
// * The response expected from a {@link LedgerDataRequest}.
// *
// * @category Responses
// */
//open class LedgerDataResponse: BaseResponse {
//  result: {
//    /** The ledger index of this ledger version. */
//      let ledger_index: Int
//    /** Unique identifying hash of this ledger version. */
//      let ledger_hash: String
//    /**
//     * Array of JSON objects containing data from the ledger's state tree,
//     * as defined below.
//     */
//      let state: State[]
//    /**
//     * Server-defined value indicating the response is paginated. Pass this to
//     * the next call to resume where this call left off.
//     */
//      let  marker?: Any
//      let validated?: Bool
//  }
//}
