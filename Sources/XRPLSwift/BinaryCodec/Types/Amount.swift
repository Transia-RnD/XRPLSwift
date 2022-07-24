//
//  Amount.swift
//
//
//  Created by Denis Angell on 7/4/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/binarycodec/types/amount.py

import Foundation

internal let MIN_IOU_EXPONENT: Int = -96
internal let MAX_IOU_EXPONENT: Int = 80
internal let MAX_IOU_PRECISION: Int = 16
internal let MAX_DROPS: Decimal = Decimal(string: "1e17")!
internal let MIN_XRP: Decimal = Decimal(string: "1e-6")!
internal let mask = Int(0x00000000ffffffff)

// other constants:
internal let NOT_XRP_BIT_MASK: Int = 0x80
internal let POS_SIGN_BIT_MASK: Int = 0x4000000000000000
internal let ZERO_CURRENCY_AMOUNT_HEX: UInt64 = 0x8000000000000000
//internal let ZERO_CURRENCY_AMOUNT_HEX: [UInt8] = [0x80, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0]
internal let NATIVE_AMOUNT_BYTE_LENGTH: Int = 8
internal let CURRENCY_AMOUNT_BYTE_LENGTH: Int = 48

// Constants for validating amounts.

internal let MIN_IOU_MANTISSA: Int = Int(10**15)

internal let MAX_IOU_MANTISSA: Int = Int(10**16 - 1)



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
//    print("STRING: \(value)")
    let decimalValue: Decimal = Decimal(string: value)!
//    print("DECIMAL: \(decimalValue)")
//    print("DECIMAL INT: \(decimalValue.asInt)")
//    print("EXPONENT: \(decimalValue.exponent)")
//    if decimalValue == Int(value: decimalValue) {
    if decimalValue.exponent == decimalValue.asInt {
//        print("PRECISION0: \(decimalValue.digits().count)")
        return decimalValue.digits().count
    }
//    print("PRECISION1: \(decimalValue.digits().count)")
    return decimalValue.digits().count
}

func verifyNoDecimal(decimal: Decimal) throws {
    /*
    Ensure that the value after being multiplied by the exponent
    does not contain a decimal.
    :param decimal: A Decimal object.
    */
    let actualExponent: Int = decimal.exponentXrp
//    print(actualExponent)
    let exponent = Decimal(string: "1e" + String(-(Int(actualExponent) - 15)))
    var intNumberString: String = ""
    if actualExponent == 0 {
//        print("0")
        intNumberString = decimal.digits().joined(separator: "")
    } else {
//        print("1")
        intNumberString = "\(decimal * exponent!)"
    }
//    print("FINAL: \(intNumberString)")
    if !containsDecimal(string: intNumberString) {
        throw BinaryError.unknownError(error: "Decimal place found in intNumberString")
    }
}

func serializeIssuedCurrencyValue(value: String) throws -> [UInt8] {
    /*
    Serializes the value field of an issued currency amount to its bytes representation.
    :param value: The value to serialize, as a string.
    :return: A bytes object encoding the serialized value.
    */
    try verifyIouValue(issuedCurrencyValue: value)
    let decimalValue: Decimal = Decimal(string: value)!
    if decimalValue.isZero {
        return try ZERO_CURRENCY_AMOUNT_HEX.data.toArray(type: UInt8.self).reversed()
    }

    // Convert components to integers ---------------------------------------
    let sign: Int = decimalValue.isSignMinus ? 1 : 0
    let digits: [String] = decimalValue.digits()
    var exp: Int = decimalValue.exponent
    var mantissa: Int = Int(digits.map({ String($0) }).joined(separator: ""))!
    print("SIGN: \(sign)")
    print("DIGITS: \(digits)")
    print("EXP: \(exp)")

    // Canonicalize to expected range ---------------------------------------
    while mantissa < MIN_IOU_MANTISSA && exp > MIN_IOU_EXPONENT {
        mantissa *= 10
        exp -= 1
    }
    
    while mantissa > MAX_IOU_MANTISSA {
        if exp >= MAX_IOU_EXPONENT {
            throw BinaryError.unknownError(error: "Amount overflow in issued currency value \(String(value))")
        }
        mantissa /= 10
        exp += 1
    }

    if exp < MIN_IOU_EXPONENT || mantissa < MIN_IOU_MANTISSA {
        // Round to zero
        return try ZERO_CURRENCY_AMOUNT_HEX.data.toArray(type: UInt8.self).reversed()
    }

    if exp > MAX_IOU_EXPONENT || mantissa > MAX_IOU_MANTISSA {
        throw BinaryError.unknownError(error: "Amount overflow in issued currency value \(String(value))")
    }

    // Convert to bytes ----------------------------------------------------
    var serial = ZERO_CURRENCY_AMOUNT_HEX
    
    if sign == 0 {
        serial |= UInt64(POS_SIGN_BIT_MASK)  // "Is positive" bit set
    }
    serial |= UInt64((exp + 97) << 54)  // next 8 bits are exponents
    serial |= UInt64(mantissa)  // last 54 bits are mantissa
    
    print(serial)
//    print(try serial.data.toArray(type: UInt8.self).reversed())
    return try serial.data.toArray(type: UInt8.self).reversed()
}

