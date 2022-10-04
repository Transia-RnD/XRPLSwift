//
//  BaseX.swift
//  XRPLSwift
//
//  Created by Mitch Lang on 5/3/19.
//

import BigInt
import Foundation
#if NO_USE_CryptoSwift
import CommonCrypto
#else
import CryptoSwift
#endif

/// A static utility class which provides Base58 encoding and decoding functionality.
public enum Base58 {
    /// Length of checksum appended to Base58Check encoded strings.
    private static let checksumLength = 4

    private static let alphabet = [UInt8]("rpshnaf39wBUDNEGHJKLM4PQRST7VWXYZ2bcdeCg65jkm8oFqi1tuvAxyz".utf8)
    private static let zero = BigUInt(0)
    private static let radix = BigUInt(alphabet.count)

    /// Encode the given bytes into a Base58Check encoded string.
    /// - Parameter bytes: The bytes to encode.
    /// - Returns: A base58check encoded string representing the given bytes, or nil if encoding failed.
    public static func base58CheckEncode(_ bytes: [UInt8]) -> String {
        let checksum = calculateChecksum(bytes)
        let checksummedBytes = bytes + checksum
        return Base58.base58Encode(checksummedBytes)
    }

    /// Decode the given Base58Check encoded string to bytes.
    /// - Parameter input: A base58check encoded input string to decode.
    /// - Returns: Bytes representing the decoded input, or nil if decoding failed.
    public static func base58CheckDecode(_ input: String) -> [UInt8]? {
        guard let decodedChecksummedBytes = base58Decode(input) else {
            return nil
        }

        let decodedChecksum = decodedChecksummedBytes.suffix(checksumLength)
        let decodedBytes = decodedChecksummedBytes.prefix(upTo: decodedChecksummedBytes.count - checksumLength)
        let calculatedChecksum = calculateChecksum([UInt8](decodedBytes))

        guard decodedChecksum.elementsEqual(calculatedChecksum, by: { $0 == $1 }) else {
            return nil
        }
        return Array(decodedBytes)
    }

    /// Encode the given bytes to a Base58 encoded string.
    /// - Parameter bytes: The bytes to encode.
    /// - Returns: A base58 encoded string representing the given bytes, or nil if encoding failed.
    public static func base58Encode(_ bytes: [UInt8]) -> String {
        var answer: [UInt8] = []
        var integerBytes = BigUInt(Data(bytes))

        while integerBytes > 0 {
            let (quotient, remainder) = integerBytes.quotientAndRemainder(dividingBy: radix)
            answer.insert(alphabet[Int(remainder)], at: 0)
            integerBytes = quotient
        }

        let prefix = Array(bytes.prefix { $0 == 0 }).map { _ in alphabet[0] }
        answer.insert(contentsOf: prefix, at: 0)

        // swiftlint:disable force_unwrapping
        // Force unwrap as the given alphabet will always decode to UTF8.
        return String(bytes: answer, encoding: String.Encoding.utf8)!
        // swiftlint:enable force_unwrapping
    }

    /// Decode the given base58 encoded string to bytes.
    /// - Parameter input: The base58 encoded input string to decode.
    /// - Returns: Bytes representing the decoded input, or nil if decoding failed.
    public static func base58Decode(_ input: String) -> [UInt8]? {
        var answer = zero
        // swiftlint:disable:next identifier_name
        var i = BigUInt(1)
        let byteString = [UInt8](input.utf8)

        for char in byteString.reversed() {
            guard let alphabetIndex = alphabet.firstIndex(of: char) else {
                return nil
            }
            answer += (i * BigUInt(alphabetIndex))
            i *= radix
        }

        let bytes = answer.serialize()
        // swiftlint:disable:next identifier_name
        let preFix: [UInt8] = Array(byteString.prefix { $0 == alphabet[0] }).map({ $0 == 114 ? 0 : $0 })
        return preFix + bytes
        //        return Array(byteString.prefix { i in i == alphabet[0] }) + bytes
    }

    /// Calculate a checksum for a given input by hashing twice and then taking the first four bytes.
    /// - Parameter input: The input bytes.
    /// - Returns: A byte array representing the checksum of the input bytes.
    private static func calculateChecksum(_ input: [UInt8]) -> [UInt8] {
        let hashedData = sha256(input)
        let doubleHashedData = sha256(hashedData)
        let doubleHashedArray = Array(doubleHashedData)
        return Array(doubleHashedArray.prefix(checksumLength))
    }

    /// Create a sha256 hash of the given data.
    /// - Parameter data: Input data to hash.
    /// - Returns: A sha256 hash of the input data.
    private static func sha256(_ data: [UInt8]) -> [UInt8] {
        #if NO_USE_CryptoSwift
        let res = NSMutableData(length: Int(CC_SHA256_DIGEST_LENGTH))!
        CC_SHA256(
            (Data(data) as NSData).bytes,
            CC_LONG(data.count),
            res.mutableBytes.assumingMemoryBound(to: UInt8.self)
        )
        return [UInt8](res as Data)
        #else
        return data.sha256()
        #endif
    }
}

extension String {
    public init(base58Encoding bytes: Data, alphabet: [UInt8] = AddressCodecUtils.xrplAlphabet) {
        var answer: [UInt8] = []
        let radix = BigUInt(alphabet.count)
        var integerBytes = BigUInt(Data(bytes))

        while integerBytes > 0 {
            let (quotient, remainder) = integerBytes.quotientAndRemainder(dividingBy: radix)
            answer.insert(alphabet[Int(remainder)], at: 0)
            integerBytes = quotient
        }

        let prefix = Array(bytes.prefix { $0 == 0 }).map { _ in alphabet[0] }
        answer.insert(contentsOf: prefix, at: 0)

        // swiftlint:disable force_unwrapping
        // Force unwrap as the given alphabet will always decode to UTF8.
        self = String(bytes: answer, encoding: String.Encoding.utf8)!
        // swiftlint:enable force_unwrapping
    }
}

extension Data {
    init?(base58Decoding string: String, alphabet: [UInt8] = AddressCodecUtils.xrplAlphabet) {
        var answer = BigUInt(0)
        // swiftlint:disable:next identifier_name
        var i = BigUInt(1)
        let radix = BigUInt(alphabet.count)
        let byteString = [UInt8](string.utf8)

        for char in byteString.reversed() {
            guard let index = alphabet.firstIndex(of: char) else {
                return nil
            }
            answer += (i * BigUInt(index))
            i *= radix
        }

        let bytes = answer.serialize()
        let preFix: [UInt8] = Array(byteString.prefix { $0 == alphabet[0] }).map({ $0 == 114 ? 0 : $0 })
        self = preFix + bytes
    }
}
