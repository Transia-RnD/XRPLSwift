//
//  TestFieldIDCodec.swift
//  
//
//  Created by Denis Angell on 7/4/22.
//

import XCTest
@testable import XRPLSwift

final class TestFieldIDCodec: XCTestCase {

    static let fieldTests: [FieldTest] = DataDrivenFixtures().getFieldTests()

    func testEncode() {
        for test in TestFieldIDCodec.fieldTests {
            let result: String = try! FieldIdCodec.encode(fieldName: test.name).toHexString().uppercased()
            XCTAssertEqual(test.expectedHex, result)
        }
    }

    func testDecode() {
        for test in TestFieldIDCodec.fieldTests {
            let result: String = try! FieldIdCodec.decode(fieldId: test.expectedHex)
            XCTAssertEqual(test.name, result)
        }
    }
}