//func byteArray<T>(from value: T) -> [UInt8] where T: FixedWidthInteger {
//    withUnsafeBytes(of: value.bigEndian, Array.init)
//}

func serializeXrpAmount(value: String) throws -> [UInt8] {
    /*
    Serializes an XRP amount.
    Args:
        value: A string representing a quantity of XRP.
    Returns:
        The bytes representing the serialized XRP amount.
    */
    try verifyXrpValue(xrpValue: value)
    // set the "is positive" bit (this is backwards from usual two's complement!)
    let valueWithPosBit: Int = Int(value)! | POS_SIGN_BIT_MASK
    return try valueWithPosBit.data.toArray(type: UInt8.self).reversed()
}


func serializeIssuedCurrencyAmount(value: [String: String]) throws -> [UInt8] {
    /*
     Serializes an issued currency amount.
    Args:
        value: A dictionary representing an issued currency amount
    Returns:
         The bytes representing the serialized issued currency amount.
    */
    let amountString: String = value["value"]!
//    print("AMOUNT STRING: \(amountString)")
    let amountBytes: [UInt8] = try serializeIssuedCurrencyValue(value: amountString)
//    print("AMOUNT BYTES: \(amountBytes.toHexString())")
//    print(amountBytes.toHexString())
//    print(value["currency"])
    let currencyBytes: [UInt8] = try Currency.from(value: value["currency"]!).toBytes()
//    print("CUR BYTES: \(currencyBytes)")
    let issuerBytes: [UInt8] = try AccountID.from(value: value["issuer"]!).toBytes()
//    print("ISSUER BYTES: \(issuerBytes)")
    return amountBytes + currencyBytes + issuerBytes
}


class Amount: SerializedType {
    
    static var defaultAmount: Amount = try! Amount(bytes: "4000000000000000".asHexArray())
    
    override init(bytes: [UInt8]? = nil) {
        super.init(bytes: bytes ?? Amount.defaultAmount.bytes)
    }
    
    static func from(value: String) throws -> Amount {
        return try Amount(bytes: serializeXrpAmount(value: value))
    }
        
    static func from(value: [String: String]) throws -> Amount {
//        if IssuedCurrencyAmount.is_dict_of_model(value):
        return try Amount(bytes: serializeIssuedCurrencyAmount(value: value))
    }
    
    override func fromParser(
        parser: BinaryParser,
        hint: Int? = nil
    ) throws -> Amount {
//        print(parser.bytes)
        let parserFirstByte = try parser.peek()
//        print(parserFirstByte)
        let notXrp: Int = (parserFirstByte != 0 ? Int(parserFirstByte) : 0x00) & 0x80
//        print(notXrp)
        var numBytes: Int = 0
        if (notXrp != 0) {
//            print("CURRENCY AMOUNT LENGTH")
            numBytes = CURRENCY_AMOUNT_BYTE_LENGTH
        } else {
//            print("NATIVE AMOUNT LENGTH")
            numBytes = NATIVE_AMOUNT_BYTE_LENGTH
        }
//        print(numBytes)
        return Amount(bytes: try parser.read(n: numBytes))
    }

