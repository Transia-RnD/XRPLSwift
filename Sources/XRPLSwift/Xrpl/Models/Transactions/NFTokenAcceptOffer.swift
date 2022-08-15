//
//  NFTokenAcceptOffer.swift
//  AnyCodable
//
//  Created by Denis Angell on 3/20/22.
//

import Foundation

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/transactions/NFTokenAcceptOffer.ts


/**
 The NFTokenOfferAccept transaction is used to accept offers
 to buy or sell an NFToken. It can either:
 1. Allow one offer to be accepted. This is called direct
 mode.
 2. Allow two distinct offers, one offering to buy a
 given NFToken and the other offering to sell the same
 NFToken, to be accepted in an atomic fashion. This is
 called brokered mode.
 To indicate direct mode, use either the `nftoken_sell_offer` or
 `nftoken_buy_offer` fields, but not both. To indicate brokered mode,
 use both the `nftoken_sell_offer` and `nftoken_buy_offer` fields. If you use
 neither `nftoken_sell_offer` nor `nftoken_buy_offer`, the transaction is invalid.
 */
public class NFTokenAcceptOffer: BaseTransaction {
    /**
     Identifies the NFTokenOffer that offers to sell the NFToken.
     In direct mode this field is optional, but either NFTokenSellOffer or
     NFTokenBuyOffer must be specified. In brokered mode, both NFTokenSellOffer
     and NFTokenBuyOffer must be specified.
     */
    public var nftokenSellOffer: String?
    
    /**
     Identifies the NFTokenOffer that offers to buy the NFToken.
     In direct mode this field is optional, but either NFTokenSellOffer or
     NFTokenBuyOffer must be specified. In brokered mode, both NFTokenSellOffer
     and NFTokenBuyOffer must be specified.
     */
    public var nftokenBuyOffer: String?
    
    /**
     This field is only valid in brokered mode. It specifies the
     amount that the broker will keep as part of their fee for
     bringing the two offers together; the remaining amount will
     be sent to the seller of the NFToken being bought. If
     specified, the fee must be such that, prior to accounting
     for the transfer fee charged by the issuer, the amount that
     the seller would receive is at least as much as the amount
     indicated in the sell offer.
     This functionality is intended to allow the owner of an
     NFToken to offer their token for sale to a third party
     broker, who may then attempt to sell the NFToken on for a
     larger amount, without the broker having to own the NFToken
     or custody funds.
     Note: in brokered mode, the offers referenced by NFTokenBuyOffer
     and NFTokenSellOffer must both specify the same TokenID; that is,
     both must be for the same NFToken.
     */
    public var nftokenBrokerFee: rAmount?
    
    enum CodingKeys: String, CodingKey {
        case nftokenSellOffer = "NFTokenSellOffer"
        case nftokenBuyOffer = "NFTokenBuyOffer"
        case nftokenBrokerFee = "NFTokenBrokerFee"
    }
    
    public init(
        nftokenSellOffer: String? = nil,
        nftokenBuyOffer: String? = nil,
        nftokenBrokerFee: rAmount? = nil
    ) {
        self.nftokenSellOffer = nftokenSellOffer
        self.nftokenBuyOffer = nftokenBuyOffer
        self.nftokenBrokerFee = nftokenBrokerFee
        super.init(account: "", transactionType: "NFTokenAcceptOffer")
    }
    
    public override init(json: [String: AnyObject]) throws {
        let decoder: JSONDecoder = JSONDecoder()
        let data: Data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let r = try decoder.decode(NFTokenAcceptOffer.self, from: data)
        self.nftokenSellOffer = r.nftokenSellOffer
        self.nftokenBuyOffer = r.nftokenBuyOffer
        self.nftokenBrokerFee = r.nftokenBrokerFee
        try super.init(json: json)
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        nftokenSellOffer = try values.decodeIfPresent(String.self, forKey: .nftokenSellOffer)
        nftokenBuyOffer = try values.decodeIfPresent(String.self, forKey: .nftokenBuyOffer)
        nftokenBrokerFee = try values.decodeIfPresent(rAmount.self, forKey: .nftokenBrokerFee)
        try super.init(from: decoder)
    }
    
    override public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        if let nftokenSellOffer = nftokenSellOffer { try values.encode(nftokenSellOffer, forKey: .nftokenSellOffer) }
        if let nftokenBuyOffer = nftokenBuyOffer { try values.encode(nftokenBuyOffer, forKey: .nftokenBuyOffer) }
        if let nftokenBrokerFee = nftokenBrokerFee { try values.encode(nftokenBrokerFee, forKey: .nftokenBrokerFee) }
    }
}


func validateNFTokenBrokerFee(tx: [String: AnyObject]) throws -> Void {
    let value = parseAmountValue(amount: tx["NFTokenBrokerFee"] as Any)
    if value!.isNaN {
        throw ValidationError.decoding("NFTokenAcceptOffer: invalid NFTokenBrokerFee")
    }
    
    if value! <= 0 {
        throw ValidationError.decoding("NFTokenAcceptOffer: NFTokenBrokerFee must be greater than 0; omit if there is no fee")
    }
    
    if tx["NFTokenSellOffer"] == nil || tx["NFTokenBuyOffer"] == nil {
        throw ValidationError.decoding("NFTokenAcceptOffer: both NFTokenSellOffer and NFTokenBuyOffer must be set if using brokered mode")
    }
}

/**
 * Verify the form and type of an NFTokenAcceptOffer at runtime.
 *
 * @param tx - An NFTokenAcceptOffer Transaction.
 * @throws When the NFTokenAcceptOffer is Malformed.
 */
public func validateNFTokenAcceptOffer(tx: [String: AnyObject]) throws -> Void {
    try validateBaseTransaction(common: tx)
    
    if tx["NFTokenBrokerFee"] != nil {
        try validateNFTokenBrokerFee(tx: tx)
    }
    
    if tx["NFTokenSellOffer"] == nil && tx["NFTokenBuyOffer"] == nil {
        throw ValidationError.decoding("NFTokenAcceptOffer: must set either NFTokenSellOffer or NFTokenBuyOffer")
    }
}
