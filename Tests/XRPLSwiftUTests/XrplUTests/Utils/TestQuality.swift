//
//  TestQuality.swift
//  
//
//  Created by Denis Angell on 10/15/22.
//

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/test/utils/quality.test.ts

import XCTest
@testable import XRPLSwift

// TODO: FIX THIS TEST
//class QualityUtilsTests: XCTestCase {
//    func testConverts101PercentToValidQuality() throws {
//        let billionths = try percentToQuality("101%")
//        XCTAssertEqual(billionths, 1010000000)
//    }
//
//    func testConverts1_01ToValidQuality() throws {
//        XCTAssertEqual(try decimalToQuality("1.01"), 1010000000)
//        XCTAssertEqual(try qualityToDecimal(1010000000), "1.01")
//    }
//
//    func testConverts99PercentToValidQuality() throws {
//        let billionths = try percentToQuality("99%")
//        XCTAssertEqual(billionths, 990000000)
//    }
//
//    func testConverts_99ToValidQuality() throws {
//        XCTAssertEqual(try decimalToQuality(".99"), 990000000)
//        XCTAssertEqual(try qualityToDecimal(990000000), "0.99")
//    }
//
//    func testConverts100PercentTo0() throws {
//        let billionths = try percentToQuality("100%")
//        XCTAssertEqual(billionths, 0)
//    }
//
//    func testConverts1_00PercentTo0() throws {
//        XCTAssertEqual(try decimalToQuality("1.00"), 0)
//        XCTAssertEqual(try qualityToDecimal(0), "1")
//    }
//
//    func testThrowsWhenPercentQualityGreaterThanMaximumPrecision() throws {
//        XCTAssertThrowsError(try percentToQuality(".0000000000000011221%")) { error in
//            XCTAssertEqual(error.localizedDescription, "Decimal exceeds maximum precision.")
//        }
//    }
//
//    func testThrowsWhenDecimalQualityGreaterThanMaximumPrecision() throws {
//        XCTAssertThrowsError(try decimalToQuality(".000000000000000011221")) { error in
//            XCTAssertEqual(error.localizedDescription, "Decimal exceeds maximum precision.")
//        }
//    }
//
//    func testPercentToQualityThrowsWithGibberish() throws {
//        XCTAssertThrowsError(try percentToQuality("3dsadflk%")) { error in
//            XCTAssertEqual(error.localizedDescription, "Value is not a number")
//        }
//    }
//
//    func testDecimalToQualityThrowsWithGibberish() throws {
//        XCTAssertThrowsError(try decimalToQuality("3dsadflk%")) { error in
//            XCTAssertEqual(error.localizedDescription, "Value is not a number")
//        }
//    }
//}
