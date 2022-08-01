//
//  AccountObjects.swift
//
//
//  Created by Denis Angell on 7/30/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/methods/accountObjects.ts

import Foundation
import AnyCodable

/**
 * Account Objects can be a Check, a DepositPreauth, an Escrow, an Offer, a
 * PayChannel, a SignerList, a Ticket, or a RippleState.
 */
//type AccountObject =
//| Check
//| DepositPreauth
//| Escrow
//| Offer
//| PayChannel
//| SignerList
//| Ticket
//| RippleState

public enum AccountObject: Codable {
    case check(Check)
    case depositPreauth(DepositPreauth)
    case escrow(Escrow)
    case offer(Offer)
    case paymentChannel(PayChannel)
    case signerList(SignerList)
//    case ticket(Ticket)
    case rippleState(RippleState)
}

extension AccountObject {

    enum AccountObjectCodingError: Error {
        case decoding(String)
    }

    public init(from decoder: Decoder) throws {
        if let value = try? Check.init(from: decoder) {
            self = .check(value)
            return
        }
        if let value = try? DepositPreauth.init(from: decoder) {
            self = .depositPreauth(value)
            return
        }
        if let value = try? Escrow.init(from: decoder) {
            self = .escrow(value)
            return
        }
        if let value = try? Offer.init(from: decoder) {
            self = .offer(value)
            return
        }
        if let value = try? PayChannel.init(from: decoder) {
            self = .paymentChannel(value)
            return
        }
        if let value = try? SignerList.init(from: decoder) {
            self = .signerList(value)
            return
        }
//        if let value = try? Ticket.init(from: decoder) {
//            self = .ticket(value)
//            return
//        }
        if let value = try? RippleState.init(from: decoder) {
            self = .rippleState(value)
            return
        }
        throw AccountObjectCodingError.decoding("OOPS")
    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .check(let check):
            try check.encode(to: encoder)
        case .depositPreauth(let depositPreauth):
            try depositPreauth.encode(to: encoder)
        case .escrow(let escrow):
            try escrow.encode(to: encoder)
        case .offer(let offer):
            try offer.encode(to: encoder)
        case .paymentChannel(let paymentChannel):
            try paymentChannel.encode(to: encoder)
        case .signerList(let signerList):
            try signerList.encode(to: encoder)
//        case .ticket(let depositPreauth):
//            try ticket.encode(to: encoder)
        case .rippleState(let rippleState):
            try rippleState.encode(to: encoder)
        }
    }
}


/**
 * The account_objects command returns the raw ledger format for all objects
 * owned by an account. For a higher-level view of an account's trust lines and
 * balances, see the account_lines method instead. Expects a response in the
 * form of an {@link AccountObjectsResponse}.
 *
 * @category Requests
 */
public class AccountObjectsRequest: BaseRequest {
//    public let command: String = "account_objects"
    /** A unique identifier for the account, most commonly the account's address. */
    public let account: String
    /**
     * If included, filter results to include only this type of ledger object.
     * The valid types are: Check , DepositPreauth, Escrow, Offer, PayChannel,
     * SignerList, Ticket, and RippleState (trust line).
     */
    public let type: AccountObjectType?
    /**
     * If true, the response only includes objects that would block this account
     * from being deleted. The default is false.
     */
    public let deletionBlockersOnly: Bool?
    /** A 20-byte hex string for the ledger version to use. */
    public let ledgerHash: String?
    /**
     * The ledger index of the ledger to use, or a shortcut string to choose a
     * Ledger automatically.
     */
    public let ledgerIndex: rLedgerIndex?
    /**
     * The maximum number of objects to include in the results. Must be within
     * the inclusive range 10 to 400 on non-admin connections. The default is 200.
     */
    public let limit: Int?
    /**
     * Value from a previous paginated response. Resume retrieving data where
     * that response left off.
     */
    public let marker: AnyCodable?
    
    enum CodingKeys: String, CodingKey {
        case account = "account"
        case type = "type"
        case deletionBlockersOnly = "deletion_blockers_only"
        case ledgerHash = "ledger_hash"
        case ledgerIndex = "ledger_index"
        case limit = "limit"
        case marker = "marker"
    }
    
    public init(
        // Required
        account: String,
        // Base
        id: Int? = nil,
        apiVersion: Int? = nil,
        // Optional
        type: AccountObjectType? = nil,
        deletionBlockersOnly: Bool? = nil,
        ledgerHash: String? = nil,
        ledgerIndex: rLedgerIndex? = nil,
        limit: Int? = nil,
        marker: AnyCodable? = nil
    ) {
        // Required
        self.account = account
        // Optional
        self.type = type
        self.deletionBlockersOnly = deletionBlockersOnly
        self.ledgerHash = ledgerHash
        self.ledgerIndex = ledgerIndex
        self.limit = limit
        self.marker = marker
        super.init(id: id, command: "account_objects", apiVersion: apiVersion)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try values.encode(account, forKey: .account)
        if let type = type { try values.encode(type, forKey: .type) }
        if let deletionBlockersOnly = deletionBlockersOnly { try values.encode(deletionBlockersOnly, forKey: .deletionBlockersOnly) }
        if let ledgerHash = ledgerHash { try values.encode(ledgerHash, forKey: .ledgerHash) }
        if let ledgerIndex = ledgerIndex { try values.encode(ledgerIndex, forKey: .ledgerIndex) }
        if let limit = limit { try values.encode(limit, forKey: .limit) }
        if let marker = marker { try values.encode(marker, forKey: .marker) }
    }
}

/**
 * Response expected from an {@link AccountObjectsRequest}.
 *
 * @category Responses
 */
public class AccountObjectsResponse: Codable {
    /** Unique Address of the account this request corresponds to. */
    public let account: String
    /**
     * Array of objects owned by this account. Each object is in its raw
     * ledger format.
     */
    public let accountObjects: [AccountObject]
    /**
     * The identifying hash of the ledger that was used to generate this
     * response.
     */
    public let ledgerHash: String?
    /**
     * The ledger index of the ledger version that was used to generate this
     * response.
     */
    public let ledgerIndex: Int?
    /**
     * The ledger index of the current in-progress ledger version, which was
     * used to generate this response.
     */
    public let ledgerCurrentIndex: Int?
    /** The limit that was used in this request, if any. */
    public let limit: Int?
    /**
     * Server-defined value indicating the response is paginated. Pass this to
     * the next call to resume where this call left off. Omitted when there are
     * no additional pages after this one.
     */
    public let marker: AnyCodable?
    /**
     * If included and set to true, the information in this response comes from
     * a validated ledger version. Otherwise, the information is subject to
     * change.
     */
    public let validated: Bool?
    
    enum CodingKeys: String, CodingKey {
        case account = "account"
        case accountObjects = "account_objects"
        case ledgerHash = "ledger_hash"
        case ledgerIndex = "ledger_index"
        case ledgerCurrentIndex = "ledger_current_index"
        case limit = "limit"
        case marker = "marker"
        case validated = "validated"
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        account = try values.decode(String.self, forKey: .account)
        accountObjects = try values.decode([AccountObject].self, forKey: .accountObjects)
        ledgerHash = try? values.decode(String.self, forKey: .ledgerHash)
        ledgerIndex = try? values.decode(Int.self, forKey: .ledgerIndex)
        ledgerCurrentIndex = try? values.decode(Int.self, forKey: .ledgerCurrentIndex)
        limit = try? values.decode(Int.self, forKey: .limit)
        marker = try? values.decode(AnyCodable.self, forKey: .marker)
        validated = try? values.decode(Bool.self, forKey: .validated)
//        try super.init(from: decoder)
    }
}
