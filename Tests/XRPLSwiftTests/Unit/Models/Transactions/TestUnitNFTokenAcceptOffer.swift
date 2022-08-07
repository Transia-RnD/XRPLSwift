////
////  TestUnitNFTokenAcceptOffer.swift
////
////
////  Created by Denis Angell on 6/4/22.
////
//
//import XCTest
//@testable import XRPLSwift
//
//final class TestUnitNFTokenAcceptOffer: XCTestCase {
//    
//    func testNFTokenAcceptOfferSell() {
//        let acceptSellTx = NFTokenAcceptOffer(
//            from: ReusableValues.wallet,
//            nftokenSellOffer: ReusableValues.nftokenSellOfferIndex
//        )
//        print(acceptSellTx)
//        XCTAssert(acceptSellTx.nftokenSellOffer == ReusableValues.nftokenSellOfferIndex)
//    }
//    
//    func testNFTokenAcceptOfferBuy() {
//        let acceptBuyTx = NFTokenAcceptOffer(
//            from: ReusableValues.wallet,
//            nftokenBuyOffer: ReusableValues.nftokenBuyOfferIndex
//        )
//        print(acceptBuyTx)
//        XCTAssert(acceptBuyTx.nftokenBuyOffer == ReusableValues.nftokenBuyOfferIndex)
//    }
//    
//    func testNFTokenAcceptOfferBroker() {
//        let acceptBrokerTx = NFTokenAcceptOffer(
//            from: ReusableValues.wallet,
//            nftokenSellOffer: ReusableValues.nftokenSellOfferIndex,
//            nftokenBuyOffer: ReusableValues.nftokenBuyOfferIndex,
//            nftokenBrokerFee: try! aAmount(drops: 0)
//        )
//        print(acceptBrokerTx)
//        XCTAssert(acceptBrokerTx.nftokenSellOffer == ReusableValues.nftokenBuyOfferIndex)
//        XCTAssert(acceptBrokerTx.nftokenBuyOffer == ReusableValues.nftokenBuyOfferIndex)
//        XCTAssert(acceptBrokerTx.nftokenBrokerFee == nil)
//    }
//}
