//
//  TestVector256.swift
//  
//
//  Created by Denis Angell on 7/12/22.
//

// https://github.com/XRPLF/xrpl-py/blob/master/tests/unit/core/binarycodec/types/test_vector256.py

import XCTest
@testable import XRPLSwift

private let HASH1: String = "42426C4D4F1009EE67080A9B7965B44656D7714D104A72F9B4369F97ABF044EE"
private let HASH2: String = "4C97EBA926031A7CF7D7B36FDE3ED66DDA5421192D63DE53FFB46E43B9DC8373"

final class TestVector256: XCTestCase {

    private let HASH_LIST: [String] = [HASH1, HASH2]
    private let SERIALIZED: String = HASH1 + HASH2

    func testFromValue() {
        let vector256Object: Vector256 = try! Vector256.from(value: HASH_LIST)
        XCTAssertEqual(vector256Object.toHex(), SERIALIZED)
    }

    func testFromParser() {
        let vector256Object: Vector256 = try! Vector256.from(value: HASH_LIST)
        XCTAssertEqual(vector256Object.toHex(), SERIALIZED)
    }

    func testToJson() {
        let vector256Object: Vector256 = try! Vector256.from(value: HASH_LIST)
        XCTAssertEqual(try vector256Object.toJson(), HASH_LIST)
    }

//    // This test is not necessary in Swift?
//    func testRaisesInvalidValueType() {
//        let invalidValue: Int = 1
//        XCTAssertThrowsError(try! Vector256(bytes: []).from(value: invalidValue))
//    }
}
