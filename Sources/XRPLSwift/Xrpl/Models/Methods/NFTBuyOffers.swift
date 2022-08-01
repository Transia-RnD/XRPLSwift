////
////  File.swift
////  
////
////  Created by Denis Angell on 7/30/22.
////
//
//// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/models/methods/nftBuyOffers.ts
//
//import Foundation
//
//
///**
// * The `nft_buy_offers` method retrieves all of buy offers for the specified
// * NFToken.
// *
// * @category Requests
// */
//open class NFTBuyOffersRequest: BaseRequest {
//    let command: String = "nft_buy_offers"
//  /**
//   * The unique identifier of an NFToken. The request returns buy offers for this NFToken.
//   */
//    let nft_id: String
//}
//
///**
// * Response expected from an {@link NFTBuyOffersRequest}.
// *
// * @category Responses
// */
//open class NFTBuyOffersResponse: BaseResponse {
//  result: {
//    /**
//     * A list of buy offers for the specified NFToken.
//     */
//      let offers: NFTOffer[]
//    /**
//     * The token ID of the NFToken to which these offers pertain.
//     */
//      let nft_id: String
//  }
//}
