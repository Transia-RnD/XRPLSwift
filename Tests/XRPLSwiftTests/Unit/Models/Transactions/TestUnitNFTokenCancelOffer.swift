//
//  TestUnitNFTokenCancelOffer.swift
//
//
//  Created by Denis Angell on 6/4/22.
//

import XCTest
@testable import XRPLSwift

final class TestUnitNFTokenCancelOffer: XCTestCase {
    
    func testNFTokenCancelOffer() {
        let cancelTx = NFTokenCancelOffer(
            from: ReusableValues.wallet,
            nftokenOffers: [ReusableValues.nftokenBuyOfferIndex]
        )
        print(cancelTx)
        XCTAssert(cancelTx.nftokenOffers.count == 1)
    }
}
