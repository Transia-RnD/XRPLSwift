//
//  Keypairs.swift
//
//
//  Created by Denis Angell on 8/6/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/ripple-keypairs/src/index.ts

import Foundation

protocol SigningAlgorithm {
    static var rawValue: String { get set }
    static func deriveKeyPair(seed: [UInt8], isValidator: Bool) throws -> KeyPair
    static func sign(message: [UInt8], privateKey: [UInt8]) throws -> [UInt8]
    static func verify(signature: [UInt8], message: [UInt8], publicKey: [UInt8]) throws -> Bool
}

public enum AlgorithmType {
    case ed25519
    case secp256k1

    var algorithm: SigningAlgorithm.Type {
        switch self {
        case .ed25519:
            return ED25519.self
        case .secp256k1:
            return SECP256K1.self
        }
    }

    static var types: [AlgorithmType] { return [.ed25519, .secp256k1] }

    var rawValue: String {
        switch self {
        case .ed25519:
            return "ed25519"
        case .secp256k1:
            return "secp256k1"
        }
    }
}

public struct KeypairsOptions {
    public let entropy: Entropy?
    public let algorithm: AlgorithmType?
    public let isValidator: Bool?

    init(entropy: Entropy? = nil, algorithm: AlgorithmType?, isValidator: Bool? = nil) {
        self.entropy = entropy != nil ? entropy! : Entropy()
        self.algorithm = algorithm ?? .ed25519
        self.isValidator = isValidator ?? false
    }
}

public protocol XRPLKeypair {
    var privateKey: String { get }
    var publicKey: String { get }
    var address: String { get }
    var accountID: [UInt8] { get }
    init()
    static func generateSeed(options: KeypairsOptions?) -> String
    static func deriveKeypair() -> KeyPair
    static func sign(message: [UInt8]) -> [UInt8]
    static func verify(signature: [UInt8], message: [UInt8], publicKey: String) -> Bool
    static func deriveAddress(publicKey: String) -> String
    static func deriveNodeAddress(publicKey: String) -> String
    static func decodeSeed(publicKey: String) -> String
}

/**
 An implementation of XRP Ledger keypairs & wallet generation using elliptic which supports rfc6979 and eddsa deterministic signatures.
 */
public class Keypairs {
    public static func generateSeed(options: KeypairsOptions) throws -> String {
        // swiftlint:disable:next force_unwrapping
        let entropy: Entropy = options.entropy != nil ? options.entropy! : Entropy()
        guard entropy.bytes.count >= 16 else {
            throw KeypairsErrors.validation("entropy too short")
        }
        switch options.algorithm {
        case .ed25519:
            return try XrplCodec.encodeSeed(entropy.bytes, .ed25519)
        case .secp256k1:
            return try XrplCodec.encodeSeed(entropy.bytes, .secp256k1)
        case .none:
            throw KeypairsErrors.unknown
        }
    }

    public static func hash(_ message: String) -> [UInt8] {
        return message.hexToBytes.sha512Half()
    }

    public static func deriveKeypair(_ seed: String, _ isValidator: Bool = false) throws -> KeyPair {
        let (bytes, seedType) = try XrplCodec.decodeSeed(seed)
        let entropy = Entropy(bytes: bytes)
        switch seedType {
        case .ed25519:
            let keypair = try ED25519.deriveKeyPair(seed: entropy.bytes, isValidator: isValidator)
            let messageToVerify = hash("This test message should verify.")
            let signature = try self.sign(messageToVerify, keypair.privateKey)
            if try self.verify(
                signature,
                messageToVerify,
                keypair.publicKey
            ) != true {
                throw KeypairsErrors.validation("derived keypair did not generate verifiable signature")
            }
            return keypair
        case .secp256k1:
            let keypair = try SECP256K1.deriveKeyPair(seed: entropy.bytes, isValidator: isValidator)
            let messageToVerify = hash("This test message should verify.")
            let signature = try self.sign(messageToVerify, keypair.privateKey)
            if try self.verify(
                signature,
                messageToVerify,
                keypair.publicKey
            ) != true {
                throw KeypairsErrors.validation("derived keypair did not generate verifiable signature")
            }
            return keypair
        }
    }

    public static func getAlgorithmFromKey(_ key: String) -> AlgorithmType {
        let data = [UInt8](key.hexadecimal!)
        return data.count == 33 && data[0] == 0xED ? .ed25519 : .secp256k1
    }

    public static func sign(_ message: [UInt8], _ privateKey: String) throws -> [UInt8] {
        let algorithm = Keypairs.getAlgorithmFromKey(privateKey).algorithm
        return try algorithm.sign(message: message, privateKey: Data(hex: privateKey).bytes)
    }

    public static func verify(_ signature: [UInt8], _ message: [UInt8], _ publicKey: String) throws -> Bool {
        let algorithm = Keypairs.getAlgorithmFromKey(publicKey).algorithm
        return try algorithm.verify(
            signature: signature,
            message: message,
            publicKey: Data(hex: publicKey).bytes
        )
    }

    public static func deriveAddressFromBytes(_ publicKeyBytes: Data) throws -> String {
        return try XrplCodec.encodeClassicAddress(publicKeyBytes.computePublicKeyHash().bytes)
    }

    public static func deriveAddress(_ publicKey: String) throws -> String {
        return try deriveAddressFromBytes(Data(hex: publicKey))
    }

    public static func deriveNodeAddress(_ publicKey: String) throws -> String {
        return try XrplCodec.decodeNodePublicKey(publicKey).toHex
    }
}
