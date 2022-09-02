//
//  TestKeypairs.swift
//
//
//  Created by Denis Angell on 8/7/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/ripple-keypairs/test/api-test.js

import XCTest
@testable import XRPLSwift

let entropy: Entropy = Entropy(bytes: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16])

final class TestUApi: XCTestCase {

    static let fixtures: ApiFixtures = ApiFixtures()

    func testGenerateSeedFromEntropySECP256K1() {
        let options: KeypairsOptions = KeypairsOptions(entropy: entropy, algorithm: .secp256k1)
        XCTAssertEqual(try! Keypairs.generateSeed(options: options), TestUApi.fixtures.SECP256K1_SEED)
    }

    func testGenerateSeedRandomSECP256K1() {
        let options: KeypairsOptions = KeypairsOptions(algorithm: .secp256k1)
        let seed: String = try! Keypairs.generateSeed(options: options)
        XCTAssertEqual(seed[0], "s")
        let (decodedSeed, decodedAlgorithm): ([UInt8], AlgorithmType) = try! XrplCodec.decodeSeed(seed: seed)
        XCTAssertEqual(decodedAlgorithm, .secp256k1)
        XCTAssertEqual(decodedSeed.count, 16)
    }

    func testGenerateSeedFromEntropyED25519() {
        let options: KeypairsOptions = KeypairsOptions(entropy: entropy, algorithm: .ed25519)
        XCTAssertEqual(try! Keypairs.generateSeed(options: options), TestUApi.fixtures.ED25519_SEED)
    }

    func testGenerateSeedRandomED25519() {
        let options: KeypairsOptions = KeypairsOptions(algorithm: .ed25519)
        let seed: String = try! Keypairs.generateSeed(options: options)
        XCTAssertEqual(seed[0..<3], "sEd")
        let (decodedSeed, decodedAlgorithm): ([UInt8], AlgorithmType) = try! XrplCodec.decodeSeed(seed: seed)
        XCTAssertEqual(decodedAlgorithm, .ed25519)
        XCTAssertEqual(decodedSeed.count, 16)
    }

    func testDeriveKeypairSECP256K1() {
        let keypair = try! Keypairs.deriveKeypair(seed: TestUApi.fixtures.SECP256K1_SEED)
        // Had an issue with the KeyPair Object
        XCTAssertEqual(keypair.privateKey, TestUApi.fixtures.SECP256K1_KEYPAIR.privateKey)
        XCTAssertEqual(keypair.publicKey, TestUApi.fixtures.SECP256K1_KEYPAIR.publicKey)
    }

    func testDeriveKeypairED25519() {
        let keypair = try! Keypairs.deriveKeypair(seed: TestUApi.fixtures.ED25519_SEED)
        // Had an issue with the KeyPair Object
        XCTAssertEqual("ED\(keypair.privateKey)", TestUApi.fixtures.ED25519_KEYPAIR.privateKey)
        XCTAssertEqual("ED\(keypair.publicKey)", TestUApi.fixtures.ED25519_KEYPAIR.publicKey)
    }

    func testDeriveKeypairSECP256K1Validator() {
        let keypair = try! Keypairs.deriveKeypair(seed: TestUApi.fixtures.SECP256K1_SEED, isValidator: true)
        // Had an issue with the KeyPair Object
        XCTAssertEqual(keypair.privateKey, TestUApi.fixtures.SECP256K1_VALIDATOR_KEYPAIR.privateKey)
        XCTAssertEqual(keypair.publicKey, TestUApi.fixtures.SECP256K1_VALIDATOR_KEYPAIR.publicKey)
    }

    // MARK: Python Library doesnt allow this
//    func testDeriveKeypairED25519Validator() {
//        let keypair = try! Keypairs.deriveKeypair(seed: TestUApi.fixtures.ED25519_SEED, isValidator: true)
//        // Had an issue with the KeyPair Object
//        XCTAssertEqual(keypair.privateKey, TestUApi.fixtures.ED25519_VALIDATOR_KEYPAIR.privateKey)
//        XCTAssertEqual(keypair.publicKey, TestUApi.fixtures.ED25519_VALIDATOR_KEYPAIR.publicKey)
//    }

    func testDeriveAddressSECP256K1() {
        print(TestUApi.fixtures.SECP256K1_KEYPAIR.publicKey)
        let address = try! Keypairs.deriveAddress(publicKey: TestUApi.fixtures.SECP256K1_KEYPAIR.publicKey)
        // Had an issue with the KeyPair Object
        XCTAssertEqual(address, TestUApi.fixtures.SECP256K1_ADDRESS)
    }

    func testDeriveAddressED25519() {
        let address = try! Keypairs.deriveAddress(publicKey: TestUApi.fixtures.ED25519_KEYPAIR.publicKey)
        // Had an issue with the KeyPair Object
        XCTAssertEqual(address, TestUApi.fixtures.ED25519_ADDRESS)
    }

    func testSignSECP256K1() {
        let privateKey = TestUApi.fixtures.SECP256K1_KEYPAIR.privateKey
        let message = TestUApi.fixtures.SECP256K1_MESSAGE
        let messageHex = message.bytes
        let signature = Keypairs.sign(message: messageHex, privateKey: privateKey)
        XCTAssertEqual(signature.toHex, TestUApi.fixtures.SECP256K1_SIGNATURE)
    }

    func testVerifySECP256K1() {
        let signature = TestUApi.fixtures.SECP256K1_SIGNATURE
        let publicKey = TestUApi.fixtures.SECP256K1_KEYPAIR.publicKey
        let message = TestUApi.fixtures.SECP256K1_MESSAGE
        let messageBytes = message.bytes
        XCTAssertTrue(Keypairs.verify(signature: Data(hex: signature).bytes, message: messageBytes, publicKey: publicKey))
    }

    func testSignED25519() {
        let privateKey = TestUApi.fixtures.ED25519_KEYPAIR.privateKey
        let message = TestUApi.fixtures.ED25519_MESSAGE
        let messageHex = message.bytes
        let signature = Keypairs.sign(message: messageHex, privateKey: privateKey)
        XCTAssertEqual(signature.toHexString().uppercased(), TestUApi.fixtures.ED25519_SIGNATURE)
    }

    func testVerifyED25519() {
        let signature = TestUApi.fixtures.ED25519_SIGNATURE
        let publicKey = TestUApi.fixtures.ED25519_KEYPAIR.publicKey
        let message = TestUApi.fixtures.ED25519_MESSAGE
        let messageHex = message.bytes
        XCTAssertTrue(Keypairs.verify(signature: Data(hex: signature).bytes, message: messageHex, publicKey: publicKey))
    }

//    func testDeriveNodeAddress() {
//        let x = "n9KHn8NfbBsZV5q8bLfS72XyGqwFt5mgoPbcTV4c6qKiuPTAtXYk"
//        let y = "rU7bM9ENDkybaxNrefAVjdLTyNLuue1KaJ"
//        XCTAssertEqual(Keypairs.deriveNodeAddress(publicKey: x), y)
//    }

    func testRandomAddress() {
        let seed = try! Keypairs.generateSeed(options: KeypairsOptions(algorithm: .secp256k1))
        let keypair = try! Keypairs.deriveKeypair(seed: seed)
        let address = try! Keypairs.deriveAddress(publicKey: keypair.publicKey)
        print(address)
        XCTAssertEqual(address[0], "r")
    }
}

extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}
