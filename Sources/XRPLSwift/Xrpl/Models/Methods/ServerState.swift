////
////  File.swift
////
////
////  Created by Denis Angell on 7/30/22.
////
//
//// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/methods/serverState.ts
//
// import Foundation
//
//
/// **
// The `server_state` command asks the server for various machine-readable
// information about the rippled server's current state. The response is almost
// the same as the server_info method, but uses units that are easier to process
// instead of easier to read.
// *
// @category Requests
// */
// open class ServerStateRequest: BaseRequest {
//    let command: String = "server_state"
// }
//
/// **
// Response expected from a {@link ServerStateRequest}.
// *
// @category Responses
// */
// open class ServerStateResponse: BaseResponse {
//  result: {
//    state: {
//      amendment_blocked?: Bool
//      build_version: String
//      complete_ledgers: String
//      closed_ledger?: {
//        age: Int
//        base_fee: Int
//        hash: string
//        reserve_base: Int
//        reserve_inc: Int
//        seq: Int
//      }
//      io_latency_ms: Int
//      jq_trans_overflow: String
//      last_close: {
//        converge_time_s: Int
//        proposers: Int
//      }
//      load?: {
//        job_types: JobType[]
//        threads: Int
//      }
//      load_base: Int
//      load_factor: Int
//      load_factor_fee_escalation?: Int
//      load_factor_fee_queue?: Int
//      load_factor_fee_reference?: Int
//      load_factor_server?: Int
//      peers: Int
//      pubkey_node: String
//      pubkey_validator?: String
//      server_state: ServerState
//      server_state_duration_us: Int
//      state_accounting: Record<ServerState, StateAccounting>
//      time: String
//      uptime: Int
//      validated_ledger?: {
//        age: Int
//        base_fee: Int
//        hash: String
//        reserve_base: Int
//        reserve_inc: Int
//        seq: Int
//      }
//      validation_quorum: Int
//      validator_list_expires?: String
//    }
//  }
// }
