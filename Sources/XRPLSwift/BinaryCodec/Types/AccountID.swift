//
//  AccountID.swift
//
//
//  Created by Denis Angell on 7/4/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/binarycodec/types/account_id.py

import CryptoSwift
import Foundation

// swiftlint:disable:next identifier_name
internal let HEX_REGEX: String = #"^[A-F0-9]{40}$"#
internal let LENGTH20: Int = 20

class AccountID: Hash160 {
    private let LENGTH: Int = 20
    static var defaultAccountID = AccountID([UInt8].init(repeating: 0x0, count: 20))

    override init(_ bytes: [UInt8]? = nil) {
        super.init(bytes ?? AccountID.defaultAccountID.bytes)
    }

    static func from(value: AccountID) throws -> AccountID {
        return value
    }

    override static func from(value: String) throws -> AccountID {
        if value.isEmpty {
            return AccountID(nil)
        }

        return (value.range(
            of: HEX_REGEX,
            options: .regularExpression
        ) != nil) ? AccountID(try value.asHexArray()) : try AccountID.fromBase58(value: value)
    }

    static func fromBase58(value: String) throws -> AccountID {
        if AddressCodec.isValidXAddress(xAddress: value) {
            let classicDict: [String: AnyObject] = try AddressCodec.xAddressToClassicAddress(xAddress: value)
            let classic: String = classicDict["classicAddress"] as! String
            let tag: Int = classicDict["tag"] as! Int
            if tag != 0 {
              throw BinaryError.unknownError(error: "Only allowed to have tag on Account or Destination")
            }
            return AccountID(try XrplCodec.decodeClassicAddress(classicAddress: classic))
        } else {
            return AccountID(try XrplCodec.decodeClassicAddress(classicAddress: value))
        }
    }

    override func fromParser(
        parser: BinaryParser,
        hint: Int? = nil
    ) -> AccountID {
        return AccountID(try! parser.read(n: hint ?? LENGTH20))
    }

    override func toJson() -> String {
        return try! XrplCodec.encodeClassicAddress(bytes: self.bytes)
    }
}
