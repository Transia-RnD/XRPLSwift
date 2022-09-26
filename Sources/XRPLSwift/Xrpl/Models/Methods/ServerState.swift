//
//  ServerState.swift
//
//
//  Created by Denis Angell on 7/30/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/methods/serverState.ts

import Foundation

/**
 The `server_state` command asks the server for various machine-readable
 information about the rippled server's current state. The response is almost
 the same as the server_info method, but uses units that are easier to process
 instead of easier to read.
 */
public class ServerStateRequest: BaseRequest {
    public init(
        // Base Request
        id: Int? = nil,
        apiVersion: Int? = nil
    ) {
        super.init(id: id, command: "server_state", apiVersion: apiVersion)
    }

    override public init(_ json: [String: AnyObject]) throws {
        try super.init(json)
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    //    override public func encode(to encoder: Encoder) throws {
    //        var values = encoder.container(keyedBy: CodingKeys.self)
    //        try super.encode(to: encoder)
    //    }
}

public class StateLedger: Codable {
    /// The time since the ledger was closed, in seconds.
    public let age: Int
    /**
     Base fee, in XRP. This may be represented in scientific notation.
     Such as 1e-05 for 0.00005.
     */
    public let baseFee: Int
    /// Unique hash for the ledger, as hexadecimal.
    public let hash: String
    /**
     Minimum amount of XRP (not drops) necessary for every account to.
     Keep in reserve .
     */
    public let reserveBase: Int
    /**
     Amount of XRP (not drops) added to the account reserve for each
     object an account owns in the ledger.
     */
    public let reserveInc: Int
    /// The ledger index of the latest validated ledger.
    public let seq: Int

