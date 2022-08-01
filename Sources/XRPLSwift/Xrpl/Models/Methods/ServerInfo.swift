////
////  File.swift
////  
////
////  Created by Denis Angell on 7/30/22.
////
//
//// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/methods/serverInfo.ts
//
//import Foundation
//
///**
// * The `server_info` command asks the server for a human-readable version of
// * various information about the rippled server being queried. Expects a
// * response in the form of a {@link ServerInfoResponse}.
// *
// * @category Requests
// */
//open class ServerInfoRequest: BaseRequest {
//  command: String = "server_info"
//}
//
//export type ServerState =
//  | 'disconnected'
//  | 'connected'
//  | 'syncing'
//  | 'tracking'
//  | 'full'
//  | 'validating'
//  | 'proposing'
//
//open class StateAccounting {
//    let duration_us: String
//    let transitions: Int
//}
//
//open class JobType {
//    let job_type: String
//    let per_second: Int
//    let peak_time?: Int
//    let avg_time?: Int
//    let in_progress?: Int
//}
//
///**
// * Response expected from a {@link ServerInfoRequest}.
// *
// * @category Responses
// */
//open class ServerInfoResponse: BaseResponse {
//  result: {
//    info: {
//      /**
//       * If true, this server is amendment blocked. If the server is not
//       * amendment blocked, the response omits this field.
//       */
//      amendment_blocked?: Bool
//      /** The version number of the running rippled version. */
//      build_version: String
//      /**
//       * Information on the most recently closed ledger that has not been
//       * validated by consensus. If the most recently validated ledger is
//       * available, the response omits this field and includes
//       * `validated_ledger` instead. The member fields are the same as the.
//       * `validated_ledger` field.
//       */
//      closed_ledger?: {
//        age: Int
//        base_fee_xrp: Int
//        hash: string
//        reserve_base_xrp: Int
//        reserve_inc_xrp: Int
//        seq: Int
//      }
//      /**
//       * Range expression indicating the sequence numbers of the ledger
//       * versions the local rippled has in its database.
//       */
//      complete_ledgers: String
//      /**
//       * On an admin request, returns the hostname of the server running the
//       * rippled instance; otherwise, returns a single RFC-1751  word based on
//       * the node public key.
//       */
//      hostid: String
//      /**
//       * Amount of time spent waiting for I/O operations, in milliseconds. If
//       * this number is not very, very low, then the rippled server is probably
//       * having serious load issues.
//       */
//      io_latency_ms: Int
//      /**
//       * The number of times (since starting up) that this server has had over
//       * 250 transactions waiting to be processed at once. A large number here
//       * may mean that your server is unable to handle the transaction load of
//       * the XRP Ledger network.
//       */
//      jq_trans_overflow: String
//      /**
//       * Information about the last time the server closed a ledger, including
//       * the amount of time it took to reach a consensus and the number of
//       * trusted validators participating.
//       */
//      last_close: {
//        /**
//         * The amount of time it took to reach a consensus on the most recently
//         * validated ledger version, in seconds.
//         */
//        converge_time_s: Int
//        /**
//         * How many trusted validators the server considered (including itself,
//         * if configured as a validator) in the consensus process for the most
//         * recently validated ledger version.
//         */
//        proposers: Int
//      }
//      /**
//       * (Admin only) Detailed information about the current load state of the
//       * server.
//       */
//      load?: {
//        /**
//         * (Admin only) Information about the rate of different types of jobs
//         * the server is doing and how much time it spends on each.
//         */
//        job_types: JobType[]
//        /** (Admin only) The number of threads in the server's main job pool. */
//        threads: Int
//      }
//      /**
//       * The load-scaled open ledger transaction cost the server is currently
//       * enforcing, as a multiplier on the base transaction cost. For example,
//       * at 1000 load factor and a reference transaction cost of 10 drops of
//       * XRP, the load-scaled transaction cost is 10,000 drops (0.01 XRP). The
//       * load factor is determined by the highest of the individual server's
//       * load factor, the cluster's load factor, the open ledger cost and the
//       * overall network's load factor.
//       */
//      load_factor?: Int
//      /**
//       * Current multiplier to the transaction cost based on
//       * load to this server.
//       */
//      load_factor_local?: Int
//      /**
//       * Current multiplier to the transaction cost being used by the rest of
//       * the network.
//       */
//      load_factor_net?: Int
//      /**
//       * Current multiplier to the transaction cost based on load to servers
//       * in this cluster.
//       */
//      load_factor_cluster?: Int
//      /**
//       * The current multiplier to the transaction cost that a transaction must
//       * pay to get into the open ledger.
//       */
//      load_factor_fee_escalation?: Int
//      /**
//       * The current multiplier to the transaction cost that a transaction must
//       * pay to get into the queue, if the queue is full.
//       */
//      load_factor_fee_queue?: Int
//      /**
//       * The load factor the server is enforcing, not including the open ledger
//       * cost.
//       */
//      load_factor_server?: Int
//      network_ledger?: 'waiting'
//      /** How many other rippled servers this one is currently connected to. */
//      peers: Int
//      /**
//       * Public key used to verify this server for peer-to-peer communications.
//       * This node key pair is automatically generated by the server the first
//       * time it starts up. (If deleted, the server can create a new pair of
//       * Keys.).
//       */
//      pubkey_node: String
//      /** Public key used by this node to sign ledger validations. */
//      pubkey_validator?: String
//      /**
//       * A string indicating to what extent the server is participating in the
//       * network.
//       */
//      server_state: ServerState
//      /**
//       * The number of consecutive microseconds the server has been in the
//       * current state.
//       */
//      server_state_duration_us: Int
//      /**
//       * A map of various server states with information about the time the
//       * server spends in each. This can be useful for tracking the long-term
//       * health of your server's connectivity to the network.
//       */
//      state_accounting: Record<ServerState, StateAccounting>
//      /** The current time in UTC, according to the server's clock. */
//      time: String
//      /** Number of consecutive seconds that the server has been operational. */
//      uptime: Int
//      /** Information about the most recent fully-validated ledger. */
//      validated_ledger?: {
//        /** The time since the ledger was closed, in seconds. */
//        age: Int
//        /**
//         * Base fee, in XRP. This may be represented in scientific notation.
//         * Such as 1e-05 for 0.00005.
//         */
//        base_fee_xrp: Int
//        /** Unique hash for the ledger, as hexadecimal. */
//        hash: String
//        /**
//         * Minimum amount of XRP (not drops) necessary for every account to.
//         * Keep in reserve .
//         */
//        reserve_base_xrp: Int
//        /**
//         * Amount of XRP (not drops) added to the account reserve for each
//         * object an account owns in the ledger.
//         */
//        reserve_inc_xrp: Int
//        /** The ledger index of the latest validated ledger. */
//        seq: Int
//      }
//      /**
//       * Minimum number of trusted validations required to validate a ledger
//       * version. Some circumstances may cause the server to require more
//       * validations.
//       */
//      validation_quorum: Int
//      /**
//       * Either the human readable time, in UTC, when the current validator
//       * list will expire, the string unknown if the server has yet to load a
//       * published validator list or the string never if the server uses a
//       * static validator list.
//       */
//      validator_list_expires?: String
//    }
//  }
//}
