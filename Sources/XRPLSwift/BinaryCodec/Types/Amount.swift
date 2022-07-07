//
//  Amount.swift
//
//
//  Created by Denis Angell on 7/4/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/binarycodec/types/amount.py

import Foundation

//let MIN_IOU_EXPONENT: Int = -96
//let MAX_IOU_EXPONENT: Int = 80
//let MAX_IOU_PRECISION: Int = 16
//let MAX_DROPS: Decimal = Decimal('1e17')
//let MIN_XRP: Decimal = Decimal('1e-6')
//let mask = Int(0x00000000ffffffff)


class xAmount: SerializedType {
    // The base class for all binary codec field types.
    
    static var defaultAmount: xAmount = try! xAmount(bytes: "4000000000000000".asHexArray())
    
    override init(bytes: [UInt8]?) {
        super.init(bytes: bytes ?? xAmount.defaultAmount.bytes)
    }
    
    /**
     * Construct an amount from an IOU or string amount
     *
     * @param value An Amount, object representing an IOU, or a string
     *     representing an integer amount
     * @returns An Amount object
     */
    static func from(value: xAmount) throws -> xAmount {
        return value
    }
    
    static func from(value: String) throws -> xAmount {
        let amount = Data(capacity: 8)
        if (type(of: value) == String) {
            xAmount.assertXrpIsValid(value)
            
            let number = UInt64(value)
            
            let intBuf = [Data(capacity: 4), Data(capacity: 4)]
            intBuf[0] = number >> 32 ?? 0
            intBuf[1] = number >> 32 ?? 0
            intBuf[0].writeUInt32BE(Number(number.shiftRight(32)), 0)
            intBuf[1].writeUInt32BE(Number(number.and(mask)), 0)
            
            amount = Buffer.concat(intBuf)
            
            amount[0] |= 0x40
            
            return new Amount(amount)
        }
        
        //        if (type(of: value) != type(of: String.self)) {
        //            if (value.isEmpty) {
        //                return AccountID(bytes: nil)
        //            }
        //
        //            return (value.range(
        //                of: HEX_REGEX,
        //                options: .regularExpression
        //            ) != nil) ? AccountID(bytes: try! value.asHexArray()) : try! self.fromBase58(value: value)
        //        }
        //        throw BinaryError.unknownError(error: "Cannot construct AccountID from value given")
    }
    
    /**
     * Validate XRP amount
     *
     * @param amount String representing XRP amount
     * @returns void, but will throw if invalid amount
     */
    private static func assertXrpIsValid(amount: String) {
        print()
        //        if (amount.indexOf('.') !== -1) {
        //            throw BinaryError.unknownError(error: "\(amount.toString()) is an illegal amount")
        //        }
        //
        //        let decimal = Decimal(amount)
        //        if (!decimal.isZero()) {
        //            //          if (decimal.lt(MIN_XRP) || decimal.gt(MAX_DROPS)) {
        //            //              throw BinaryError.unknownError(error: "\(amount.toString()) is an illegal amount")
        //            //          }
        //        }
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
