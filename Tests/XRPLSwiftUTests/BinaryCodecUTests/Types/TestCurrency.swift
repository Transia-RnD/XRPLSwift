//
//  TestCurrency.swift
//
//
//  Created by Denis Angell on 7/4/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/tests/unit/core/binarycodec/types/test_currency.py

import XCTest
@testable import XRPLSwift

final class TestUCurrency: XCTestCase {

    public let XRP_HEX_CODE: String = "0000000000000000000000000000000000000000"
    public let ILLEGAL_XRP_HEX_CODE: String = "0000000000000000000000005852500000000000"
    public let USD_HEX_CODE: String = "0000000000000000000000005553440000000000"
    public let NONSTANDARD_HEX_CODE: String = "015841551A748AD2C1F76FF6ECB0CCCD00000000"
    public let NOT_RECOMMENDED_HEX_CODE: String = "0000000000414C6F676F30330000000000000000"
    public let XRP_ISO: String = "XRP"
    public let USD_ISO: String = "USD"

    func testIsIsoCode() {
        let validCode: String = "ABC"
        let validCodeNumeric: String = "123"
        let invalidCodeLong: String = "LONG"
        let invalidCodeShort: String = "NO"
        XCTAssertTrue(isIsoCode(value: validCode))
        XCTAssertTrue(isIsoCode(value: validCodeNumeric))
        XCTAssertFalse(isIsoCode(value: invalidCodeLong))
        XCTAssertFalse(isIsoCode(value: invalidCodeShort))
    }

    func testIsHex() {
        // Valid = 40 char length and only valid hex chars
        let validHex: String = "0000000000000000000000005553440000000000"
        let invalidHexLong: String = "0000000000000000000000005553440000000000123455"
        let invalidHexShort: String = "1234"
        let invalidHexChars: String = "USD0000000000000000000005553440000000000"
        XCTAssertTrue(isHex(value: validHex))
        XCTAssertFalse(isHex(value: invalidHexLong))
        XCTAssertFalse(isHex(value: invalidHexShort))
        XCTAssertFalse(isHex(value: invalidHexChars))
    }

    func testIsoToBytes() {
        // Valid non-XRP
        let usdIsoBytes = try! isoToBytes(iso: USD_ISO)
        // convert bytes to hex string for comparison to expectation
        XCTAssertEqual(usdIsoBytes.toHexString(), USD_HEX_CODE)

        // Valid XRP
        let xrpIsoBytes = try! isoToBytes(iso: XRP_ISO)
        // convert bytes to hex string for comparison to expectation
        XCTAssertEqual(xrpIsoBytes.toHexString(), XRP_HEX_CODE)

        // Error case
        let invalidIso: String = "INVALID"
        XCTAssertThrowsError(try isoToBytes(iso: invalidIso))
    }

    func testConstructionFromHexStandard() {
        // XRP case
        let currencyObject: xCurrency = try! xCurrency.from(value: XRP_HEX_CODE)
        XCTAssertEqual(currencyObject.toJson(), XRP_ISO)

        // General case
        let currencyObject1: xCurrency = try! xCurrency.from(value: USD_HEX_CODE)
        XCTAssertEqual(currencyObject1.toJson(), USD_ISO)

    }

    func testConstructionFromIsoCodeStandard() {
        // XRP case
        let currencyObject: xCurrency = try! xCurrency.from(value: XRP_ISO)
        XCTAssertEqual(currencyObject.toHex(), XRP_HEX_CODE)

        // General case
        let currencyObject1: xCurrency = try! xCurrency.from(value: USD_ISO)
        XCTAssertEqual(currencyObject1.toHex(), USD_HEX_CODE)
    }

    func testConstructionFromHexNonstandard() {
        let currencyObject: xCurrency = try! xCurrency.from(value: NONSTANDARD_HEX_CODE)
        XCTAssertEqual(currencyObject.toJson(), NONSTANDARD_HEX_CODE)
    }

    func testConstructionFromHexNonrecommended() {
        let currencyObject: xCurrency = try! xCurrency.from(value: NOT_RECOMMENDED_HEX_CODE)
        XCTAssertEqual(currencyObject.toJson(), NOT_RECOMMENDED_HEX_CODE)
    }

    // MARK: INVALID SWIFT IMPLEMENTATION
//    func testRaisesInvalidValueType() {
//        let invalidValue = [1, 2, 3]
//        XCTAssertThrowsError(Currency.from(value: invalidValue))
//    }

    // TODO: FIX THIS
//    func testRaisesInvalidXrpEncoding() {
//        XCTAssertThrowsError(try xCurrency.from(value: ILLEGAL_XRP_HEX_CODE))
//    }
}
