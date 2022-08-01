////
////  File.swift
////  
////
////  Created by Denis Angell on 7/30/22.
////
//
//// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/methods/ledgerCurrent.ts
//
//import Foundation
//
//
///**
// * The ledger_current method returns the unique identifiers of the current
// * in-progress ledger. Expects a response in the form of a {@link
// * LedgerCurrentResponse}.
// *
// * @example
// * ```ts
// * const ledgerCurrent: LedgerCurrentRequest = {
// *   "command": "ledger_current"
// * }
// * ```
// *
// * @category Requests
// */
//open class LedgerCurrentRequest: BaseRequest {
//    let command: String = "ledger_current"
//}
//
///**
// * Response expected from a {@link LedgerCurrentRequest}.
// *
// * @category Responses
// */
//open class LedgerCurrentResponse: BaseResponse {
//  result: {
//    /** The ledger index of this ledger version. */
//      let ledger_current_index: Int
//  }
//}