    override func toJson() -> Any {
        /*
        Construct a JSON object representing this Amount.

        Returns:
            The JSON representation of this amount.
        */
        
        if self.isNative() {
            let sign: String = self.isPositive() ? "" : "-"
            let maskedBytes: Int = Int(self.bytes.toHexString(), radix: 16)! & 0x3FFFFFFFFFFFFFFF
            return "\(sign)\(maskedBytes)"
        }
        
        let parser: BinaryParser = BinaryParser(hex: self.toHex())
        let valueBytes: [UInt8] = try! parser.read(n: 8)
        let currency: Currency = Currency().fromParser(parser: parser)
        let issuer: AccountID = AccountID().fromParser(parser: parser)
        print(issuer.toJson())
        let b1: UInt8 = valueBytes[0]
//        print("B1: \(b1)")
        let b2: UInt8 = valueBytes[1]
//        print("B2: \(b2)")
        let isPositive: UInt8 = b1 & 0x40
//        print("POSITIVE: \(isPositive)")
        let sign: String = (isPositive != 0) ? "" : "-"
//        print("SIGN: \(sign)")
        let exponent: Int = Int(((b1 & 0x3F) << 2) + ((b2 & 0xFF) >> 6)) - 97
//        print("EXPONENT: \(exponent)")
        let mantissa: [UInt8] = [UInt8](arrayLiteral: b2 & 0x3F) + [UInt8](valueBytes[2...])
//        print([UInt8](arrayLiteral: b2 & 0x3F))
//        print([UInt8](valueBytes[2...]).toHexString())
//        print("MANTISSA: \(mantissa)")
        let hexMantissa: String = ([UInt8](arrayLiteral: b2 & 0x3F) + valueBytes[2...]).toHexString()
//        print("HEX MANTISSA: \(hexMantissa)")
        let intMantissa: Int = Int(hexMantissa, radix: 16)!
//        print("INT MANTISSA: \(intMantissa)")
//        print(Decimal(string: "1e\(exponent)")!)
//        print(Decimal(string: "\(sign)\(intMantissa)")!)
        let value: Decimal = Decimal(string: "\(sign)\(intMantissa)")! * Decimal(string: "1e\(exponent)")!
//        print(value)
//
        var valueStr: String = ""
        if value.isZero {
            valueStr = "0"
        } else {
            valueStr = value.description
//            valueStr.rstrip(where: { $0 == "0" })
//            valueStr.rstrip(where: { $0 == "." })
        }
        try! verifyIouValue(issuedCurrencyValue: valueStr)

        return [
            "value": valueStr,
            "currency": currency.toJson(),
            "issuer": issuer.toJson(),
        ]
    }
    
    func isNative() -> Bool {
        /*
         Returns True if this amount is a native XRP amount.

        Returns:
            True if this amount is a native XRP amount, False otherwise.
        */
        // 1st bit in 1st byte is set to 0 for native XRP
        return (self.bytes[0] & 0x80) == 0
    }

    func isPositive() -> Bool {
        /*
         Returns True if 2nd bit in 1st byte is set to 1 (positive amount).

        Returns:
            True if 2nd bit in 1st byte is set to 1 (positive amount),
            False otherwise.
        */
        return (self.bytes[0] & 0x40) > 0
    }
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
//        guard self.exponent == 0, let index = string.firstIndex(of: "."), Int(String(string[index...])) == 0 else {
//            return -1
//        }
        return self.exponent
    }
    
    func digits() -> [String] {
        var string: String = "\(self)"
        if let index = string.firstIndex(of: ".") { string.remove(at: index) }
        if let index = string.firstIndex(of: "-") { string.remove(at: index) }
        string.removeAll(where: { $0 == "0" })
        return Array(string).compactMap { String($0) }
    }
    // TODO: This exists but couldn't find func name
    func compare(_ value: Decimal) -> Int {
        if self > value { return 1 }
        if self < value { return -1 }
        return 0
    }
}

func byteArray<T>(from value: T) -> [UInt8] where T: FixedWidthInteger {
    withUnsafeBytes(of: value.bigEndian, Array.init)
}

extension Int {
    var asBigByteArray: [UInt8] {
        return XRPLSwift.byteArray(from: self)
    }
}

//extension StringProtocol {
//    func rstrip() -> String {
//        let trimSet: NSCharacterSet = NSCharacterSet.whitespacesAndNewlines as NSCharacterSet
//        let wanted = trimSet.inverted
//        print(wanted)
//        if let r = self.rangeOfCharacter(from: CharacterSet(charactersIn: "."), options: .backwards) {
//            let test = self.prefix(upTo: r.upperBound)
//            print(test)
////            return self.prefix(upTo: r.upperBound) as! String
//            return ""
//        }
//        return ""
//    }
//}
