//
//  CryptoImplementation.swift
//  
//
//  Created by Denis Angell on 07/24/22.
//

import Foundation

protocol CryptoImplementation {
    static func deriveKeyPair(seed: [UInt8]) throws -> KeyPair
    static func sign(message: [UInt8], privateKey: [UInt8]) throws -> [UInt8]
    static func verify(signature: [UInt8], message: [UInt8], publicKey: [UInt8]) throws -> Bool
}

protocol SigningAlgorithm {
    static func deriveKeyPair(seed: [UInt8]) throws -> KeyPair
    static func sign(message: [UInt8], privateKey: [UInt8]) throws -> [UInt8]
    static func verify(signature: [UInt8], message: [UInt8], publicKey: [UInt8]) throws -> Bool
}
