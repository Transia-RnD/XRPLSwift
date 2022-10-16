//
//  AddressCodec.swift
//
//
//  Created by Denis Angell on 7/2/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/addresscodec/main.py

import Foundation

public struct FullClassicAddress {
    public var classicAddress: String = ""
    public var tag: Int?
    public var isTest = false
}

public class AddressCodec {
    // swiftlint:disable:next identifier_name
    final var MAX_32_BIT_UNSIGNED_INT: Int = 4294967295

    /**
     Returns the X-Address representation of the data.
     - parameters:
        - classicAddress: The base58 encoding of the classic address.
        - tag: The destination tag.
        - isTest: Whether it is the test network or the main network.
     - returns:
     The X-Address representation of the data.
     - throws:
     XRPLAddressCodecException: If the classic address does not have enough bytes
     or the tag is invalid.
     */
    public static func classicAddressToXAddress(
        classicAddress: String,
        tag: Int? = nil,
        isTest: Bool = false
    ) throws -> String {
        let accountID = try XrplCodec.decodeClassicAddress(classicAddress)
        if accountID.count != 20 {
            throw AddressCodecError.invalidLength(error: "Account ID must be 20 bytes")
        }

        let flags: [UInt8] = tag == nil ? [0x00] : [0x01]
        // swiftlint:disable:next force_unwrapping
        let tag = tag == nil ? [UInt8](UInt64(0).data) : [UInt8](UInt64(tag!).data)

        //        if tag != nil && tag > [UInt8](MAX_32_BIT_UNSIGNED_INT) {
        //            throw AddressCodecError.invalidLength(error: "Invalid tag")
        //        }

        let prefix: [UInt8] = isTest ? [0x04, 0x93] : [0x05, 0x44]
        let concatenated = prefix + accountID + flags + tag
        let check = [UInt8](Data(concatenated).sha256().sha256().prefix(through: 3))
        let concatenatedCheck: [UInt8] = concatenated + check
        return String(base58Encoding: Data(concatenatedCheck))
    }

    /**
     Returns a tuple containing the classic address, tag, and whether the address
     is on a test network for an X-Address.
     - parameters:
        - xAddress: base58-encoded X-Address.
     - returns:
     A dict containing: classicAddress: the base58 classic address, tag: the destination tag, isTest: whether the address is on the test network (or main)
     - throws:
     AddressCodecError: If the base decoded value is invalid or the base58 check is invalid
     */
    public static func xAddressToClassicAddress(
        _ xAddress: String
    ) throws -> FullClassicAddress {
        guard let data = Data(base58Decoding: xAddress) else {
            throw AddressCodecError.valueError
        }
        let check = data.suffix(4).bytes
        let concatenated = data.prefix(31).bytes
        if check != [UInt8](Data(concatenated).sha256().sha256().prefix(through: 3)) {
            throw AddressCodecError.invalidAddress
        }
        let isTest: Bool = try self.isTestAddress([UInt8](concatenated[..<2]))
        let tag: Int? = try self.tagFromBuffer(concatenated)
        let classicAddressBytes: [UInt8] = [UInt8](concatenated[2..<22])
        let classicAddress = try XrplCodec.encodeClassicAddress(classicAddressBytes)
        return FullClassicAddress(classicAddress: classicAddress, tag: tag, isTest: isTest)
    }

    /**
     Returns whether a decoded X-Address is a test address.
     - parameters:
        - prefix: The first 2 bytes of an X-Address.
     - returns:
     Whether a decoded X-Address is a test address.
     - throws:
     XRPLAddressCodecException: If the prefix is invalid.
     */
    static func isTestAddress(_ prefix: [UInt8]) throws -> Bool {
        if [0x05, 0x44] == prefix {
            return false
        }
        if [0x04, 0x93] == prefix {
            return true
        }
        throw AddressCodecError.invalidAddress
    }

    /**
     Returns the destination tag extracted from the suffix of the X-Address.
     - parameters:
        - buffer: The buffer to extract a destination tag from.
     - returns:
     The destination tag extracted from the suffix of the X-Address.
     - throws:
     XRPLAddressCodecException: If the address is unsupported.
     */
    static func tagFromBuffer(_ buffer: [UInt8]) throws -> Int? {
        let flags = buffer[22]
        if flags >= 2 {
            // No support for 64-bit tags at this time
            throw AddressCodecError.unsupportedAddress
        }
        if flags == 1 {
            // Little-endian to big-endian
            return (
                Int(buffer[23]) +
                    Int(buffer[24]) *
                    Int(0x100) +
                    Int(buffer[25]) *
                    Int(0x10000) +
                    Int(buffer[26]) *
                    Int(0x1000000)
            )
        }
        let tagBytes = buffer[23...]
        let data = Data(tagBytes)
        let tagInt: UInt64 = data.withUnsafeBytes { $0.pointee }
        // swiftlint:disable:next force_unwrapping
        let tag: Int? = flags == 0x00 ? nil : Int(String(tagInt))!
        return tag
    }

    /**
     Returns whether `xAddress` is a valid X-Address.
     - parameters:
        - xAddress: The X-Address to check for validity.
     - returns:
     Whether `xAddress` is a valid X-Address.
     */
    public static func isValidXAddress(_ xAddress: String) -> Bool {
        do {
            _ = try self.xAddressToClassicAddress(xAddress)
            return true
        } catch {
            return false
        }
    }
}
