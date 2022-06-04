//
//  NFTokenAcceptOffer.swift
//  AnyCodable
//
//  Created by Denis Angell on 3/20/22.
//

import Foundation

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/models/transactions/nftoken_accept_offer.py

public class NFTokenAcceptOffer: Transaction {
    
    /*
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

    public var nftokenSellOffer: String?
    /*
    Identifies the NFTokenOffer that offers to sell the NFToken.
    In direct mode this field is optional, but either NFTokenSellOffer or
    NFTokenBuyOffer must be specified. In brokered mode, both NFTokenSellOffer
    and NFTokenBuyOffer must be specified.
    */

    public var nftokenBuyOffer: String?
     /*
    Identifies the NFTokenOffer that offers to buy the NFToken.
    In direct mode this field is optional, but either NFTokenSellOffer or
    NFTokenBuyOffer must be specified. In brokered mode, both NFTokenSellOffer
    and NFTokenBuyOffer must be specified.
    */

    public var nftokenBrokerFee: Amount?
    /*
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
    
    public init(
        from wallet: Wallet,
        nftokenSellOffer: String? = nil,
        nftokenBuyOffer: String? = nil,
        nftokenBrokerFee: Amount? = nil
    ) {
        self.nftokenSellOffer = nftokenSellOffer
        self.nftokenBuyOffer = nftokenBuyOffer
        
        // NOT SUBMITTED IF 0
        if nftokenBrokerFee != nil && nftokenBrokerFee!.drops > 0 {
            self.nftokenBrokerFee = nftokenBrokerFee
        }
        
        
        var _fields: [String:Any] = [
            "TransactionType" : TransactionType.NFTokenAcceptOffer.rawValue
        ]
        if let nftokenSellOffer = nftokenSellOffer {
            _fields["nftoken_sell_offer"] = nftokenSellOffer
        }
        
        if let nftokenBuyOffer = nftokenBuyOffer {
            _fields["nftoken_bell_offer"] = nftokenBuyOffer
        }
        
        if let nftokenBrokerFee = nftokenBrokerFee, nftokenBrokerFee.drops > 0 {
            _fields["nftoken_broker_fee"] = nftokenBrokerFee
        }
        
        super.init(wallet: wallet, fields: _fields)
    }
}
