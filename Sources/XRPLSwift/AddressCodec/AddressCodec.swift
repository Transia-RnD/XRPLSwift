//
//  AddressCodec.swift
//
//
//  Created by Denis Angell on 7/2/22.
//

import Foundation

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/addresscodec/main.py

//"classic_address_to_xaddress",
//"decode_account_public_key",
//"decode_classic_address",
//"decode_node_public_key",
//"decode_seed",
//"encode_seed",
//"encode_account_public_key",
//"encode_classic_address",
//"encode_node_public_key",
//"is_valid_classic_address",
//"is_valid_xaddress",
//"SEED_LENGTH",
//"xaddress_to_classic_address",
//"XRPLAddressCodecException",
//"XRPL_ALPHABET",

//let PREFIX_BYTES = {
//    // 5, 68
//main: Buffer.from([0x05, 0x44]),
//    // 4, 147
//test: Buffer.from([0x04, 0x93]),
//}

let MAX_32_BIT_UNSIGNED_INT: Int = 4294967295

public class AddressCodec {

    public init() {}

    public static func classicAddressToXAddress(
        classicAddress: String,
        tag: UInt32? = nil,
        isTest: Bool = false
    ) throws -> String {
        let accountID = SeedWallet.accountID(for: classicAddress)
        let prefix: [UInt8] = isTest ? [0x04, 0x93] : [0x05, 0x44]
        let flags: [UInt8] = tag == nil ? [0x00] : [0x01]
        let tag = tag == nil ? [UInt8](UInt64(0).data) : [UInt8](UInt64(tag!).data)
        let concatenated = prefix + accountID + flags + tag
        let check = [UInt8](Data(concatenated).sha256().sha256().prefix(through: 3))
        let concatenatedCheck: [UInt8] = concatenated + check
        return String(base58Encoding: Data(concatenatedCheck), alphabet: AddressCodecUtils.xrplAlphabet)
    }

//    public static func xAddressToClassicAddress(
//        xAddress: String
//    ) throws -> [String: AnyObject] {
//        let ( accountId, tag, isTest ) = decodeXAddress(xAddress: xAddress)
////        let classicAddress = encodeAccountID(accountId)
//        let classicAddress = "encodeAccountID(accountId)"
//        return [
//            "classicAddress": classicAddress as AnyObject,
//            "tag": tag,
//            "isTest": isTest,
//        ]
//    }
//
//    public static func decodeXAddress(xAddress: String) throws -> (String, UInt32, Bool) {
//        let data = Data(base58Decoding: xAddress)!
//        let check = data.suffix(4).bytes
//
//        let concatenated = data.prefix(31).bytes
//        if check != [UInt8](Data(concatenated).sha256().sha256().prefix(through: 3)) {
//            throw AddressError.unknownError
//        }
//        let flags = concatenated[22]
//        let accountId = concatenated[2..<22]
//        let tag: UInt32 = tagFromBuffer(concatenated)
//        let isTest: Bool = isBufferForTestAddress(concatenated)
//        return (accountId, tag, isTest)
//    }
//
//    internal func isBufferForTestAddress(buf: Data) throws -> Bool {
//        let decodedPrefix = buf[..<2]
//        if Data(fromArray: [0x05, 0x44]) == decodedPrefix {
//            return false
//        }
//        if Data(fromArray: [0x04, 0x93]) == decodedPrefix {
//            return true
//        }
//        throw AddressError.invalidAddress
//    }
//
//    internal func tagFromBuffer(buf: Data) throws -> UInt32 {
//        let flags = buf[22]
//        if (flags >= 2) {
//            // No support for 64-bit tags at this time
//            throw AddressError.unsupportedAddress
//        }
//        //        if flag == 1 {
//        //            // Little-endian to big-endian
//        //            return buf[23] + buf[24] * 0x100 + buf[25] * 0x10000 + buf[26] * 0x1000000
//        //        }
//        let tagBytes = buf[23...]
//        let data = Data(tagBytes)
//        let _tag: UInt64 = data.withUnsafeBytes { $0.pointee }
//        let tag: UInt32? = flags == 0x00 ? nil : UInt32(String(_tag))!
//        return tag!
//    }
//
//    public static func isValidXAddress(xAddress: string) -> Bool {
//        guard try! self.decodeXAddress(xAddress: xAddress) else {
//            return false
//        }
//        return true
//    }
}
