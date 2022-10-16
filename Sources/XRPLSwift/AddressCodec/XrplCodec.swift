//
//  XrplCodec.swift
//
//
//  Created by Denis Angell on 7/2/22.
//

import Foundation

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/addresscodec/codec.py

/// Account address (20 bytes)
let _CLASSIC_ADDRESS_PREFIX: [UInt8] = [0x0] // swiftlint:disable:this identifier_name
/// value is 35; Account public key (33 bytes)
let _ACCOUNT_PUBLIC_KEY_PREFIX: [UInt8] = [0x23] // swiftlint:disable:this identifier_name
/// [1, 225, 75]
let _ED25519_SEED_PREFIX: [UInt8] = [0x01, 0xE1, 0x4B] // swiftlint:disable:this identifier_name
/// value is 33; Seed value (for secret keys) (16 bytes)
let _FAMILY_SEED_PREFIX: [UInt8] = [0x21] // swiftlint:disable:this identifier_name
/// # value is 28; Validation public key (33 bytes)
let _NODE_PUBLIC_KEY_PREFIX: [UInt8] = [0x1C] // swiftlint:disable:this identifier_name
let SEED_LENGTH: Int = 16 // swiftlint:disable:this identifier_name
let _CLASSIC_ADDRESS_LENGTH: Int = 20 // swiftlint:disable:this identifier_name
let _NODE_PUBLIC_KEY_LENGTH: Int = 33 // swiftlint:disable:this identifier_name
let _ACCOUNT_PUBLIC_KEY_LENGTH: Int = 33 // swiftlint:disable:this identifier_name

public class XrplCodec {
    public init() {}

    /**
     Encode bytes
     - parameters:
        - bytes: Bytes to be encoded.
        - prefix: The prefix prepended to the bytestring
        - expectedLength: The expected length
     - returns:
     Returns the base58 encoding of the bytestring, with the given data prefix
     (which indicates type) and while ensuring the bytestring is the expected
     length.
     - throws:
     An AddressCodecError Error.
     */
    public static func encode(_ bytes: [UInt8], _ prefix: [UInt8], _ expectedLength: Int) throws -> String {
        if bytes.count != expectedLength {
            let errorMessage: String = "`\(bytes.count)` does not match \(expectedLength). Ensure that the bytes are a [UInt8]."
            throw AddressCodecError.unexpectedPayloadLength(error: errorMessage)
        }
        let payload: [UInt8] = prefix + bytes
        let check = [UInt8](Data(payload).sha256().sha256().prefix(through: 3))
        let payloadCheck: [UInt8] = payload + check
        return String(base58Encoding: Data(payloadCheck))
    }

    /**
     Decode the b58String
     - parameters:
        - b58String: A base58 value
        - prefix: The prefix prepended to the bytestring
     - returns:
     The byte decoding of the base58-encoded string.
     - throws:
     An AddressCodecError Error.
     */
    public static func decode(_ b58String: String, _ prefix: [UInt8]) throws -> [UInt8] {
        let prefixLength: Int = prefix.count
        guard let decodedData = Base58.base58CheckDecode(b58String) else {
            throw AddressCodecError.invalidCheckSum()
        }
        if [UInt8](decodedData[0..<(prefixLength)]) != prefix {
            throw AddressCodecError.invalidPrefix()
        }
        return [UInt8](decodedData[prefixLength...])
    }

    /**
     Returns an encoded seed.
     - parameters:
        - entropy: Entropy bytes of SEED_LENGTH.
        - type: Either ED25519 or SECP256K1.
     - returns:
     An encoded seed.
     - throws:
     AddressCodecError: If entropy is not of length SEED_LENGTH
     or the encoding type is not one of CryptoAlgorithm.
     */
    public static func encodeSeed(_ entropy: [UInt8], _ type: AlgorithmType) throws -> String {
        if entropy.count != SEED_LENGTH {
            throw AddressCodecError.invalidLength(error: "Entropy must have length \(SEED_LENGTH)")
        }
        if !AlgorithmType.types.contains(type) {
            throw AddressCodecError.invalidType(error: "Encoding type must be one of \(AlgorithmType.types)")
        }
        let prefix: [UInt8] = type == .ed25519 ? _ED25519_SEED_PREFIX : _FAMILY_SEED_PREFIX
        return try encode(entropy, prefix, SEED_LENGTH)
    }

