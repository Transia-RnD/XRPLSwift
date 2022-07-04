//
//  AccountID.swift
//
//
//  Created by Denis Angell on 7/2/22.
//

import Foundation
import CryptoSwift

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/binarycodec/types/serialized_type.py

let HEX_REGEX: String = #"^[A-F0-9]{40}$"#

class AccountID: Hash160 {
    // The base class for all binary codec field types.
    
    static var defaultAccountID: AccountID = AccountID(bytes: Data(bytes: [], count: 20).bytes)
    
    init(bytes: [UInt8]?) {
        super.init(bytes ?? AccountID.defaultAccountID.bytes)
    }
    
    /**
     * Defines how to construct an AccountID
     *
     * @param value either an existing AccountID, a hex-string, or a base58 r-Address
     * @returns an AccountID object
     */
    static func from(value: AccountID) throws -> AccountID {
        return value
    }
    
    static func from(value: String) throws -> AccountID {
        if (type(of: value) != type(of: String.self)) {
            if (value.isEmpty) {
                return AccountID(bytes: nil)
            }
            
            return (value.range(
                of: HEX_REGEX,
                options: .regularExpression
            ) != nil) ? AccountID(bytes: try! value.asHexArray()) : try! self.fromBase58(value: value)
        }
        throw BinaryError.unknownError(error: "Cannot construct AccountID from value given")
    }
    
    /**
     * Defines how to build an AccountID from a base58 r-Address
     *
     * @param value a base58 r-Address
     * @returns an AccountID object
     */
    static func fromBase58(value: String) throws -> AccountID {
        if AddressCodec.isValidXAddress(xAddress: value) {
            let classicDict: [String: AnyObject] = try! AddressCodec.xAddressToClassicAddress(xAddress: value)
            let classic: String = classicDict["classicAddress"] as! String
            let tag: Int = classicDict["tag"] as! Int
            if (tag != 0) {
              throw BinaryError.unknownError(error: "Only allowed to have tag on Account or Destination")
            }
            return AccountID(bytes: try! XrplCodec.decodeClassicAddress(classicAddress: classic))
        } else {
            return AccountID(bytes: try! XrplCodec.decodeClassicAddress(classicAddress: value))
        }
    }
    
    /**
     * Overload of toJSON
     *
     * @returns the base58 string for this AccountID
     */
    func toJson() -> String {
        return try! XrplCodec.encodeClassicAddress(bytes: self.bytes)
    }
}
