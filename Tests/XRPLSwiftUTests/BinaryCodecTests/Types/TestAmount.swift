//
//  TestAmount.swift
//
//
//  Created by Denis Angell on 7/4/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/tests/unit/core/binarycodec/types/test_amount.py

import XCTest
@testable import XRPLSwift

let IOU_CASES: [String: [String: String]] = [
    "800000000000000000000000000000000000000055534400000000008B1CE810C13D6F337DAC85863B3D70265A24DF44":
    [
        "value": "0",
        "currency": "USD",
        "issuer": "rDgZZ3wyprx4ZqrGQUkquE9Fs2Xs8XBcdw"
    ],
    "D4838D7EA4C6800000000000000000000000000055534400000000008B1CE810C13D6F337DAC85863B3D70265A24DF44":
    [
        "value": "1",
        "currency": "USD",
        "issuer": "rDgZZ3wyprx4ZqrGQUkquE9Fs2Xs8XBcdw"
    ],
    "D4871AFD498D000000000000000000000000000055534400000000008B1CE810C13D6F337DAC85863B3D70265A24DF44":
    [
        "value": "2",
        "currency": "USD",
        "issuer": "rDgZZ3wyprx4ZqrGQUkquE9Fs2Xs8XBcdw"
    ],
    "94871AFD498D000000000000000000000000000055534400000000008B1CE810C13D6F337DAC85863B3D70265A24DF44":
    [
        "value": "-2",
        "currency": "USD",
        "issuer": "rDgZZ3wyprx4ZqrGQUkquE9Fs2Xs8XBcdw"
    ],
    "D48775F05A07400000000000000000000000000055534400000000008B1CE810C13D6F337DAC85863B3D70265A24DF44":
    [
        "value": "2.1",
        "currency": "USD",
        "issuer": "rDgZZ3wyprx4ZqrGQUkquE9Fs2Xs8XBcdw"
    ],
    "D48775F05A07400000000000000000000000000000000000000000000000000000000000000000000000000000000000":
    [
        "currency": "XRP",
        "value": "2.1",
        "issuer": "rrrrrrrrrrrrrrrrrrrrrhoLvTp",
    ],
    "D843F28CB71571C700000000000000000000000055534400000000000000000000000000000000000000000000000001":
    [
        "currency": "USD",
        "value": "1111111111111111",
        "issuer": "rrrrrrrrrrrrrrrrrrrrBZbvji",
    ]
]

let XRP_CASES: [String: String] = [
    "100": "4000000000000064",
    "100000000000000000": "416345785D8A0000"
]

final class TestUAmount: XCTestCase {

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
            "0",
            "0.0",
            "1",
            "1.1111",
            "-1",
            "-1.1",
            "1111111111111111.0",
            "-1111111111111111.0",
            "0.00000000001",
            "0.00000000001",
            "-0.00000000001",
            "1.111111111111111e-3",
            "-1.111111111111111e-3",
            "2E+2"
        ]
        for v in variables {
            try! verifyIouValue(issuedCurrencyValue: v)
        }
    }

    // NOT SWIFT IMPLEMENTATION
//    func testRaisesInvalidValueType() {
//        invalid_value = [1, 2, 3]
//        self.assertRaises(
//            XRPLBinaryCodecException, amount.Amount.from_value, invalid_value
//        )
//    }

    func testFromValueIssuedCurrency() {
        for (serialized, json) in IOU_CASES {
            let amountObject: xAmount = try! xAmount.from(value: json)
            XCTAssertEqual(amountObject.toHex(), serialized)
        }
    }

    func testFromValueXrp() {
        for (json, serialized) in XRP_CASES {
            let amountObject: xAmount = try! xAmount.from(value: json)
            XCTAssertEqual(amountObject.toHex(), serialized)
        }
    }

    func testToJsonIssuedCurrency() {
        for (serialized, json) in IOU_CASES {
            let parser: BinaryParser = BinaryParser(hex: serialized)
            let amountObject: xAmount = try! xAmount().fromParser(parser: parser)
            let result: Any = amountObject.toJson()
            XCTAssertEqual(result as! [String: String], json)
        }
    }

    func testToJsonXrp() {
        for (json, serialized) in XRP_CASES {
            let parser: BinaryParser = BinaryParser(hex: serialized)
            let amountObject: xAmount = try! xAmount().fromParser(parser: parser)
            let result: Any = amountObject.toJson()
            XCTAssertEqual(result as! String, json)
        }
    }
    
    func testFixtures() {
        for fixture in dataDrivenFixturesForType(typeString: "Amount") {
            TestUSerializedType.fixtureTest(fixture: fixture)
        }
    }
}
