//
//  XrplCodec.swift
//  
//
//  Created by Denis Angell on 7/2/22.
//

import Foundation

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/addresscodec/codec.py

//# Account address (20 bytes)
let _CLASSIC_ADDRESS_PREFIX: [UInt8] = [0x0]
//# value is 35; Account public key (33 bytes)
let _ACCOUNT_PUBLIC_KEY_PREFIX: [UInt8] = [0x23]
//# [1, 225, 75]
let _ED25519_SEED_PREFIX: [UInt8] = [0x01, 0xE1, 0x4B]
//# value is 33; Seed value (for secret keys) (16 bytes)
let _FAMILY_SEED_PREFIX: [UInt8] = [0x21]
//# value is 28; Validation public key (33 bytes)
let _NODE_PUBLIC_KEY_PREFIX: [UInt8] = [0x1C]

let SEED_LENGTH: Int = 16

let _CLASSIC_ADDRESS_LENGTH: Int = 20
let _NODE_PUBLIC_KEY_LENGTH: Int = 33
let _ACCOUNT_PUBLIC_KEY_LENGTH: Int = 33

public class XrplCodec {
    
    public init() {}
    
    public static func _encode(bytes: [UInt8], prefix: [UInt8], expectedLength: Int) throws -> String {
        /*
        Returns the base58 encoding of the bytestring, with the given data prefix
        (which indicates type) and while ensuring the bytestring is the expected
        length.
        */
        if bytes.count != expectedLength {
            print("BYTES COUNT: \(bytes.count)")
            print("EXP COUNT: \(expectedLength)")
            let errorMessage: String = "unexpectedPayloadLength: `bytes.count` does not match expectedLength. Ensure that the bytes are a [UInt8]."
            throw XrplCodecError.unknownError(error: errorMessage)
        }
        let payload: [UInt8] = prefix + bytes
        let check = [UInt8](Data(payload).sha256().sha256().prefix(through: 3))
        let payloadCheck: [UInt8] = payload + check
        return String(base58Encoding: Data(payloadCheck), alphabet: AddressCodecUtils.xrplAlphabet)
    }
    
    public static func _decode(b58String: String, prefix: [UInt8]) throws -> [UInt8] {
        /*
        b58String: A base58 value
        prefix: The prefix prepended to the bytestring
        Returns the byte decoding of the base58-encoded string.
        */
        let prefixLength: Int = prefix.count
        let decoded = [UInt8](Data(base58Decoding: b58String, alphabet: AddressCodecUtils.xrplAlphabet)!)
        let versionEntropy = decoded.prefix(decoded.count-4)
        if [UInt8](versionEntropy[0...(prefixLength-1)]) != prefix {
            throw XrplCodecError.unknownError(error: "Provided prefix is incorrect")
        }
        return [UInt8](versionEntropy[prefixLength...])
    }
    
    public static func encodeSeed(entropy: [UInt8], type: SeedType) throws -> String {
        if entropy.count != SEED_LENGTH {
            print("Entropy must have length \(SEED_LENGTH)")
            throw XrplCodecError.unknownError(error: "Entropy must have length \(SEED_LENGTH)")
        }
        if !SeedType.types.contains(type) {
            print("Encoding type must be one of \(SeedType.types)")
            throw XrplCodecError.unknownError(error: "Encoding type must be one of \(SeedType.types)")
        }
        let prefix: [UInt8] = type == .ed25519 ? _ED25519_SEED_PREFIX : _FAMILY_SEED_PREFIX
        return try _encode(bytes: entropy, prefix: prefix, expectedLength: SEED_LENGTH)
    }
    
    public static func decodeSeed(seed: String) throws -> ([UInt8], SeedType)  {
        for seedType in SeedType.types {
            if seedType == .ed25519 {
                print("ed25519")
                do {
                    let prefix: [UInt8] = _ED25519_SEED_PREFIX
                    let decodedResult: [UInt8] = try self._decode(b58String: seed, prefix: prefix)
                    return (decodedResult, SeedType.ed25519)
                } catch {
                    continue
                }
            }
            if seedType == .secp256k1 {
                print("secp256k1")
                do {
                    let prefix: [UInt8] = _FAMILY_SEED_PREFIX
                    let decodedResult: [UInt8] = try self._decode(b58String: seed, prefix: prefix)
                    return (decodedResult, SeedType.secp256k1)
                } catch {
                    continue
                }
            }
        }
        throw SeedError.invalidSeed
    }
    
    public static func encodeClassicAddress(bytes: [UInt8]) throws -> String  {
        return try _encode(bytes: bytes, prefix: _CLASSIC_ADDRESS_PREFIX, expectedLength: _CLASSIC_ADDRESS_LENGTH)
    }
    
    public static func decodeClassicAddress(classicAddress: String) throws -> [UInt8]  {
        return try _decode(b58String: classicAddress, prefix: _CLASSIC_ADDRESS_PREFIX)
    }
    
    public static func encodeNodePublicKey(bytes: [UInt8]) throws -> String  {
        return try _encode(bytes: bytes, prefix: _NODE_PUBLIC_KEY_PREFIX, expectedLength: _NODE_PUBLIC_KEY_LENGTH)
    }
    
    public static func decodeNodePublicKey(nodePublicKey: String) throws -> [UInt8]  {
        return try _decode(b58String: nodePublicKey, prefix: _NODE_PUBLIC_KEY_PREFIX)
    }
    
    public static func encodeAccountPublicKey(bytes: [UInt8]) throws -> String  {
        return try _encode(bytes: bytes, prefix: _ACCOUNT_PUBLIC_KEY_PREFIX, expectedLength: _ACCOUNT_PUBLIC_KEY_LENGTH)
    }
    
    public static func decodeAccountPublicKey(accountPublicKey: String) throws -> [UInt8]  {
        return try _decode(b58String: accountPublicKey, prefix: _ACCOUNT_PUBLIC_KEY_PREFIX)
    }
    
    public static func isValidClassicAddress(classicAddress: String) -> Bool {
        do {
            _ = try decodeClassicAddress(classicAddress: classicAddress)
            return true
        } catch {
            return false
        }
    }
}
