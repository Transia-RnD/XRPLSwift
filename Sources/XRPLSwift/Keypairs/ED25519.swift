//
//  ED25519.swift
//
//  Created by Mitch Lang on 10/24/19.
//

import Foundation

class ED25519: SigningAlgorithm {
    static var rawValue: String = "ed25519"

    static func deriveKeyPair(seed: [UInt8], isValidator: Bool = false) throws -> KeyPair {
        let prefix: String = "ED"
        if isValidator {
            throw KeypairsErrors.validation("Validator key pairs cannot use Ed25519")
        }
        let rawPrivateKey = [UInt8](Data(seed).sha512().prefix(32))
        let publicKey = try! prefix.asHexArray() + Ed25519.calcPublicKey(secretKey: rawPrivateKey)
        let privateKey = try! prefix.asHexArray() + rawPrivateKey
        print(privateKey.toHex)
        return KeyPair(privateKey: privateKey.toHex, publicKey: publicKey.toHex)
    }

    static func sign(message: [UInt8], privateKey: [UInt8]) throws -> [UInt8] {
        let privateKey = [UInt8](privateKey.suffix(from: 1))
        return Ed25519.sign(message: message, secretKey: privateKey)
    }

    static func verify(signature: [UInt8], message: [UInt8], publicKey: [UInt8]) throws -> Bool {
        // remove 1 byte prefix from public key
        let publicKey = [UInt8](publicKey.suffix(from: 1))
        return Ed25519.verify(signature: signature, message: message, publicKey: publicKey)
    }

}