    enum CodingKeys: String, CodingKey {
        case age = "age"
        case baseFee = "base_fee"
        case hash = "hash"
        case reserveBase = "reserve_base"
        case reserveInc = "reserve_inc"
        case seq = "seq"
    }
}

// public class ServerStateWrapper: Codable {
//    /**
//     If true, this server is amendment blocked. If the server is not
//     amendment blocked, the response omits this field.
//     */
//    public let amendmentBlocked: Bool?
//    /*The version number of the running rippled version. */
//    public let buildVersion: String
//    /**
//     Information on the most recently closed ledger that has not been
//     validated by consensus. If the most recently validated ledger is
//     available, the response omits this field and includes
//     `validated_ledger` instead. The member fields are the same as the.
//     `validated_ledger` field.
//     */
//    public let closedLedger: StateLedger?
//    /**
//     Range expression indicating the sequence numbers of the ledger
//     versions the local rippled has in its database.
//     */
//    public let completeLedgers: String
//    /**
//     Amount of time spent waiting for I/O operations, in milliseconds. If
//     this number is not very, very low, then the rippled server is probably
//     having serious load issues.
//     */
//    public let ioLatencyMs: Int
//    /**
//     The number of times (since starting up) that this server has had over
//     250 transactions waiting to be processed at once. A large number here
//     may mean that your server is unable to handle the transaction load of
//     the XRP Ledger network.
//     */
//    public let jqTransOverflow: String
//    /**
//     Information about the last time the server closed a ledger, including
//     the amount of time it took to reach a consensus and the number of
//     trusted validators participating.
//     */
//    public let lastClose: LastClosed
//    /**
//     (Admin only) Detailed information about the current load state of the
//     server.
//     */
//    public let load: StateLoad?
//    public var loadBase: Int
//    /**
//     The load-scaled open ledger transaction cost the server is currently
//     enforcing, as a multiplier on the base transaction cost. For example,
//     at 1000 load factor and a reference transaction cost of 10 drops of
//     XRP, the load-scaled transaction cost is 10,000 drops (0.01 XRP). The
//     load factor is determined by the highest of the individual server's
//     load factor, the cluster's load factor, the open ledger cost and the
//     overall network's load factor.
//     */
//    public var loadFactor: Int
//    /**
//     The current multiplier to the transaction cost that a transaction must
//     pay to get into the open ledger.
//     */
//    public let loadFactorFeeEscalation: Int?
//    /**
//     The current multiplier to the transaction cost that a transaction must
//     pay to get into the queue, if the queue is full.
//     */
//    public var loadFactorFeeQueue: Int?
//    public var loadFactorFeeReference: Int?
//    /**
//     The load factor the server is enforcing, not including the open ledger
//     cost.
//     */
//    public let loadFactorServer: Int?
//    /*How many other rippled servers this one is currently connected to. */
//    public let peers: Int
//    /**
//     Public key used to verify this server for peer-to-peer communications.
//     This node key pair is automatically generated by the server the first
//     time it starts up. (If deleted, the server can create a new pair of
//     Keys.).
//     */
//    public let pubkeyNode: String
//    /*Public key used by this node to sign ledger validations. */
//    public let pubkeyValidator: String?
//    /**
//     A string indicating to what extent the server is participating in the
//     network.
//     */
//    public let serverState: ServerState
//    /**
//     The number of consecutive microseconds the server has been in the
//     current state.
//     */
//    public let serverStateDurationUs: Int
//    /**
//     A map of various server states with information about the time the
//     server spends in each. This can be useful for tracking the long-term
//     health of your server's connectivity to the network.
//     */
//    public let stateAccounting: [ServerState: StateAccounting]
//    /*The current time in UTC, according to the server's clock. */
//    public let time: String
//    /*Number of consecutive seconds that the server has been operational. */
//    public let uptime: Int
//    /*Information about the most recent fully-validated ledger. */
//    public let validatedLedger: StateLedger?
//    /**
//     Minimum number of trusted validations required to validate a ledger
//     version. Some circumstances may cause the server to require more
//     validations.
//     */
//    public let validationQuorum: Int
//    /**
//     Either the human readable time, in UTC, when the current validator
//     list will expire, the string unknown if the server has yet to load a
//     published validator list or the string never if the server uses a
//     static validator list.
//     */
//    public let validatorListExpires: String?
//
//    enum CodingKeys: String, CodingKey {
//        case amendmentBlocked = "amendment_blocked"
//        case buildVersion = "build_version"
//        case closedLedger = "closed_ledger"
//        case completeLedgers = "complete_ledgers"
//        case ioLatencyMs = "io_latency_ms"
//        case jqTransOverflow = "jq_trans_overflow"
//        case lastClose = "last_close"
//        case load = "load"
//        case loadBase = "load_base"
//        case loadFactor = "load_factor"
//        case loadFactorFeeEscalation = "load_factor_fee_escalation"
//        case loadFactorFeeQueue = "load_factor_fee_queue"
//        case loadFactorFeeReference = "load_factor_fee_reference"
//        case loadFactorServer = "load_factor_server"
//        case networkLedger = "network_ledger"
//        case peers = "peers"
//        case pubkeyNode = "pubkey_node"
//        case pubkeyValidator = "pubkey_validator"
//        case serverState = "server_state"
//        case serverStateDurationUs = "server_state_duration_us"
//        case stateAccounting = "state_accounting"
//        case time = "time"
//        case uptime = "uptime"
//        case validatedLedger = "validated_ledger"
//        case validationQuorum = "validation_quorum"
//        case validatorListExpires = "validator_list_expires"
//    }
//
//    public required init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        amendmentBlocked = try values.decode(Bool.self, forKey: .amendmentBlocked)
//        buildVersion = try values.decode(String.self, forKey: .buildVersion)
//        closedLedger = try values.decode(StateLedger.self, forKey: .closedLedger)
//        completeLedgers = try values.decode(String.self, forKey: .completeLedgers)
//        ioLatencyMs = try values.decode(Int.self, forKey: .ioLatencyMs)
//        jqTransOverflow = try values.decode(String.self, forKey: .jqTransOverflow)
//        lastClose = try values.decode(LastClosed.self, forKey: .lastClose)
//        load = try values.decode(StateLoad.self, forKey: .load)
//        loadBase = try values.decode(Int.self, forKey: .loadBase)
//        loadFactor = try values.decode(Int.self, forKey: .loadFactor)
//        loadFactorFeeEscalation = try values.decode(Int.self, forKey: .loadFactorFeeEscalation)
//        loadFactorFeeQueue = try values.decode(Int.self, forKey: .loadFactorFeeQueue)
//        loadFactorFeeReference = try values.decode(Int.self, forKey: .loadFactorFeeReference)
//        loadFactorServer = try values.decode(Int.self, forKey: .loadFactorServer)
//        peers = try values.decode(Int.self, forKey: .peers)
//        pubkeyNode = try values.decode(String.self, forKey: .pubkeyNode)
//        pubkeyValidator = try values.decode(String.self, forKey: .pubkeyValidator)
//        serverState = try values.decode(String.self, forKey: .serverState)
//        serverStateDurationUs = try values.decode(Int.self, forKey: .serverStateDurationUs)
//        stateAccounting = try values.decode([ServerState: StateAccounting].self, forKey: .stateAccounting)
//        time = try values.decode(String.self, forKey: .time)
//        uptime = try values.decode(Int.self, forKey: .uptime)
//        validatedLedger = try values.decode(StateLedger.self, forKey: .validatedLedger)
//        validationQuorum = try values.decode(Int.self, forKey: .validationQuorum)
//        validatorListExpires = try values.decode(String.self, forKey: .validatorListExpires)
//    }
//
//    func toJson() throws -> [String: AnyObject] {
//        let data = try JSONEncoder().encode(self)
//        let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
//        return jsonResult as! [String: AnyObject]
//    }
// }

/**
 Response expected from a {@link ServerStateRequest}.
 */
public class ServerStateResponse: Codable {
    public let state: ServerInfoWrapper
}
