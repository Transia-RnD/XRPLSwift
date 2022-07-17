//
//  TestAmount.swift
//
//
//  Created by Denis Angell on 7/4/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/tests/unit/core/binarycodec/types/test_amount.py

import XCTest
@testable import XRPLSwift

final class TestAmount: XCTestCase {
    
    static let HEX_ENCODING: String = "5E7B112523F68D2F5E879DB4EAC51C6698A69304"
    static let BASE58_ENCODING: String = "r9cZA1mLK5R5Am25ArfXFmqgNwjZgnfk59"
    
    func testAssertXrpIsValidPasses() {
        let validZero: String = "0"
        let validAmount: String = "1000"
        try! verifyXrpValue(xrpValue: validZero)
        try! verifyXrpValue(xrpValue: validAmount)
    }
    
    func testAssertXrpIsValidRaises() {
        let invalidAmountLarge: String = "1e20"
        let invalidAmountSmall: String = "1e-7"
        let invalidAmountDecimal: String = "1.234"
        XCTAssertThrowsError(try verifyXrpValue(xrpValue: invalidAmountLarge))
        XCTAssertThrowsError(try verifyXrpValue(xrpValue: invalidAmountSmall))
        XCTAssertThrowsError(try verifyXrpValue(xrpValue: invalidAmountDecimal))
    }
    
    func testIOUIsValid() {
        let variables: [String] = [
//            "0",
//            "0.0",
//            "1",
//            "1.1111",
//            "-1",
//            "-1.1",
//            "1111111111111111.0",
//            "-1111111111111111.0",
            "0.00000000001",
//            "0.00000000001",
//            "-0.00000000001",
//            "1.111111111111111e-3",
//            "-1.111111111111111e-3",
//            "2E+2",
        ]
        for v in variables {
            try! verifyIouValue(issuedCurrencyValue: v)
        }
    }
}
