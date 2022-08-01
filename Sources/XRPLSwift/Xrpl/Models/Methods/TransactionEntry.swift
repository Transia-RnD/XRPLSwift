////
////  File.swift
////  
////
////  Created by Denis Angell on 7/30/22.
////
//
//// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/methods/transactionEntry.ts
//
//import Foundation
//
//
///**
// * The `transaction_entry` method retrieves information on a single transaction
// * from a specific ledger version. Expects a response in the form of a
// * {@link TransactionEntryResponse}.
// *
// * @category Requests
// */
//open class TransactionEntryRequest: BaseRequest {
//    let command: String = "transaction_entry"
//  /** A 20-byte hex string for the ledger version to use. */
//    let ledger_hash?: String
//  /**
//   * The ledger index of the ledger to use, or a shortcut string to choose a
//   * ledger automatically.
//   */
//    let ledger_index?: LedgerIndex
//  /** Unique hash of the transaction you are looking up. */
//    let tx_hash: String
//}
//
///**
// * Response expected from a {@link TransactionEntryRequest}.
// *
// * @category Responses
// */
//open class TransactionEntryResponse: BaseResponse {
//  result: {
//    /**
//     * The identifying hash of the ledger version the transaction was found in;
//     * this is the same as the one from the request.
//     */
//      let ledger_hash: String
//    /**
//     * The ledger index of the ledger version the transaction was found in;
//     * this is the same as the one from the request.
//     */
//      let ledger_index: Int
//    /**
//     * The transaction metadata, which shows the exact results of the
//     * transaction in detail.
//     */
//      let metadata: TransactionMetadata
//    /** JSON representation of the Transaction object. */
//      let tx_json: Transaction & ResponseOnlyTxInfo
//  }
//}
