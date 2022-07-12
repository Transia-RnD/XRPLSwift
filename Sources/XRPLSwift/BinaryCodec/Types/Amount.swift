//
//  Amount.swift
//
//
//  Created by Denis Angell on 7/4/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/binarycodec/types/amount.py

import Foundation

public let MIN_IOU_EXPONENT: Int = -96
public let MAX_IOU_EXPONENT: Int = 80
public let MAX_IOU_PRECISION: Int = 16
public let MAX_DROPS: Decimal = Decimal(string: "1e17")!
public let MIN_XRP: Decimal = Decimal(string: "1e-6")!
public let mask = Int(0x00000000ffffffff)

func containsDecimal(string: String) -> Bool {
    // Returns True if the given string contains a decimal point character.
    return !string.contains(where: { $0 == "." })
}

func verifyXrpValue(xrpValue: String) throws {
    /*
     Validates the format of an XRP amount.
     Raises if value is invalid.
     Args:
     xrp_value: A string representing an amount of XRP.
     Returns:
     None, but raises if xrp_value is not a valid XRP amount.
     Raises:
     XRPLBinaryCodecException: If xrp_value is not a valid XRP amount.
     */
    // Contains no decimal point
    if !containsDecimal(string: xrpValue) {
        throw BinaryError.unknownError(error: "\(xrpValue) is an invalid XRP amount.")
    }
        
    // Within valid range
    let decimal: Decimal = Decimal(string: xrpValue)!
    // Zero is less than both the min and max XRP amounts but is valid.
    if decimal.isZero {
        return
    }
    if (decimal.compare(MIN_XRP) == -1) || (decimal.compare(MAX_DROPS) == 1) {
        throw BinaryError.unknownError(error: "\(xrpValue) is an invalid XRP amount.")
    }
}

func verifyIouValue(issuedCurrencyValue: String) throws {
    /*
    Validates the format of an issued currency amount value.
    Raises if value is invalid.
    Args:
        issued_currency_value: A string representing the "value"
                               field of an issued currency amount.
    Returns:
        None, but raises if issued_currency_value is not valid.
    Raises:
        XRPLBinaryCodecException: If issued_currency_value is invalid.
    */
    let decimalValue: Decimal = Decimal(string: issuedCurrencyValue)!
    if decimalValue.isZero {
        return
    }
    let exponent = decimalValue.exponent
    if (
        (calculatePrecision(value: issuedCurrencyValue) > MAX_IOU_PRECISION)
        || (exponent > MAX_IOU_EXPONENT)
        || (exponent < MIN_IOU_EXPONENT)
    ) {
        throw BinaryError.unknownError(error: "Decimal precision out of range for issued currency value.")
    }
    try verifyNoDecimal(decimal: decimalValue)
}

func calculatePrecision(value: String) -> Int {
    // Calculate the precision of given value as a string.
    print("STRING: \(value)")
    let decimalValue: Decimal = Decimal(string: value)!
    print("DECIMAL: \(decimalValue)")
    print("DECIMAL INT: \(decimalValue.asInt)")
    print("EXPONENT: \(decimalValue.exponent)")
//    if decimalValue == Int(value: decimalValue) {
    if decimalValue.exponent == decimalValue.asInt {
        print("PRECISION0: \(decimalValue.digits().count)")
        return decimalValue.digits().count
    }
    print("PRECISION1: \(decimalValue.digits().count)")
    return decimalValue.digits().count
}

func verifyNoDecimal(decimal: Decimal) throws {
    /*
    Ensure that the value after being multiplied by the exponent
    does not contain a decimal.
    :param decimal: A Decimal object.
    */
    print("DECIMAL: \(decimal)")
    let actualExponent: Int = decimal.exponentXrp
    print(actualExponent)
    let exponent = Decimal(string: "1e" + String(-(Int(actualExponent) - 15)))
    var intNumberString: String = ""
    if actualExponent == 0 {
        print("0")
        intNumberString = decimal.digits().joined(separator: "")
    } else {
        print("1")
        intNumberString = "\(decimal * exponent!)"
    }
    print("FINAL: \(intNumberString)")
    if !containsDecimal(string: intNumberString) {
        throw BinaryError.unknownError(error: "Decimal place found in intNumberString")
    }
}

