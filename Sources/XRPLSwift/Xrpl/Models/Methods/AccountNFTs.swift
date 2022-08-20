//
//  AccountNFTs.swift
//
//
//  Created by Denis Angell on 7/30/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/methods/accountNFTs.ts

import Foundation
import AnyCodable

/**
 * The `account_nfts` method retrieves all of the NFTs currently owned by the
 * specified account.
 *
 * @category Requests
 */
public class AccountNFTsRequest: BaseRequest {
    //    public let command: String = "account_nfts"
    /**
     * The unique identifier of an account, typically the account's address. The
     * request returns NFTs owned by this account.
     */
    public let account: String
    /**
     * Limit the number of NFTokens to retrieve.
     */
    public let limit: Int?
    /**
     * Value from a previous paginated response. Resume retrieving data where
     * that response left off.
     */
    public let marker: AnyCodable?

    enum CodingKeys: String, CodingKey {
        case account = "account"
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
        limit: Int? = nil,
        marker: AnyCodable? = nil
    ) {
        // Required
        self.account = account
        // Optional
        self.limit = limit
        self.marker = marker
        super.init(id: id, command: "account_nfts", apiVersion: apiVersion)
    }

    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }

    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try values.encode(account, forKey: .account)
        if let limit = limit { try values.encode(limit, forKey: .limit) }
        if let marker = marker { try values.encode(marker, forKey: .marker) }
    }
}

/**
 * One NFToken that might be returned from an {@link AccountNFTsRequest}.
 *
 * @category Responses
 */
public struct AccountNFToken: Codable {
    public let flags: Int
    public let issuer: String
    public let nfTokenID: String
    public let nfTokenTaxon: Int
    public let uri: String?
    public let nftSerial: Int

    enum CodingKeys: String, CodingKey {
        case flags = "flags"
        case issuer = "issuer"
        case nfTokenID = "nfTokenID"
        case nfTokenTaxon = "NFTokenTaxon"
        case uri = "URI"
        case nftSerial = "nft_serial"
    }
}

/**
 * Response expected from an {@link AccountNFTsRequest}.
 *
 * @category Responses
 */
public class AccountNFTsResponse: Codable {
    /**
     * The account requested.
     */
    public let account: String
    /**
     * A list of NFTs owned by the specified account.
     */
    public let accountNfts: [AccountNFToken]
    /**
     * The ledger index of the current open ledger, which was used when
     * retrieving this information.
     */
    public let ledgerCurrentIndex: Int
    /** If true, this data comes from a validated ledger. */
    public let validated: Bool
    /** The limit that was used to fulfill this request. */
    public let limit: Int?
    /**
     * Server-defined value indicating the response is paginated. Pass this to
     * the next call to resume where this call left off. Omitted when there are
     * No additional pages after this one.
     */
    public let marker: AnyCodable?

    enum CodingKeys: String, CodingKey {
        case account = "account"
        case accountNfts = "account_nfts"
        case ledgerCurrentIndex = "ledger_current_index"
        case validated = "validated"
        case limit = "limit"
        case marker = "marker"
    }

    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        account = try values.decode(String.self, forKey: .account)
        accountNfts = try values.decode([AccountNFToken].self, forKey: .accountNfts)
        ledgerCurrentIndex = try values.decode(Int.self, forKey: .ledgerCurrentIndex)
        validated = try values.decode(Bool.self, forKey: .validated)
        limit = try values.decode(Int.self, forKey: .limit)
        marker = try values.decode(AnyCodable.self, forKey: .marker)
//        try super.init(from: decoder)
    }
}
