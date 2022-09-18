//
//  AccountInfo.swift
//
//
//  Created by Denis Angell on 7/30/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/methods/accountInfo.ts

import Foundation

/**
 The `account_info` command retrieves information about an account, its
 activity, and its XRP balance. All information retrieved is relative to a
 particular version of the ledger. Returns an {@link AccountInfoResponse}.
 *
 @category Requests
 */
public class AccountInfoRequest: BaseRequest {
//    let command: String = "account_info"
    /// A unique identifier for the account, most commonly the account's address.
    public let account: String
    /// A 20-byte hex string for the ledger version to use.
    public let ledgerHash: String?
    /**
     The ledger index of the ledger to use, or a shortcut string to choose a
     ledger automatically.
     */
    public let ledgerIndex: LedgerIndex?
    /**
     Whether to get info about this account's queued transactions. Can only be
     used when querying for the data from the current open ledger. Not available
     from servers in Reporting Mode.
     */
    public let queue: Bool?
    /**
     Request SignerList objects associated with this account.
     */
    public let signerLists: Bool?
    /**
     If true, then the account field only accepts a public key or XRP Ledger
     address. Otherwise, account can be a secret or passphrase (not
     recommended). The default is false.
     */
    public let strict: Bool?

    enum CodingKeys: String, CodingKey {
        case account = "account"
        case ledgerHash = "ledger_hash"
        case ledgerIndex = "ledger_index"
        case queue = "queue"
        case signerLists = "signer_lists"
        case strict = "strict"
    }

    public init(
        // Required
        account: String,
        // Base
        id: Int? = nil,
        apiVersion: Int? = nil,
        // Optional
        ledgerHash: String? = nil,
        ledgerIndex: LedgerIndex? = nil,
        queue: Bool? = nil,
        signerLists: Bool? = nil,
        strict: Bool? = nil
    ) {
        // Required
        self.account = account
        // Optional
        self.ledgerHash = ledgerHash
        self.ledgerIndex = ledgerIndex
        self.queue = queue
        self.signerLists = signerLists
        self.strict = strict
        super.init(id: id, command: "account_info", apiVersion: apiVersion)
    }

    override public init(_ json: [String: AnyObject]) throws {
        let decoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(AccountInfoRequest.self, from: data)
        // Required
        self.account = decoded.account
        // Optional
        self.ledgerHash = decoded.ledgerHash
        self.ledgerIndex = decoded.ledgerIndex
        self.queue = decoded.queue
        self.signerLists = decoded.signerLists
        self.strict = decoded.strict
        try super.init(json)
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        account = try values.decode(String.self, forKey: .account)
        ledgerHash = try values.decodeIfPresent(String.self, forKey: .ledgerHash)
        ledgerIndex = try values.decodeIfPresent(LedgerIndex.self, forKey: .ledgerIndex)
        queue = try values.decodeIfPresent(Bool.self, forKey: .queue)
        signerLists = try values.decodeIfPresent(Bool.self, forKey: .signerLists)
        strict = try values.decodeIfPresent(Bool.self, forKey: .strict)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try values.encode(account, forKey: .account)
        if let ledgerHash = ledgerHash { try values.encode(ledgerHash, forKey: .ledgerHash) }
        if let ledgerIndex = ledgerIndex { try values.encode(ledgerIndex, forKey: .ledgerIndex) }
        if let queue = queue { try values.encode(queue, forKey: .queue) }
        if let signerLists = signerLists { try values.encode(signerLists, forKey: .signerLists) }
        if let strict = strict { try values.encode(strict, forKey: .strict) }
    }
}

public struct QueueTransaction: Codable {
    /**
     Whether this transaction changes this address's ways of authorizing
     transactions.
     */
    public let authChange: Bool
    /// The Transaction Cost of this transaction, in drops of XRP.
    public let fee: String
    /**
     The transaction cost of this transaction, relative to the minimum cost for
     this type of transaction, in fee levels.
     */
    public let feeLevel: String
    /// The maximum amount of XRP, in drops, this transaction could send or destroy.
    public let maxSpendDrops: String
    /// The Sequence Number of this transaction.
    public let seq: Int
}

public struct QueueData: Codable {
    /// Number of queued transactions from this address.
    public let txnCount: Int
    /**
     Whether a transaction in the queue changes this address's ways of
     authorizing transactions. If true, this address can queue no further
     transactions until that transaction has been executed or dropped from the
     queue.
     */
    public let authChangeQueued: Bool?
    /// The lowest Sequence Number among transactions queued by this address.
    public let lowestSequence: Int?
    /// The highest Sequence Number among transactions queued by this address.
    public let highestSequence: Int?
    /**
     Integer amount of drops of XRP that could be debited from this address if
     every transaction in the queue consumes the maximum amount of XRP possible.
     */
    public let maxSpendDropsTotal: String?
    /// Information about each queued transaction from this address.
    public let transactions: [QueueTransaction]?
}

/**
 Response expected from an {@link AccountInfoRequest}.
 */
public class AccountInfoResponse: Codable {
    /**
     The AccountRoot ledger object with this account's information, as stored
     in the ledger.
     */
    public let accountData: AccountRoot
    /**
     Array of SignerList ledger objects associated with this account for
     Multi-Signing. Since an account can own at most one SignerList, this
     array must have exactly one member if it is present.
     */
    public let signerLists: [SignerList]?
    /**
     The ledger index of the current in-progress ledger, which was used when
     retrieving this information.
     */
    public let ledgerCurrentIndex: Int?
    /**
     The ledger index of the ledger version used when retrieving this
     information. The information does not contain any changes from ledger
     versions newer than this one.
     */
    // TODO: Ledger Hash isnt listed on this object, but is returned...
    public let ledgerIndex: Int?
    public let ledgerHash: String?
    /**
     Information about queued transactions sent by this account. This
     information describes the state of the local rippled server, which may be
     different from other servers in the peer-to-peer XRP Ledger network. Some
     fields may be omitted because the values are calculated "lazily" by the
     queuing mechanism.
     */
    public let queueData: QueueData?
    /**
     True if this data is from a validated ledger version; if omitted or set
     to false, this data is not final.
     */
    public let validated: Bool?

    private enum CodingKeys: String, CodingKey {
        case accountData = "account_data"
        case signerLists = "signer_lists"
        case ledgerCurrentIndex = "ledger_current_index"
        case ledgerIndex = "ledger_index"
        case ledgerHash = "ledger_hash"
        case queueData = "queue_data"
        case validated = "validated"
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        accountData = try values.decode(AccountRoot.self, forKey: .accountData)
        signerLists = try values.decodeIfPresent([SignerList].self, forKey: .signerLists)
        ledgerCurrentIndex = try values.decodeIfPresent(Int.self, forKey: .ledgerCurrentIndex)
        ledgerIndex = try values.decodeIfPresent(Int.self, forKey: .ledgerIndex)
        ledgerHash = try values.decodeIfPresent(String.self, forKey: .ledgerHash)
        queueData = try values.decodeIfPresent(QueueData.self, forKey: .queueData)
        validated = try values.decodeIfPresent(Bool.self, forKey: .validated)
    }

    func toJson() throws -> [String: AnyObject] {
        let data = try JSONEncoder().encode(self)
        let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        return jsonResult as! [String: AnyObject]
    }
}