//func serializeIssuedCurrencyValue(value: String) -> [UInt8] {
//    /*
//    Serializes the value field of an issued currency amount to its bytes representation.
//    :param value: The value to serialize, as a string.
//    :return: A bytes object encoding the serialized value.
//    */
//    verifyIouValue(value)
//    let decimalValue: Decimal = Decimal(value)
//    if decimalValue.isZero() {
//        return _ZERO_CURRENCY_AMOUNT_HEX.to_bytes(8, byteorder="big")
//    }
//
//    // Convert components to integers ---------------------------------------
//    let (sign, digits, exp) = decimalValue.as_tuple()
//    let mantissa: Int = Int("".join([str(d) for d in digits]))
//
//    // Canonicalize to expected range ---------------------------------------
//    while mantissa < MIN_IOU_MANTISSA && exp > MIN_IOU_EXPONENT {
//        mantissa *= 10
//        exp -= 1
//    }
//    while mantissa > MAX_IOU_MANTISSA {
//        if exp >= MAX_IOU_EXPONENT {
//            throw BinaryError.unknownError(error: "Amount overflow in issued currency value \(String(value))")
//        }
//        mantissa //= 10
//        exp += 1
//    }
//
//    if exp < MIN_IOU_EXPONENT or mantissa < MIN_IOU_MANTISSA {
//        // Round to zero
//        _ZERO_CURRENCY_AMOUNT_HEX.to_bytes(8, byteorder="big", signed=False)
//    }
//
//    if exp > MAX_IOU_EXPONENT or mantissa > MAX_IOU_MANTISSA {
//        raise XRPLBinaryCodecException(
//            f"Amount overflow in issued currency value {str(value)}"
//        )
//    }
//
//    // Convert to bytes -----------------------------------------------------
//    let serial = _ZERO_CURRENCY_AMOUNT_HEX  // "Not XRP" bit set
//    if sign == 0 {
//        serial |= _POS_SIGN_BIT_MASK  // "Is positive" bit set
//    }
//    serial |= (exp + 97) << 54  // next 8 bits are exponents
//    serial |= mantissa  // last 54 bits are mantissa
//
//    return serial.to_bytes(8, byteorder="big", signed=False)
//}
//
//func serializeXrpAmount(value: String) -> [UInt8] {
//    /*
//    Serializes an XRP amount.
//    Args:
//        value: A string representing a quantity of XRP.
//    Returns:
//        The bytes representing the serialized XRP amount.
//    */
//    verifyXrpValue(value)
//    // set the "is positive" bit (this is backwards from usual two's complement!)
//    let valueWithPosBit: Int = int(value) | _POS_SIGN_BIT_MASK
//    return valueWithPosBit.to_bytes(8, byteorder="big")
//}
//
//
//func serializeIssuedCurrencyAmount(value: [String: String]) -> [UInt8]:
//    /*
//     Serializes an issued currency amount.
//    Args:
//        value: A dictionary representing an issued currency amount
//    Returns:
//         The bytes representing the serialized issued currency amount.
//    */
//    let amountString: String = value["value"]
//    let amountBytes: [UInt8] = serializeIssuedCurrencyValue(amountString)
//    let currencyBytes: [UInt8] = [UInt8](Currency.from(value["currency"]))
//    let issuerBytes: [UInt8] = [UInt8](AccountID.from(value["issuer"]))
//    return amountBytes + currencyBytes + issuerBytes
//}


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
    
//    static func from(value: String) throws -> xAmount {
//        let amount = Data(capacity: 8)
//        if (type(of: value) == String) {
//            xAmount.assertXrpIsValid(value)
//
//            let number = UInt64(value)
//
//            let intBuf = [Data(capacity: 4), Data(capacity: 4)]
//            intBuf[0] = number >> 32 ?? 0
//            intBuf[1] = number >> 32 ?? 0
//            intBuf[0].writeUInt32BE(Number(number.shiftRight(32)), 0)
//            intBuf[1].writeUInt32BE(Number(number.and(mask)), 0)
//
//            amount = Buffer.concat(intBuf)
//
//            amount[0] |= 0x40
//
//            return new Amount(amount)
//        }
//
//        //        if (type(of: value) != type(of: String.self)) {
//        //            if (value.isEmpty) {
//        //                return AccountID(bytes: nil)
//        //            }
//        //
//        //            return (value.range(
//        //                of: HEX_REGEX,
//        //                options: .regularExpression
//        //            ) != nil) ? AccountID(bytes: try! value.asHexArray()) : try! self.fromBase58(value: value)
//        //        }
//        //        throw BinaryError.unknownError(error: "Cannot construct AccountID from value given")
//    }
//
//    /**
//     * Validate XRP amount
//     *
//     * @param amount String representing XRP amount
//     * @returns void, but will throw if invalid amount
//     */
//    private static func assertXrpIsValid(amount: String) {
//        print()
//        //        if (amount.indexOf('.') !== -1) {
//        //            throw BinaryError.unknownError(error: "\(amount.toString()) is an illegal amount")
//        //        }
//        //
//        //        let decimal = Decimal(amount)
//        //        if (!decimal.isZero()) {
//        //            //          if (decimal.lt(MIN_XRP) || decimal.gt(MAX_DROPS)) {
//        //            //              throw BinaryError.unknownError(error: "\(amount.toString()) is an illegal amount")
//        //            //          }
//        //        }
//    }
//
//    /**
//     * Overload of toJSON
//     *
//     * @returns the base58 string for this AccountID
//     */
//    func toJson() -> String {
//        return try! XrplCodec.encodeClassicAddress(bytes: self.bytes)
//    }
}

extension Decimal {
    
    var asInt: Int {
        guard let int =  Int("\(self)") else {
            return 0
        }
        return int
    }
    
    var exponentXrp: Int {
        let string: String = "\(self)"
        guard self.exponent == 0, let index = string.firstIndex(of: "."), Int(String(string[index...])) == 0 else {
            return -1
        }
        return self.exponent
    }
    
    func digits() -> [String] {
        var string: String = "\(self)"
        if let index = string.firstIndex(of: ".") { string.remove(at: index) }
        if let index = string.firstIndex(of: "-") { string.remove(at: index) }
        return Array(string).compactMap { String($0) }
    }
    // TODO: This exists but couldn't find func name
    func compare(_ value: Decimal) -> Int {
        if self > value { return 1 }
        if self < value { return -1 }
        return 0
    }
}
