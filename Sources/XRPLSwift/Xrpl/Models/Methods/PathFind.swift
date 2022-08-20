////
////  File.swift
////  
////
////  Created by Denis Angell on 7/30/22.
////
//
//// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/methods/pathFind.ts
//
// import Foundation
//
//
// class BasePathFindRequest: BaseRequest {
//    let command: String = "path_find"
//    let subcommand: String
// }
//
/// ** Start sending pathfinding information. */
// open class PathFindCreateRequest: BasePathFindRequest {
//    let subcommand: String = "create"
//  /**
//   * Unique address of the account to find a path from. In other words, the.
//   * Account that would be sending a payment.
//   */
//    let source_account: String
//  /** Unique address of the account to find a path to. */
//    let destination_account: String
//  /**
//   * Currency Amount that the destination account would receive in a
//   * transaction.
//   */
//    let destination_amount: Amount
//  /** Currency amount that would be spent in the transaction. */
//    let send_max?: Amount
//  /**
//   * Array of arrays of objects, representing payment paths to check. You can
//   * use this to keep updated on changes to particular paths you already know
//   * about, or to check the overall cost to make a payment along a certain path.
//   */
//    let paths?: Path[]
// }
//
/// ** Stop sending pathfinding information. */
// open classPathFindCloseRequest: BasePathFindRequest {
//    let subcommand: String = "close"
// }
//
/// ** Get the information of the currently-open pathfinding request. */
// open class PathFindStatusRequest: BasePathFindRequest {
//    let subcommand: String = "status"
// }
//
/// **
// * The `path_find` method searches for a path along which a transaction can
// * possibly be made, and periodically sends updates when the path changes over
// * time. For a simpler version that is supported by JSON-RPC, see the
// * `ripple_path_find` method.
// *
// * @category Requests
// */
// export type PathFindRequest =
//  | PathFindCreateRequest
//  | PathFindCloseRequest
//  | PathFindStatusRequest
//
// struct PathOption {
//  /** Array of arrays of objects defining payment paths. */
//    let paths_computed: Path[]
//  /**
//   * Currency Amount that the source would have to send along this path for the.
//   * Destination to receive the desired amount.
//   */
//    let source_amount: Amount
// }
//
/// **
// * Response expected from a {@link PathFindRequest}.
// *
// * @category Responses
// */
// open class PathFindResponse: BaseResponse {
//  result: {
//    /**
//     * Array of objects with suggested paths to take, as described below. If
//     * empty, then no paths were found connecting the source and destination
//     * accounts.
//     */
//      let alternatives: PathOption[]
//    /** Unique address of the account that would receive a transaction. */
//      let destination_account: string
//    /** Currency amount that the destination would receive in a transaction. */
//      let destination_amount: Amount
//    /** Unique address that would send a transaction. */
//      let source_account: string
//    /**
//     * If false, this is the result of an incomplete search. A later reply
//     * may have a better path. If true, then this is the best path found. (It is
//     * still theoretically possible that a better path could exist, but rippled
//     * won't find it.) Until you close the pathfinding request, rippled.
//     * Continues to send updates each time a new ledger closes.
//     */
//      let full_reply: Bool
//    /**
//     * The ID provided in the WebSocket request is included again at this
//     * level.
//     */
//      let id?: Int | String
//    /**
//     * The value true indicates this reply is in response to a path_find close
//     * command.
//     */
//      let closed?: true
//    /**
//     * The value true indicates this reply is in response to a `path_find`
//     * status command.
//     */
//      let status?: true
//  }
// }
