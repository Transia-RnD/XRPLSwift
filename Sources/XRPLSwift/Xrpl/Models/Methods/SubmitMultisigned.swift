////
////  File.swift
////  
////
////  Created by Denis Angell on 7/30/22.
////
//
//// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/methods/submitMultisigned.ts
//
//import Foundation
//
//
///**
// * The `submit_multisigned` command applies a multi-signed transaction and sends
// * it to the network to be included in future ledgers. Expects a response in the
// * form of a {@link SubmitMultisignedRequest}.
// *
// * @category Requests
// */
//open class SubmitMultisignedRequest: BaseRequest {
//    let command: String = "submit_multisigned"
//  /**
//   * Transaction in JSON format with an array of Signers. To be successful, the
//   * weights of the signatures must be equal or higher than the quorum of the.
//   * {@link SignerList}.
//   */
//    let tx_json: Transaction
//  /**
//   * If true, and the transaction fails locally, do not retry or relay the
//   * transaction to other servers.
//   */
//    let fail_hard?: Bool
//}
//
///**
// * Response expected from a {@link SubmitMultisignedRequest}.
// *
// * @category Responses
// */
//open class SubmitMultisignedResponse: BaseResponse {
//  result: {
//    /**
//     * Code indicating the preliminary result of the transaction, for example.
//     * `tesSUCCESS` .
//     */
//      let engine_result: String
//    /**
//     * Numeric code indicating the preliminary result of the transaction,
//     * directly correlated to `engine_result`.
//     */
//      let engine_result_code: Int
//    /** Human-readable explanation of the preliminary transaction result. */
//      let engine_result_message: String
//    /** The complete transaction in hex string format. */
//      let tx_blob: String
//    /** The complete transaction in JSON format. */
//      let tx_json: Transaction & { hash?: String }
//  }
//}
