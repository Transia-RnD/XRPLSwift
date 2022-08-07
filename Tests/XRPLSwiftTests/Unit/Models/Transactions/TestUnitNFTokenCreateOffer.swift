////
////  TestUnitNFTokenCreateOffer.swift
////
////
////  Created by Denis Angell on 6/4/22.
////
//
//import XCTest
//@testable import XRPLSwift
//
//final class TestUnitNFTokenOfferCreate: XCTestCase {
//    
//    func testNFTokenCreateOfferSell() {
//        let sellOfferTx = NFTokenCreateOffer(
//            from: ReusableValues.wallet,
//            flags: .tfSellToken,
//            nftokenId: ReusableValues.nftokenId,
//            amount: try! aAmount(drops: 1),
//            expiration: 30,
//            destination: ReusableValues.destination
//            
//        )
//        print(sellOfferTx)
//        XCTAssert(sellOfferTx.nftokenId == ReusableValues.nftokenId)
//        XCTAssert(sellOfferTx.amount.drops == 1)
//        XCTAssert(sellOfferTx.expiration == 30)
//        XCTAssert(sellOfferTx.destination?.rAddress == ReusableValues.destination.rAddress)
//    }
//    
//    func testNFTokenCreateOfferBuy() {
//        let buyOfferTx = NFTokenCreateOffer(
//            from: ReusableValues.wallet,
//            nftokenId: ReusableValues.nftokenId,
//            amount: try! aAmount(drops: 1),
//            owner: try! Address(rAddress: ReusableValues.wallet.address),
//            expiration: 30,
//            destination: ReusableValues.destination
//            
//        )
//        print(buyOfferTx)
//        XCTAssert(buyOfferTx.nftokenId == ReusableValues.nftokenId)
//        XCTAssert(buyOfferTx.owner?.rAddress == ReusableValues.wallet.address)
//        XCTAssert(buyOfferTx.amount.drops == 1)
//        XCTAssert(buyOfferTx.expiration == 30)
//        XCTAssert(buyOfferTx.destination?.rAddress == ReusableValues.destination.rAddress)
//    }
//}
