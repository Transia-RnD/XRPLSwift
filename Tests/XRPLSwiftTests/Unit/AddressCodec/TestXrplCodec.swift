//
//  TestXrplCodec.swift
//  
//
//  Created by Denis Angell on 7/2/22.
//

import XCTest
@testable import XRPLSwift

final class TestXrplCodec: XCTestCase {
    
    // Seed Tests
    
    func testSeedEncodeDecodeSecp256k1() {
        let hexString: String = "CF2DE378FBDD7E2EE87D486DFB5A7BFF"
        let encodedString: String = "sn259rEFXrQrWyx3Q7XneWcwV6dfL"
        do {
            let hexStringBytes = try hexString.asHexArray()
            let encodeResult = try XrplCodec.encodeSeed(
                entropy: hexStringBytes,
                type: .secp256k1
            )
            XCTAssert(encodeResult == encodedString)
            let (decodeResult, encodingType) = try XrplCodec.decodeSeed(seed: encodedString)
            XCTAssert(decodeResult == hexStringBytes)
            XCTAssert(encodingType == .secp256k1)
        } catch {
            print(error.localizedDescription)
            XCTFail("Could not encode seed")
        }
    }
    
    func testSeedEncodeDecodeSecp256k1Low() {
        let hexString: String = "00000000000000000000000000000000"
        let encodedString: String = "sp6JS7f14BuwFY8Mw6bTtLKWauoUs"
        do {
            let hexStringBytes = try hexString.asHexArray()
            let encodeResult = try XrplCodec.encodeSeed(
                entropy: hexStringBytes,
                type: .secp256k1
            )
            XCTAssert(encodeResult == encodedString)
            let (decodeResult, encodingType) = try XrplCodec.decodeSeed(seed: encodedString)
            XCTAssert(decodeResult == hexStringBytes)
            XCTAssert(encodingType == .secp256k1)
        } catch {
            print(error.localizedDescription)
            XCTFail("Could not encode seed")
        }
    }
    
    func testSeedEncodeDecodeSecp256k1High() {
        let hexString: String = "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF"
        let encodedString: String = "saGwBRReqUNKuWNLpUAq8i8NkXEPN"
        do {
            let hexStringBytes = try hexString.asHexArray()
            let encodeResult = try XrplCodec.encodeSeed(
                entropy: hexStringBytes,
                type: .secp256k1
            )
            XCTAssert(encodeResult == encodedString)
            let (decodeResult, encodingType) = try XrplCodec.decodeSeed(seed: encodedString)
            XCTAssert(decodeResult == hexStringBytes)
            XCTAssert(encodingType == .secp256k1)
        } catch {
            print(error.localizedDescription)
            XCTFail("Could not encode seed")
        }
    }
    
    func testSeedEncodeDecodeEd25519() {
        let hexString: String = "4C3A1D213FBDFB14C7C28D609469B341"
        let encodedString: String = "sEdTM1uX8pu2do5XvTnutH6HsouMaM2"
        do {
            let hexStringBytes = try hexString.asHexArray()
            let encodeResult = try XrplCodec.encodeSeed(
                entropy: hexStringBytes,
                type: .ed25519
            )
            XCTAssert(encodeResult == encodedString)
            let (decodeResult, encodingType) = try XrplCodec.decodeSeed(seed: encodedString)
            XCTAssert(decodeResult == hexStringBytes)
            XCTAssert(encodingType == .ed25519)
        } catch {
            print(error.localizedDescription)
            XCTFail("Could not encode seed")
        }
    }
    
    func testSeedEncodeDecodeEd25519Low() {
        let hexString: String = "00000000000000000000000000000000"
        let encodedString: String = "sEdSJHS4oiAdz7w2X2ni1gFiqtbJHqE"
        do {
            let hexStringBytes = try hexString.asHexArray()
            let encodeResult = try XrplCodec.encodeSeed(
                entropy: hexStringBytes,
                type: .ed25519
            )
            XCTAssert(encodeResult == encodedString)
            let (decodeResult, encodingType) = try XrplCodec.decodeSeed(seed: encodedString)
            XCTAssert(decodeResult == hexStringBytes)
            XCTAssert(encodingType == .ed25519)
        } catch {
            print(error.localizedDescription)
            XCTFail("Could not encode seed")
        }
    }
    
