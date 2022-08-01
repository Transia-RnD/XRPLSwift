////
////  File.swift
////  
////
////  Created by Denis Angell on 7/30/22.
////
//
//// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/methods/submit.ts
//
//import Foundation
//
//
///**
// * The submit method applies a transaction and sends it to the network to be
// * confirmed and included in future ledgers. Expects a response in the form of a
// * {@link SubmitResponse}.
// *
// * @category Requests
// */
//open class SubmitRequest: BaseRequest {
//  command: String = "submit"
//  /** The complete transaction in hex string format. */
//    let tx_blob: String
//  /**
//   * If true, and the transaction fails locally, do not retry or relay the
//   * transaction to other servers. The default is false.
//   */
//    let fail_hard?: Bool
//}
//
///**
// * Response expected from a {@link SubmitRequest}.
// *
// * @category Responses
// */
//open class SubmitResponse: BaseResponse {
//  result: {
//    /**
//     * Text result code indicating the preliminary result of the transaction,
//     * for example `tesSUCCESS`.
//     */
//      let engine_result: String
//    /** Numeric version of the result code. */
//      let engine_result_code: Int
//    /** Human-readable explanation of the transaction's preliminary result. */
//      let engine_result_message: String
//    /** The complete transaction in hex string format. */
//      let tx_blob: String
//    /** The complete transaction in JSON format. */
//      let tx_json: Transaction & { hash?: String }
//    /**
//     * The value true indicates that the transaction was applied, queued,
//     * broadcast, or kept for later. The value `false` indicates that none of
//     * those happened, so the transaction cannot possibly succeed as long as you
//     * do not submit it again and have not already submitted it another time.
//     */
//      let accepted: Bool
//    /**
//     * The next Sequence Number available for the sending account after all
//     * pending and queued transactions.
//     */
//      let account_sequence_available: Int
//    /**
//     * The next Sequence number for the sending account after all transactions
//     * that have been provisionally applied, but not transactions in the queue.
//     */
//      let account_sequence_next: Int
//    /**
//     * The value true indicates that this transaction was applied to the open
//     * ledger. In this case, the transaction is likely, but not guaranteed, to
//     * be validated in the next ledger version.
//     */
//      let applied: Bool
//    /**
//     * The value true indicates this transaction was broadcast to peer servers
//     * in the peer-to-peer XRP Ledger network.
//     */
//      let broadcast: Bool
//    /**
//     * The value true indicates that the transaction was kept to be retried
//     * later.
//     */
//      let kept: Bool
//    /**
//     * The value true indicates the transaction was put in the Transaction
//     * Queue, which means it is likely to be included in a future ledger
//     * version.
//     */
//      let queued: Bool
//    /**
//     * The current open ledger cost before processing this transaction
//     * transactions with a lower cost are likely to be queued.
//     */
//      let open_ledger_cost: String
//    /**
//     * The ledger index of the newest validated ledger at the time of
//     * submission. This provides a lower bound on the ledger versions that the
//     * transaction can appear in as a result of this request.
//     */
//      let validated_ledger_index: Int
//  }
//}
