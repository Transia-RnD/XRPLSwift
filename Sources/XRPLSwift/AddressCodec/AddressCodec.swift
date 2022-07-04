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

    public static func xAddressToClassicAddress(
        xAddress: String
    ) throws -> [String: AnyObject] {
        let data = Data(base58Decoding: xAddress)!
        let check = data.suffix(4).bytes

        let concatenated = data.prefix(31).bytes
        if check != [UInt8](Data(concatenated).sha256().sha256().prefix(through: 3)) {
            throw AddressCodecError.invalidAddress
        }
        
        let isTest: Bool = try self.isTestAddress(prefix: [UInt8](concatenated[..<2]))
        
        let tag: UInt32 = try self.tagFromBuffer(buf: concatenated)
        
        let classicAddressBytes: [UInt8] = [UInt8](concatenated[2..<22])
        
        let classicAddress = try XrplCodec.encodeClassicAddress(bytes: classicAddressBytes)
        
        return [
            "classicAddress": classicAddress,
            "tag": tag,
            "isTest": isTest,
        ] as [String: AnyObject]
    }
    
    static func isTestAddress(prefix: [UInt8]) throws -> Bool {
        if [0x05, 0x44] == prefix {
            return false
        }
        if [0x04, 0x93] == prefix {
            return true
        }
        throw AddressCodecError.invalidAddress
    }

    static func tagFromBuffer(buf: [UInt8]) throws -> UInt32 {
        let flags = buf[22]
        if (flags >= 2) {
            // No support for 64-bit tags at this time
            throw AddressCodecError.unsupportedAddress
        }
        //        if flag == 1 {
        //            // Little-endian to big-endian
        //            return buf[23] + buf[24] * 0x100 + buf[25] * 0x10000 + buf[26] * 0x1000000
        //        }
        let tagBytes = buf[23...]
        let data = Data(tagBytes)
        let _tag: UInt64 = data.withUnsafeBytes { $0.pointee }
        let tag: UInt32? = flags == 0x00 ? nil : UInt32(String(_tag))!
        return tag!
    }

    public static func isValidXAddress(xAddress: String) -> Bool {
        let result = try? self.xAddressToClassicAddress(xAddress: xAddress)
        guard let _ = result?["classicAddress"] as? String else {
            return false
        }
        return true
    }
}
