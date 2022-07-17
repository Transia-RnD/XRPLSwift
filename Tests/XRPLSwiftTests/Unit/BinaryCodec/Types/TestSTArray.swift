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
        "MemoData": "72656E74",
    ]
] as [String: AnyObject]
let MEMO_HEX: String = "EA7C1F687474703A2F2F6578616D706C652E636F6D2F6D656D6F2F67656E657269637D0472656E74E1"

let EXPECTED_JSON: [[String: AnyObject]] = [MEMO, MEMO]

let BUFFER: String = MEMO_HEX + MEMO_HEX + ARRAY_END_MARKER.toHexString()

import XCTest
@testable import XRPLSwift

final class TestSTArray: XCTestCase {
    public static let maxDiff: Int = 1000
    
    func testFromValue() {
        let serializedList: STArray = try! STArray().from(value: EXPECTED_JSON)
        XCTAssertEqual(BUFFER, serializedList.str())
    }

//    func testFrom_parser():
//        parser = BinaryParser(BUFFER)
//        serialized_list = STArray.from_parser(parser)
//        self.assertEqual(BUFFER, str(serialized_list))
//
//    func testFromValueToJson():
//        serialized_list = STArray.from_value(EXPECTED_JSON)
//        actual_json = serialized_list.to_json()
//        self.assertEqual(actual_json[0], actual_json[1])
//        self.assertEqual(actual_json, EXPECTED_JSON)
//
//    func testFromParserToJson():
//        parser = BinaryParser(BUFFER)
//        serialized_list = STArray.from_parser(parser)
//        self.assertEqual(serialized_list.to_json(), EXPECTED_JSON)
//
//    func testFromValueNonList():
//        obj = 123
//        with self.assertRaises(XRPLBinaryCodecException):
//            STArray.from_value(obj)
//
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
