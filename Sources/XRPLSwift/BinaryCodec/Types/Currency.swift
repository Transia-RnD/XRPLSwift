//
//  Currency.swift
//  
//
//  Created by Denis Angell on 7/4/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/xrpl/core/binarycodec/types/currency.py

import Foundation


let CURRENCY_CODE_LENGTH: Int = 20

func isIsoCode(value: String) -> Bool {
    // Tests if value is a valid 3-char iso code.
    let regex = try! NSRegularExpression(pattern: "[A-Za-z0-9]{3}")
    let range = NSRange(location: 0, length: value.utf8.count)
    print(regex.matches(in: value, range: range))
    return true
}


func isoCodeFromHex(value: [UInt8]) throws -> String? {
    let candidateIso: String = try! value.toHexString()
    if candidateIso == "XRP" {
        throw BinaryError.unknownError(
            error: "Disallowed currency code: to indicate the currency XRP you must use 20 bytes of 0s"
        )
    }
    if isIsoCode(value: candidateIso) {
        return candidateIso
    }
    return nil
}


func isHex(value: String) -> Bool {
    // Tests if value is a valid 40-char hex string.
    let regex = try! NSRegularExpression(pattern: "[A-F0-9]{40}")
    let range = NSRange(location: 0, length: value.utf8.count)
    print(regex.matches(in: value, range: range))
    return true
}


func isoToBytes(iso: String) throws -> [UInt8] {
    /*
     Convert an ISO code to a 160-bit (20 byte) encoded representation.
     See "Currency codes" subheading in
     `Amount Fields <https://xrpl.org/serialization.html#amount-fields>`_
     */
    if !isIsoCode(value: iso) {
        throw BinaryError.unknownError(error: "Invalid ISO code: \(iso)")
    }
    
    if iso == "XRP" {
        // This code (160 bit all zeroes) is used to indicate XRP in
        // rare cases where a field must specify a currency code for XRP.
        //        return bytes(_CURRENCY_CODE_LENGTH)
        return []
    }
    
    let isoBytes: [UInt8] = try! iso.asHexArray()
    // Currency Codes: https://xrpl.org/currency-formats.html#standard-currency-codes
    // 160 total bits:
    //   8 bits type code (0x00)
    //   88 bits reserved (0's)
    //   24 bits ASCII
    //   16 bits version (0x00)
    //   24 bits reserved (0's)
    return []
    //    return bytes(12) + isoBytes + bytes(5)
}

class xCurrency: SerializedType {
    
    static var defaultCurrency: xCurrency = xCurrency(bytes: Data(bytes: [], count: 20).bytes)
    
    //    public let LENGTH: Int = 20
    public var iso: String? = nil
    
    override init(bytes: [UInt8]?) {
        super.init(bytes: bytes ?? xCurrency.defaultCurrency.bytes)
        
        let codeBytes: [UInt8] = [UInt8](bytes![12...15])
        // Determine whether this currency code is in standard or nonstandard format:
        // https://xrpl.org/currency-formats.html#nonstandard-currency-codes
        if bytes?[0] != 0 {
            // non-standard currency
            self.iso = nil
        } else if bytes?.toHexString() == String(repeating: "0", count: 40) { // all 0s
            // the special case for literal XRP
            self.iso = "XRP"
        } else {
            self.iso = try! isoCodeFromHex(value: codeBytes)
        }
    }
}
