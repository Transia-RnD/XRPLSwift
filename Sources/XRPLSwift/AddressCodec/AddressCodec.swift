//
//  AddressCodec.swift
//
//
//  Created by Denis Angell on 7/2/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/addresscodec/main.py

import Foundation

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
        tag: UInt32? = nil,
        isTest: Bool = false
    ) throws -> String {
        let accountID = try! XrplCodec.decodeClassicAddress(classicAddress: classicAddress)
        let flags: [UInt8] = tag == nil ? [0x00] : [0x01]
        let tag = tag == nil ? [UInt8](UInt64(0).data) : [UInt8](UInt64(tag!).data)
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
     AddressCodecError:If the base decoded value is invalid or the base58 check is invalid
     */
    public static func xAddressToClassicAddress(
        xAddress: String
    ) throws -> [String: AnyObject] {
        guard let data = Data(base58Decoding: xAddress) else {
            throw AddressCodecError.valueError
        }
        let check = data.suffix(4).bytes
        let concatenated = data.prefix(31).bytes
        if check != [UInt8](Data(concatenated).sha256().sha256().prefix(through: 3)) {
            throw AddressCodecError.invalidAddress
        }
        let isTest: Bool = try self.isTestAddress(prefix: [UInt8](concatenated[..<2]))
        let tag: UInt32? = try self.tagFromBuffer(buffer: concatenated)
        let classicAddressBytes: [UInt8] = [UInt8](concatenated[2..<22])
        let classicAddress = try XrplCodec.encodeClassicAddress(bytes: classicAddressBytes)
        return [
            "classicAddress": classicAddress,
            "tag": tag as Any,
            "isTest": isTest
        ] as [String: AnyObject]
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
    static func isTestAddress(prefix: [UInt8]) throws -> Bool {
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
    static func tagFromBuffer(buffer: [UInt8]) throws -> UInt32? {
        let flags = buffer[22]
        if flags >= 2 {
            // No support for 64-bit tags at this time
            throw AddressCodecError.unsupportedAddress
        }
        if flags == 1 {
            // Little-endian to big-endian
            return (
                UInt32(buffer[23]) +
                UInt32(buffer[24]) *
                UInt32(0x100) +
                UInt32(buffer[25]) *
                UInt32(0x10000) +
                UInt32(buffer[26]) *
                UInt32(0x1000000)
            )
        }
        let tagBytes = buffer[23...]
        let data = Data(tagBytes)
        let tagInt: UInt64 = data.withUnsafeBytes { $0.pointee }
        let tag: UInt32? = flags == 0x00 ? nil : UInt32(String(tagInt))!
        return tag
    }

    /**
     Returns whether `xAddress` is a valid X-Address.
     - parameters:
        - xAddress: The X-Address to check for validity.
     - returns:
     Whether `xAddress` is a valid X-Address.
     */
    public static func isValidXAddress(xAddress: String) -> Bool {
        do {
            let result = try self.xAddressToClassicAddress(xAddress: xAddress)
            guard let _ = result["classicAddress"] as? String else {
                return false
            }
            return true
        } catch {
            return false
        }
    }
}
