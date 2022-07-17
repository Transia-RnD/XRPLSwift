//
//  TestCurrency.swift
//
//
//  Created by Denis Angell on 7/4/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/tests/unit/core/binarycodec/types/test_currency.py

import XCTest
@testable import XRPLSwift

final class TestCurrency: XCTestCase {
    
    public let XRP_HEX_CODE: String = "0000000000000000000000000000000000000000"
    public let ILLEGAL_XRP_HEX_CODE: String = "0000000000000000000000005852500000000000"
    public let USD_HEX_CODE: String = "0000000000000000000000005553440000000000"
    public let NONSTANDARD_HEX_CODE: String = "015841551A748AD2C1F76FF6ECB0CCCD00000000"
    public let NOT_RECOMMENDED_HEX_CODE: String = "0000000000414C6F676F30330000000000000000"
    public let XRP_ISO: String = "XRP"
    public let USD_ISO: String = "USD"
    
    func test_is_iso_code() {
        let validCode: String = "ABC"
        let validCodeNumeric: String = "123"
        let invalidCodeLong: String = "LONG"
        let invalidCodeShort: String = "NO"
        XCTAssertTrue(isIsoCode(value: validCode))
        XCTAssertTrue(isIsoCode(value: validCodeNumeric))
        XCTAssertTrue(isIsoCode(value: invalidCodeLong))
        XCTAssertTrue(isIsoCode(value: invalidCodeShort))
    }

//    func test_is_hex() {
//            # Valid = 40 char length and only valid hex chars
//            valid_hex = "0000000000000000000000005553440000000000"
//            invalid_hex_long = "0000000000000000000000005553440000000000123455"
//            invalid_hex_short = "1234"
//            invalid_hex_chars = "USD0000000000000000000005553440000000000"
//            self.assertTrue(currency._is_hex(valid_hex))
//            self.assertFalse(currency._is_hex(invalid_hex_long))
//            self.assertFalse(currency._is_hex(invalid_hex_short))
//            self.assertFalse(currency._is_hex(invalid_hex_chars))
//    }
//
//    func test_iso_to_bytes() {
//            # Valid non-XRP
//            usd_iso_bytes = currency._iso_to_bytes(USD_ISO)
//            # convert bytes to hex string for comparison to expectation
//            self.assertEqual(usd_iso_bytes.hex(), USD_HEX_CODE)
//
//            # Valid XRP
//            xrp_iso_bytes = currency._iso_to_bytes(XRP_ISO)
//            # convert bytes to hex string for comparison to expectation
//            self.assertEqual(xrp_iso_bytes.hex(), XRP_HEX_CODE)
//
//            # Error case
//            invalid_iso = "INVALID"
//            self.assertRaises(XRPLBinaryCodecException, currency._iso_to_bytes, invalid_iso)
//    }
//
//    func test_construction_from_hex_standard() {
//            # XRP case
//            currency_object = currency.Currency.from_value(XRP_HEX_CODE)
//            self.assertEqual(currency_object.to_json(), XRP_ISO)
//
//            # General case
//            currency_object = currency.Currency.from_value(USD_HEX_CODE)
//            self.assertEqual(currency_object.to_json(), USD_ISO)
//
//    }
//
//    func test_construction_from_iso_code_standard() {
//            # XRP case
//            currency_object = currency.Currency.from_value(XRP_ISO)
//            self.assertEqual(currency_object.to_hex(), XRP_HEX_CODE)
//
//            # General case
//            currency_object = currency.Currency.from_value(USD_ISO)
//            self.assertEqual(currency_object.to_hex(), USD_HEX_CODE)
//    }
//
//    func test_construction_from_hex_nonstandard() {
//            currency_object = currency.Currency.from_value(NONSTANDARD_HEX_CODE)
//            self.assertEqual(currency_object.to_json(), NONSTANDARD_HEX_CODE)
//    }
//
//    func test_construction_from_hex_nonrecommended() {
//            currency_object = currency.Currency.from_value(NOT_RECOMMENDED_HEX_CODE)
//            self.assertEqual(currency_object.to_json(), NOT_RECOMMENDED_HEX_CODE)
//    }
//
//    func test_raises_invalid_value_type() {
//            invalid_value = [1, 2, 3]
//            self.assertRaises(
//                XRPLBinaryCodecException, currency.Currency.from_value, invalid_value
//            )
//    }
//
//    func test_raises_invalid_xrp_encoding() {
//            self.assertRaises(
//                XRPLBinaryCodecException, currency.Currency.from_value, ILLEGAL_XRP_HEX_CODE
//            )
//    }
}

