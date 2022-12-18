//
//  NFTSellOffers.swift
//
//
//  Created by Denis Angell on 7/30/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/methods/nftSellOffers.ts

import Foundation

/**
 The `nft_sell_offers` method retrieves all of buy offers for the specified
 NFToken.
 */
public class NFTSellOffersRequest: BaseRequest {
    /**
     The unique identifier of an NFToken. The request returns buy offers for this NFToken.
     */
    public var nftId: String

    enum CodingKeys: String, CodingKey {
        case nftId = "nft_id"
    }

    public init(
        // Required
        nftId: String,
        // Base
        id: Int? = nil,
        apiVersion: Int? = nil
    ) {
        // Required
        self.nftId = nftId
        // Optional
        super.init(id: id, command: "nft_sell_offers", apiVersion: apiVersion)
    }

    override public init(_ json: [String: AnyObject]) throws {
        let decoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let decoded = try decoder.decode(NFTSellOffersRequest.self, from: data)
        self.nftId = decoded.nftId
        try super.init(json)
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        nftId = try values.decode(String.self, forKey: .nftId)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try values.encode(nftId, forKey: .nftId)
    }
}

/**
 Response expected from an {@link NFTSellOffersRequest}.
 *
 @category Responses
 */
public class NFTSellOffersResponse: Codable {
    /**
     A list of buy offers for the specified NFToken.
     */
    public var offers: [NFTOffer]
    /**
     The token ID of the NFToken to which these offers pertain.
     */
    public var nftId: String

    enum CodingKeys: String, CodingKey {
        case offers = "offers"
        case nftId = "nft_id"
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        offers = try values.decode([NFTOffer].self, forKey: .offers)
        nftId = try values.decode(String.self, forKey: .nftId)
        //        try super.init(from: decoder)
    }

    func toJson() throws -> [String: AnyObject] {
        let data = try JSONEncoder().encode(self)
        let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        return jsonResult as! [String: AnyObject]
    }
}
