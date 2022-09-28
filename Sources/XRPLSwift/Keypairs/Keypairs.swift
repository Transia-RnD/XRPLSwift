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

public protocol rKeypairs {
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

public class Keypairs {
    public static func generateSeed(options: KeypairsOptions) throws -> String {
        //        assert.ok(
        //          !options.entropy || options.entropy.length >= 16,
        //          'entropy too short',
        //        )
        let entropy: Entropy = options.entropy != nil ? options.entropy! : Entropy()
        switch options.algorithm {
        case .ed25519:
            return try! XrplCodec.encodeSeed(entropy: entropy.bytes, type: .ed25519)
        case .secp256k1:
            return try! XrplCodec.encodeSeed(entropy: entropy.bytes, type: .secp256k1)
        case .none:
            throw KeypairsErrors.unknown
        }
    }

    public static func hash(message: String) -> [UInt8] {
        //      return hashjs.sha512().update(message).digest().slice(0, 32)

        return []
    }

    public static func deriveKeypair(seed: String, isValidator: Bool = false) throws -> KeyPair {
        let (bytes, seedType) = try XrplCodec.decodeSeed(seed: seed)
        let entropy = Entropy(bytes: bytes)
        switch seedType {
        case .ed25519:
            let keyPair = try! ED25519.deriveKeyPair(seed: entropy.bytes, isValidator: isValidator)
            //            let messageToVerify = hash("This test message should verify.")
            //            let signature = method.sign(messageToVerify, keypair.privateKey)
            //            /* istanbul ignore if */
            //            if algorithm.verify(
            //                signature: signature,
            //                message: messageToVerify,
            //                publicKey: keypair.publicKey
            //            ) != true {
            //                throw KeyPairError.invalidPrivateKey("derived keypair did not generate verifiable signature")
            //            }
            return keyPair
        case .secp256k1:
            let keyPair = try! SECP256K1.deriveKeyPair(seed: entropy.bytes, isValidator: isValidator)
            //            let messageToVerify = hash("This test message should verify.")
            //            let signature = method.sign(messageToVerify, keypair.privateKey)
            // istanbul ignore if
            //            if algorithm.verify(
            //                signature: signature,
            //                message: messageToVerify,
            //                publicKey: keypair.publicKey
            //            ) != true {
            //                throw KeyPairError.invalidPrivateKey("derived keypair did not generate verifiable signature")
            //            }
            return keyPair
        }
    }

    public static func getAlgorithmFromKey(key: String) -> AlgorithmType {
        let data = [UInt8](key.hexadecimal!)
        return data.count == 33 && data[0] == 0xED ? .ed25519 : .secp256k1
    }

    public static func sign(message: [UInt8], privateKey: String) -> [UInt8] {
        do {
            let algorithm = Keypairs.getAlgorithmFromKey(key: privateKey).algorithm
            return try algorithm.sign(message: message, privateKey: Data(hex: privateKey).bytes)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }

    public static func verify(signature: [UInt8], message: [UInt8], publicKey: String) -> Bool {
        do {
            let algorithm = Keypairs.getAlgorithmFromKey(key: publicKey).algorithm
            return try algorithm.verify(
                signature: signature,
                message: message,
                publicKey: Data(hex: publicKey).bytes
            )
        } catch {
            print(error.localizedDescription)
            return false
        }
    }

    public static func deriveAddressFromBytes(publicKeyBytes: Data) throws -> String {
        return try XrplCodec.encodeClassicAddress(bytes: publicKeyBytes.computePublicKeyHash().bytes)
    }

    public static func deriveAddress(publicKey: String) throws -> String {
        return try deriveAddressFromBytes(publicKeyBytes: Data(hex: publicKey))
    }

    public static func deriveNodeAddress(publicKey: String) -> String {
        let _: [UInt8] = try! XrplCodec.decodeNodePublicKey(nodePublicKey: publicKey)
        //        let accountPublicBytes: [UInt8] = accountPublicFromPublicGenerator(generatorBytes)
        return ""
    }
}
