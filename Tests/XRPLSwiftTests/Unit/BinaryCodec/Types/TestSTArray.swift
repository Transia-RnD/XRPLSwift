//
//  TestSTArray.swift
//  
//
//  Created by Denis Angell on 7/16/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/tests/unit/core/binarycodec/types/test_serialized_list.py

import Foundation

let MEMO: [String: AnyObject] = [
    "Memo": [
        "MemoType": "687474703A2F2F6578616D706C652E636F6D2F6D656D6F2F67656E65726963",
        "MemoData": "72656E74"
    ]
] as [String: AnyObject]
let MEMO_HEX: String = "EA7C1F687474703A2F2F6578616D706C652E636F6D2F6D656D6F2F67656E657269637D0472656E74E1"

let EXPECTED_JSON: [[String: AnyObject]] = [MEMO, MEMO]

let BUFFER: String = MEMO_HEX + MEMO_HEX + ARRAY_END_MARKER.toHexString().uppercased()

import XCTest
@testable import XRPLSwift

final class TestSTArray: XCTestCase {
    public static let maxDiff: Int = 1000

    func testFromValue() {
        let serializedList: STArray = try! STArray.from(value: EXPECTED_JSON)
        XCTAssertEqual(BUFFER, serializedList.str())
    }

    func testFromParser() {
        let parser: BinaryParser = BinaryParser(hex: BUFFER)
        let serializedList: SerializedType = STArray().fromParser(parser: parser, hint: nil)
        XCTAssertEqual(BUFFER, serializedList.str())
    }

    func testFromValueToJson() {
        let serializedList: STArray = try! STArray.from(value: EXPECTED_JSON)
        let actualJson: [[String: AnyObject]] = serializedList.toJson()
//        XCTAssertEqual(actualJson[0], actualJson[1])
//        XCTAssertEqual(actualJson, EXPECTED_JSON)
    }

    func testFromParserToJson() {
        let parser: BinaryParser = BinaryParser(hex: BUFFER)
        let serializedList: STArray = STArray().fromParser(parser: parser)
//        XCTAssertEqual(serializedList.toJson() as? [[String: AnyObject]], EXPECTED_JSON)
    }

//    func testFromValueNonList():
//        obj = 123
//        with self.assertRaises(XRPLBinaryCodecException):
//            STArray.from_value(obj)

//    func testFromValueBadList():
//        obj = [123]
//        with self.assertRaises(XRPLBinaryCodecException):
//            STArray.from_value(obj)
//
//    func testRaisesInvalidValueType():
//        invalid_value = 1
//        self.assertRaises(
//            XRPLBinaryCodecException,
//            STArray.from_value,
//            invalid_value,
//        )
}
