//
//  AccountChannels.swift
//  
//
//  Created by Denis Angell on 7/30/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/methods/accountChannels.ts

import Foundation
import AnyCodable

public struct Channel: Codable {
    let account: String
    let amount: String
    let balance: String
    let channelId: String
    let destinationAccount: String
    let settleDelay: Int
    let publicKey: String?
    let publicKeyHex: String?
    let expiration: Int?
    let cancelAfter: Int?
    let sourceTag: Int?
    let destinationTag: Int?
    
    enum CodingKeys: String, CodingKey {
        case account = "account"
        case amount = "amount"
        case balance = "balance"
        case channelId = "channel_id"
        case destinationAccount = "destination_account"
        case settleDelay = "settle_delay"
        case publicKey = "public_key"
        case publicKeyHex = "public_key_hex"
        case expiration = "expiration"
        case cancelAfter = "cancel_after"
        case sourceTag = "source_tag"
        case destinationTag = "destination_tag"
    }
}

/**
 * The account_channels method returns information about an account's Payment
 * Channels. This includes only channels where the specified account is the
 * channel's source, not the destination. (A channel's "source" and "owner" are
 * the same.) All information retrieved is relative to a particular version of
 * the ledger. Returns an {@link AccountChannelsResponse}.
 *
 */
public class AccountChannelsRequest: BaseRequest {
//    var command: String = "account_channels"
    /**
     * The unique identifier of an account, typically the account's address. The
     * request returns channels where this account is the channel's owner/source.
     *
     */
    public var account: String
    /**
     * The unique identifier of an account, typically the account's address. If
     * provided, filter results to payment channels whose destination is this
     * account.
     */
    public var destinationAccount: String?
    /** 20-byte hex string for the ledger version to use. */
    public var ledgerHash: String?
    /**
     * The ledger index of the ledger to use, or a shortcut string to choose a
     * ledger automatically.
     */
    public var ledgerIndex: rLedgerIndex?
    /**
     * Limit the number of transactions to retrieve. Cannot be less than 10 or
     * more than 400. The default is 200.
     */
    public var limit: Int?
    /**
     * Value from a previous paginated response. Resume retrieving data where
     * that response left off.
     */
    public var marker: AnyCodable?
    
    enum CodingKeys: String, CodingKey {
        case account = "account"
        case destinationAccount = "destination_account"
        case ledgerHash = "ledger_hash"
        case ledgerIndex = "ledger_index"
        case limit = "limit"
        case marker = "marker"
    }
    
    public init(
        // Required
        account: String,
        // Base Request
        id: Int? = nil,
        apiVersion: Int? = nil,
        // Result Response
        destinationAccount: String? = nil,
        ledgerHash: String? = nil,
        ledgerIndex: rLedgerIndex? = nil,
        limit: Int? = nil,
        marker: AnyCodable? = nil
    ) {
        self.account = account
        self.destinationAccount = destinationAccount
        self.ledgerHash = ledgerHash
        self.ledgerIndex = ledgerIndex
        self.limit = limit
        self.marker = marker
        super.init(id: id, command: "account_channels", apiVersion: apiVersion)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try values.encode(account, forKey: .account)
        if let destinationAccount = destinationAccount { try values.encode(destinationAccount, forKey: .destinationAccount) }
        if let ledgerHash = ledgerHash { try values.encode(ledgerHash, forKey: .ledgerHash) }
        if let ledgerIndex = ledgerIndex { try values.encode(ledgerIndex, forKey: .ledgerIndex) }
        if let limit = limit { try values.encode(limit, forKey: .limit) }
        if let marker = marker { try values.encode(marker, forKey: .marker) }
    }
    
//    override func jsonData() throws -> Data {
//        return try JSONEncoder().encode(self)
//    }
//
//    override func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
//        return String(data: try self.jsonData(), encoding: encoding)
//    }
    
//    required public init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        account = try values.decode(String.self, forKey: .account)
//        destinationAccount = try values.decode(String.self, forKey: .destinationAccount)
//        ledgerHash = try values.decode(String.self, forKey: .ledgerHash)
//        ledgerIndex = try values.decode(rLedgerIndex.self, forKey: .ledgerIndex)
//        limit = try values.decode(Int.self, forKey: .limit)
//        marker = try values.decode(AnyCodable.self, forKey: .marker)
//        try super.init(from: decoder)
//    }
}

/**
 * The expected response from an {@link AccountChannelsRequest}.
 *
 */
open class AccountChannelsResponse: Codable {
    /**
     * The address of the source/owner of the payment channels. This
     * corresponds to the account field of the request.
     */
    public var account: String
    /** Payment channels owned by this account. */
    public var channels: [Channel]
    /**
     * The identifying hash of the ledger version used to generate this
     * response.
     */
    public var ledgerHash: String
    /** The ledger index of the ledger version used to generate this response. */
    public var ledgerIndex: Int
    /**
     * If true, the information in this response comes from a validated ledger
     * version. Otherwise, the information is subject to change.
     */
    public var validated: Bool?
    /**
     * The limit to how many channel objects were actually returned by this
     * request.
     */
    public var limit: Int?
    /**
     * Server-defined value for pagination. Pass this to the next call to
     * resume getting results where this call left off. Omitted when there are
     * no additional pages after this one.
     */
    public var marker: AnyCodable?
    
    enum CodingKeys: String, CodingKey {
        case account = "account"
        case channels = "channels"
        case ledgerHash = "ledger_hash"
        case ledgerIndex = "ledger_index"
        case validated = "validated"
        case limit = "limit"
        case marker = "marker"
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        account = try values.decode(String.self, forKey: .account)
        channels = try values.decode([Channel].self, forKey: .channels)
        ledgerHash = try values.decode(String.self, forKey: .ledgerHash)
        ledgerIndex = try values.decode(Int.self, forKey: .ledgerIndex)
        validated = try? values.decode(Bool.self, forKey: .validated)
        limit = try? values.decode(Int.self, forKey: .limit)
        marker = try? values.decode(AnyCodable.self, forKey: .marker)
    }
}