    /**
     Returns (decoded seed, its algorithm).
     - parameters:
        - seed: The b58 encoding of a seed.
     - returns:
     (decoded seed, its algorithm).
     - throws:
     SeedError: If the seed is invalid.
     */
    public static func decodeSeed(_ seed: String) throws -> ([UInt8], AlgorithmType) {
        for seedType in AlgorithmType.types {
            if seedType == .ed25519 {
                do {
                    let prefix: [UInt8] = _ED25519_SEED_PREFIX
                    let decodedResult: [UInt8] = try self.decode(seed, prefix)
                    return (decodedResult, AlgorithmType.ed25519)
                } catch {
                    continue
                }
            }
            if seedType == .secp256k1 {
                do {
                    let prefix: [UInt8] = _FAMILY_SEED_PREFIX
                    let decodedResult: [UInt8] = try self.decode(seed, prefix)
                    return (decodedResult, AlgorithmType.secp256k1)
                } catch {
                    continue
                }
            }
        }
        throw AddressCodecError.seedError()
    }

    /**
     Returns the classic address encoding of these bytes as a base58 string.
     - parameters:
        - bytes: Bytes to be encoded.
     - returns:
     The classic address encoding of these bytes as a base58 string.
     */
    public static func encodeClassicAddress(_ bytes: [UInt8]) throws -> String {
        return try encode(bytes, _CLASSIC_ADDRESS_PREFIX, _CLASSIC_ADDRESS_LENGTH)
    }

    /**
     Returns the decoded bytes of the classic address.
     - parameters:
        - classicAddress: Classic address to be decoded.
     - returns:
     The decoded bytes of the classic address.
     */
    public static func decodeClassicAddress(_ classicAddress: String) throws -> [UInt8] {
        return try decode(classicAddress, _CLASSIC_ADDRESS_PREFIX)
    }

    /**
     Returns the node public key encoding of these bytes as a base58 string.
     - parameters:
        - bytes: Bytes to be encoded.
     - returns:
     The node public key encoding of these bytes as a base58 string.
     */
    public static func encodeNodePublicKey(_ bytes: [UInt8]) throws -> String {
        return try encode(bytes, _NODE_PUBLIC_KEY_PREFIX, _NODE_PUBLIC_KEY_LENGTH)
    }

    /**
     Returns the decoded bytes of the node public key
     - parameters:
        - nodePublicKey: Node public key to be decoded.
     - returns:
     The decoded bytes of the node public key.
     */
    public static func decodeNodePublicKey(_ nodePublicKey: String) throws -> [UInt8] {
        return try decode(nodePublicKey, _NODE_PUBLIC_KEY_PREFIX)
    }

    /**
     Returns the account public key encoding of these bytes as a base58 string.
     - parameters:
        - bytes: Bytes to be encoded.
     - returns:
     The account public key encoding of these bytes as a base58 string.
     */
    public static func encodeAccountPublicKey(_ bytes: [UInt8]) throws -> String {
        return try encode(bytes, _ACCOUNT_PUBLIC_KEY_PREFIX, _ACCOUNT_PUBLIC_KEY_LENGTH)
    }

    /**
     Returns the decoded bytes of the account public key.
     - parameters:
        - accountPublicKey: Account public key to be decoded.
     - returns:
     The decoded bytes of the account public key.
     */
    public static func decodeAccountPublicKey(_ accountPublicKey: String) throws -> [UInt8] {
        return try decode(accountPublicKey, _ACCOUNT_PUBLIC_KEY_PREFIX)
    }

    public static func isValidClassicAddress(classicAddress: String) -> Bool {
        do {
            _ = try decodeClassicAddress(classicAddress)
            return true
        } catch {
            return false
        }
    }
}
