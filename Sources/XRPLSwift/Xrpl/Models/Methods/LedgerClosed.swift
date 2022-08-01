////
////  File.swift
////  
////
////  Created by Denis Angell on 7/30/22.
////
//
//// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/methods/ledgerClosed.ts
//
//import Foundation
//
//
///**
// * The ledger_closed method returns the unique identifiers of the most recently
// * closed ledger. Expects a response in the form of a {@link
// * LedgerClosedResponse}.
// *
// * @example
// *  *
// * ```ts
// * const ledgerClosed: LedgerClosedRequest = {
// *   "command": "ledger_closed"
// * }
// * ```
// *
// * @category Requests
// */
//open class LedgerClosedRequest: BaseRequest {
//    let command: String = "ledger_closed"
//}
//
///**
// * The response expected from a {@link LedgerClosedRequest}.
// *
// * @category Responses
// */
//open class LedgerClosedResponse: BaseResponse {
//  result: {
//      let ledger_hash: String
//      let ledger_index: Int
//  }
//}