    func testSeedEncodeDecodeEd25519High() {
        let hexString: String = "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF"
        let encodedString: String = "sEdV19BLfeQeKdEXyYA4NhjPJe6XBfG"
        do {
            let hexStringBytes = try hexString.asHexArray()
            let encodeResult = try XrplCodec.encodeSeed(
                entropy: hexStringBytes,
                type: .ed25519
            )
            XCTAssert(encodeResult == encodedString)
            let (decodeResult, encodingType) = try XrplCodec.decodeSeed(seed: encodedString)
            XCTAssert(decodeResult == hexStringBytes)
            XCTAssert(encodingType == .ed25519)
        } catch {
            print(error.localizedDescription)
            XCTFail("Could not encode seed")
        }
    }
    
    func testSeedEncodeDecodeTooSmall() {
        let hexString: String = "CF2DE378FBDD7E2EE87D486DFB5A7B"
        do {
            let hexStringBytes = try hexString.asHexArray()
            _ = try XrplCodec.encodeSeed(
                entropy: hexStringBytes,
                type: .secp256k1
            )
        } catch {
            XCTAssertTrue(error is XrplCodecError, "Unexpected error type: \(type(of: error))")
        }
    }
    
    func testSeedEncodeDecodeTooBig() {
        let hexString: String = "CF2DE378FBDD7E2EE87D486DFB5A7BFFFF"
        do {
            let hexStringBytes = try hexString.asHexArray()
            _ = try XrplCodec.encodeSeed(
                entropy: hexStringBytes,
                type: .secp256k1
            )
        } catch {
            XCTAssertTrue(error is XrplCodecError, "Unexpected error type: \(type(of: error))")
        }
    }
    
    // Classic Address Tests
    
    func testClassicAddreessEncodeDecode() {
        let hexString: String = "BA8E78626EE42C41B46D46C3048DF3A1C3C87072"
        let encodedString: String = "rJrRMgiRgrU6hDF4pgu5DXQdWyPbY35ErN"
        do {
            let hexStringBytes = try hexString.asHexArray()
            let encodeResult = try XrplCodec.encodeClassicAddress(
                bytes: hexStringBytes
            )
            XCTAssert(encodeResult == encodedString)
            let decodeResult = try XrplCodec.decodeClassicAddress(classicAddress: encodedString)
            XCTAssert(decodeResult == hexStringBytes)
        } catch {
            print(error.localizedDescription)
            XCTFail("Could not encode/decode classic address")
        }
    }
    
    func testEncodeClassicAddreessBadLength() {
        let hexString: String = "ABCDEF"
        do {
            let hexStringBytes = try hexString.asHexArray()
            _ = try XrplCodec.encodeClassicAddress(
                bytes: hexStringBytes
            )
        } catch {
            XCTAssertTrue(error is XrplCodecError, "Unexpected error type: \(type(of: error))")
        }
    }
    
    // Node Public Key Tests
    
    func testNodePublicKeyEncodeDecode() {
        let hexString: String = "0388E5BA87A000CB807240DF8C848EB0B5FFA5C8E5A521BC8E105C0F0A44217828"
        let encodedString: String = "n9MXXueo837zYH36DvMc13BwHcqtfAWNJY5czWVbp7uYTj7x17TH"
        do {
            let hexStringBytes = try hexString.asHexArray()
            let encodeResult = try XrplCodec.encodeNodePublicKey(
                bytes: hexStringBytes
            )
            XCTAssert(encodeResult == encodedString)
            let decodeResult = try XrplCodec.decodeNodePublicKey(nodePublicKey: encodedString)
            XCTAssert(decodeResult == hexStringBytes)
        } catch {
            print(error.localizedDescription)
            XCTFail("Could not encode/decode classic address")
        }
    }
    
    // Account Public Key Tests
    
    func testAccountPublicKeyEncodeDecode() {
        let hexString: String = "023693F15967AE357D0327974AD46FE3C127113B1110D6044FD41E723689F81CC6"
        let encodedString: String = "aB44YfzW24VDEJQ2UuLPV2PvqcPCSoLnL7y5M1EzhdW4LnK5xMS3"
        do {
            let hexStringBytes = try hexString.asHexArray()
            let encodeResult = try XrplCodec.encodeAccountPublicKey(
                bytes: hexStringBytes
            )
            XCTAssert(encodeResult == encodedString)
            let decodeResult = try XrplCodec.decodeAccountPublicKey(accountPublicKey: encodedString)
            XCTAssert(decodeResult == hexStringBytes)
        } catch {
            print(error.localizedDescription)
            XCTFail("Could not encode/decode classic address")
        }
    }
}
