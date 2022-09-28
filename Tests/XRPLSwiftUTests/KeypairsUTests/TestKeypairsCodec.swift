//
//  TestCodec.swift
//
//
//  Created by Denis Angell on 8/7/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/ripple-keypairs/test/codec-test.js

import Foundation

import XCTest
@testable import XRPLSwift

final class TestKeypairsCodec: XCTestCase {

    func testAccountID() {
        let eactual = try! XrplCodec.encodeClassicAddress(bytes: Data(hex: "BA8E78626EE42C41B46D46C3048DF3A1C3C87072").bytes)
        XCTAssertEqual(eactual, "rJrRMgiRgrU6hDF4pgu5DXQdWyPbY35ErN")

        let dactual = try! XrplCodec.decodeClassicAddress(classicAddress: "rJrRMgiRgrU6hDF4pgu5DXQdWyPbY35ErN")
        XCTAssertEqual(dactual.toHexString().uppercased(), "BA8E78626EE42C41B46D46C3048DF3A1C3C87072")
    }

    func testNodePublic() {
        let eactual = try! XrplCodec.encodeNodePublicKey(bytes: Data(hex: "0388E5BA87A000CB807240DF8C848EB0B5FFA5C8E5A521BC8E105C0F0A44217828").bytes)
        XCTAssertEqual(eactual, "n9MXXueo837zYH36DvMc13BwHcqtfAWNJY5czWVbp7uYTj7x17TH")

        let dactual = try! XrplCodec.decodeNodePublicKey(nodePublicKey: "n9MXXueo837zYH36DvMc13BwHcqtfAWNJY5czWVbp7uYTj7x17TH")
        XCTAssertEqual(dactual.toHexString().uppercased(), "0388E5BA87A000CB807240DF8C848EB0B5FFA5C8E5A521BC8E105C0F0A44217828")
    }

    func testArbitrarySeeds() {
        let decoded = try! XrplCodec.decodeSeed(seed: "sEdTM1uX8pu2do5XvTnutH6HsouMaM2")
        XCTAssertEqual(decoded.0.toHexString().uppercased(), "4C3A1D213FBDFB14C7C28D609469B341")
        XCTAssertEqual(decoded.1.algorithm.rawValue, "ed25519")

        let decoded2 = try! XrplCodec.decodeSeed(seed: "sn259rEFXrQrWyx3Q7XneWcwV6dfL")
        XCTAssertEqual(decoded2.0.toHexString().uppercased(), "CF2DE378FBDD7E2EE87D486DFB5A7BFF")
        XCTAssertEqual(decoded2.1.algorithm.rawValue, "secp256k1")
    }

    func testEncodeWithType() {
        let edSeed = "sEdTM1uX8pu2do5XvTnutH6HsouMaM2"
        let decoded = try! XrplCodec.decodeSeed(seed: edSeed)
        XCTAssertEqual(decoded.0.toHexString().uppercased(), "4C3A1D213FBDFB14C7C28D609469B341")
        XCTAssertEqual(decoded.1.algorithm.rawValue, "ed25519")
        XCTAssertEqual(try! XrplCodec.encodeSeed(entropy: decoded.0, type: decoded.1), edSeed)
    }
}
